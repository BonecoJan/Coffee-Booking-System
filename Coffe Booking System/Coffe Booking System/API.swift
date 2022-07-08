import Foundation
import JWTDecode

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
        let id: String
        let name: String
        let balance: Double
    }
    
    struct UserTransactions: Codable {
        let type: String
        let value: Double
        let timestamp: Int
    }
    
    struct ItemResponse: Codable, Identifiable {
        let id: String
        let name: String
        let amount: Int
        let price: Double
    }
    
    struct PurchaseItemBody: Codable {
        let itemId: String
        let amount: Int
    }
    
    struct ChangeUserBody: Codable {
        let name: String
        let password: String
    }
    
    struct CreateUserBody: Codable {
        let id: String?
        let name: String
        let isAdmin: Bool
        let password: String?
    }
    
    struct FundingBody: Codable {
        let amount: Double
    }
    
    
    private func authorizedRequest(with urlRequest: URLRequest) async throws -> URLRequest {
        var urlRequest = urlRequest
        let token = try await authManager.validToken()
        urlRequest.setValue("Bearer " + (token.token)!, forHTTPHeaderField: "Authorization")
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
   
    func deleteUser(allowRetry: Bool = true) async throws -> Void {

        let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8)!
        let jwt = try decode(jwt: tokenID)
        let userID = jwt.claim(name: "id").string!

        let url = URL(string: apiUrl + "users/" + userID)

        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await deleteUser(allowRetry: false)
            }

            throw AuthenticationError.invalidCredentials
        }

//        let decoder = JSONDecoder()
//        let response = try decoder.decode(UserResponse.self, from: data)
//        print(response)
    }

    
    func deleteItem(allowRetry: Bool = true, itemID: String) async throws -> Void {

        let url = URL(string: apiUrl + "items/" + itemID)

        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await deleteUser(allowRetry: false)
            }

            throw AuthenticationError.invalidCredentials
        }
    }

    
    func changeUser(allowRetry: Bool = true, name: String, password: String) async throws -> Void {

        let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8)!
        let jwt = try decode(jwt: tokenID)
        let userID = jwt.claim(name: "id").string!

        let url = URL(string: apiUrl + "users/" + userID)

        let body = ChangeUserBody(name: name, password: password)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)

        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)

        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await changeUser(allowRetry: false, name: name, password: password)
            }

            throw AuthenticationError.invalidCredentials
        }

//        let decoder = JSONDecoder()
//        let response = try decoder.decode(UserResponse.self, from: data)
    }

    
    func changeUserAdmin(allowRetry: Bool = true,id: String,  name: String, isAdmin: Bool, password: String) async throws -> Void {

        let url = URL(string: apiUrl + "users/admin")

        let body = CreateUserBody(id: id, name: name, isAdmin: isAdmin, password: password)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)

        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)

        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await changeUserAdmin(allowRetry: false,id: id, name: name, isAdmin: isAdmin, password: password)
            }

            throw AuthenticationError.invalidCredentials
        }
    }

    
    func purchaseItem(allowRetry: Bool = true, id: String, amount: Int) async throws -> Void {

        let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8)!
        let jwt = try decode(jwt: tokenID)
        let userID = jwt.claim(name: "id").string!

        let url = URL(string: apiUrl + "users/" + userID + "/purchases")

        let body = PurchaseItemBody(itemId: id, amount: amount)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        //print(urlResponse)
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await purchaseItem(allowRetry: false, id: id, amount: amount)
            }
            throw AuthenticationError.invalidCredentials
        }
        
//        let decoder = JSONDecoder()
//        let response = try decoder.decode(UserResponse.self, from: data)

    }

    
    func createUser(allowRetry: Bool = true, id: String, name: String, isAdmin: Bool, password: String) async throws {
        let url = URL(string: apiUrl + "users/admin")
        
        let body = CreateUserBody(id: id, name: name, isAdmin: isAdmin, password: password)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)

        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await createUser(id: id, name: name, isAdmin: isAdmin, password: password)
            }
            throw AuthenticationError.invalidCredentials
        }
    }
    
    
    func createItem(allowRetry: Bool = true, id: String, name: String, amount: Int, price: Double) async throws {
        let url = URL(string: apiUrl + "/items")
        
        let body = ItemResponse(id: id, name: name, amount: amount, price: price)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await createItem(id: id, name: name, amount: amount, price: price)
            }
            throw AuthenticationError.invalidCredentials
        }
    }
    
        
    func changeItem(allowRetry: Bool = true, id: String, name: String, amount: Int, price: Double) async throws {
        let url = URL(string: apiUrl + "/items")
        
        let body = ItemResponse(id: id, name: name, amount: amount, price: price)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await createItem(id: id, name: name, amount: amount, price: price)
            }
            throw AuthenticationError.invalidCredentials
        }
    }
            
    
    func funding(allowRetry: Bool = true, userID: String, amount: Double) async throws {
        let url = URL(string: apiUrl + "users/" + userID + "/funding")
        
        let body = FundingBody(amount: amount)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let request = try await authorizedRequest(with: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await funding(userID: userID, amount: amount)
            }
            throw AuthenticationError.invalidCredentials
        }
    }
    
    
    func getUserTransactions(allowRetry: Bool = true) async throws -> [UserTransactions] {

        let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8)!
        let jwt = try decode(jwt: tokenID)
        let userID = jwt.claim(name: "id").string!
        //let userID = String(data: KeychainWrapper.standard.get(service: "user-id", account: "Coffe-Booking-System")!, encoding: .utf8)!

        let url = URL(string: apiUrl + "users/" + userID + "/transactions")

        let request = try await authorizedRequest(with: URLRequest(url: url!))
        let (data, urlResponse) = try await URLSession.shared.data(for: request)

        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await getUserTransactions(allowRetry: false)
            }

            throw AuthenticationError.invalidCredentials
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode([UserTransactions].self, from: data)

        return response
    }
    
    
    func getUser(allowRetry: Bool = true) async throws -> UserResponse {
        
        let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8)!
        let jwt = try decode(jwt: tokenID)
        let userID = jwt.claim(name: "id").string!
        //let userID = String(data: KeychainWrapper.standard.get(service: "user-id", account: "Coffe-Booking-System")!, encoding: .utf8)!
        
        let url = URL(string: apiUrl + "users/" + userID)
        
        let request = try await authorizedRequest(with: URLRequest(url: url!))
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
    
    
    func getItems(allowRetry: Bool = true) async throws -> [ItemResponse] {
        let url = URL(string: apiUrl + "items")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                return try await getItems(allowRetry: false)
            }

            throw AuthenticationError.invalidCredentials
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode([ItemResponse].self, from: data)
        
        return response
    }
    
    
    func getUsers(allowRetry: Bool = true) async throws -> [UsersResponse] {
        let url = URL(string: apiUrl + "users")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                return try await getUsers(allowRetry: false)
            }

            throw AuthenticationError.invalidCredentials
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode([UsersResponse].self, from: data)
        
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
//        KeychainWrapper.standard.create(Data(String(loginResponse.expiration!).utf8), service: "access-token-expiration", account: "Coffe-Booking-System")
//        KeychainWrapper.standard.create(Data(id.utf8), service: "user-id", account: "Coffe-Booking-System")
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
//            KeychainWrapper.standard.create(Data(String(loginResponse.expiration!).utf8), service: "access-token-expiration", account: "Coffe-Booking-System")
//            KeychainWrapper.standard.create(Data(id.utf8), service: "user-id", account: "Coffe-Booking-System")
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
    
}
