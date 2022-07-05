import Foundation

class WebService {
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
    
    
    
    //send a login-request to server
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
    
    //send a register-request to server
    /*
    func register(/*id: String? = Optional.none, */name: String, password: String, completion: @escaping (Result<RegisterResponse, AuthenticationError>) -> Void) {
        
        guard let url = URL(string: apiUrl + "users") else {
            completion(.failure(.custom(errorMessage: "URL is incorrect")))
            return
        }
        
        let body = RegisterRequestBody(/*id: id, */name: name, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            guard let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            
            completion(.success(registerResponse))
        }.resume()
    } */
    
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
    
    func getItems(completion: @escaping ([Item]) -> Void) {
        guard let url = URL(string: apiUrl + "items") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in let items = try! JSONDecoder().decode([Item].self, from: data!)
            
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
