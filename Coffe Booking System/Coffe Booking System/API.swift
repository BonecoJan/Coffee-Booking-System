import Foundation

class WebService {
    
    let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    //API-url
    let apiUrl = "http://141.51.114.20:8080/"

    enum AuthenticationError: Error {
        case invalidCredentials
        case custom(errorMessage: String)
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }
    
    struct LoginRequestBody: Codable {
        let id: String
        let password: String
    }
    
    struct RegisterRequestBody: Codable {
        let id: String
        let name: String
        let password: String
    }
    
    struct LoginResponse: Codable {
        let token: String?
        let expiration: Int? //Use for token refresh?
    }
    
    struct RegisterResponse: Codable {
        let id: String?
    }
    
    struct UsersResponse: Codable, Identifiable {
        let id: String
        let name: String
    }
    
    struct UserResponse: Codable, Identifiable {
        let id: String?
        let name: String?
        let balance: Double?
    }
    
    struct ItemResponse: Codable, Identifiable {
        let id: String
        let name: String
        let amount: Int
        let price: Double
    }
    
    
    private func authorizedRequest(from url: URL) async throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        let token = try await authManager.validToken()
        urlRequest.setValue("Bearer " + (token.token)! + "1", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
//    func loadAuthorized<T: Decodable>(_ url: URL, allowRetry: Bool = true) async throws -> T {
//        let request = try await authorizedRequest(from: url)
//        let (data, urlResponse) = try await URLSession.shared.data(for: request)
//
//        // check the http status code and refresh + retry if we received 401 Unauthorized
//        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
//            if allowRetry {
//                _ = try await authManager.refreshToken()
//                return try await loadAuthorized(url, allowRetry: false)
//            }
//
//            throw AuthenticationError.invalidCredentials
//        }
//
//        let decoder = JSONDecoder()
//        let response = try decoder.decode(T.self, from: data)
//
//        return response
//    }
    
    func getUser(allowRetry: Bool = true) async throws -> UserResponse {
        
        let userID = String(data: KeychainWrapper.standard.get(service: "user-id", account: "Coffe-Booking-System")!, encoding: .utf8)!
        
        let url = URL(string: apiUrl + "users/" + userID)
        
        let request = try await authorizedRequest(from: url!)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await getUser(allowRetry: false)
            }

            throw AuthenticationError.invalidCredentials
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(UserResponse.self, from: data)

        return response
    }
    
    func refreshToken(id: String, password: String) async throws -> LoginResponse {
        
        let url = URL(string: apiUrl + "login")
        
        let body = LoginRequestBody(id: id, password: password)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = try? JSONEncoder().encode(body)
            
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
            
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw AuthenticationError.invalidCredentials
        }

        let decoder = JSONDecoder()
        let loginResponse = try decoder.decode(LoginResponse.self, from: data)
            
        KeychainWrapper.standard.create(Data((loginResponse.token!).utf8), service: "access-token", account: "Coffe-Booking-System")
        KeychainWrapper.standard.create(Data(String(loginResponse.expiration!).utf8), service: "access-token-expiration", account: "Coffe-Booking-System")
        KeychainWrapper.standard.create(Data(id.utf8), service: "user-id", account: "Coffe-Booking-System")
        KeychainWrapper.standard.create(Data(password.utf8), service: "password", account: "Coffe-Booking-System")
                        
        return loginResponse
    }
    
    //send a login-request to server and save credentials on device
    func login(id: String, password: String, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void) {
        
        guard let url = URL(string: apiUrl + "login") else {
            completion(.failure(.custom(errorMessage: "URL is incorrect")))
            return
        }
        
        let body = LoginRequestBody(id: id, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            completion(.success(loginResponse))
            
            KeychainWrapper.standard.create(Data((loginResponse.token!).utf8), service: "access-token", account: "Coffe-Booking-System")
            KeychainWrapper.standard.create(Data(String(loginResponse.expiration!).utf8), service: "access-token-expiration", account: "Coffe-Booking-System")
            KeychainWrapper.standard.create(Data(id.utf8), service: "user-id", account: "Coffe-Booking-System")
            KeychainWrapper.standard.create(Data(password.utf8), service: "password", account: "Coffe-Booking-System")
                        
        }.resume()
        
    }
    
    func register(id: String, name: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let url = URL(string: apiUrl + "users") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body = RegisterRequestBody(id: id, name: name, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.noData))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    
    func getItems(completion: @escaping ([ItemResponse]) -> Void) {
        guard let url = URL(string: apiUrl + "items") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in let items = try! JSONDecoder().decode([ItemResponse].self, from: data!)
            DispatchQueue.main.async {
                completion(items)
            }
        }
        .resume()
    }
    
    
    func getUsers(completion: @escaping ([UsersResponse]) -> Void) {
        guard let url = URL(string: apiUrl + "users") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in let users = try! JSONDecoder().decode([UsersResponse].self, from: data!)
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
}
