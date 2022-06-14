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
    
    struct LoginResponse: Codable {
        let token: String?
        let expiration: Int? //Use for token refresh?
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
        }.resume()
    }
    
    //request all items from api (no extra repsonse-datatype needed)
    func requestAllItems(completion: @escaping (Result<[Item], NetworkError>) -> Void) {
        
        guard let url = URL(string: apiUrl + "items") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else{
                completion(.failure(.noData))
                return
            }
            
            guard let items = try? JSONDecoder().decode([Item].self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(items))
        }.resume()
    }
    
    func getItems(completion: @escaping ([Item]) -> ()) {
        guard let url = URL(string: "http://141.51.114.20:8080/items") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in let items = try! JSONDecoder().decode([Item].self, from: data!)
            
            DispatchQueue.main.async {
                completion(items)
            }
        }
        .resume()
    }
    
    func getUsers(completion: @escaping ([UsersResponse]) -> ()) {
        guard let url = URL(string: "http://141.51.114.20:8080/users") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in let users = try! JSONDecoder().decode([UsersResponse].self, from: data!)
            
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
}

