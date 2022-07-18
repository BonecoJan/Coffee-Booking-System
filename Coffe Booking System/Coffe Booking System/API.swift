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
        case encodingError
        case custom(errorMessage: String)
    }
    
    struct empty: Codable {}
    
    struct ChangeResponse: Codable {
        let response: String
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
        let expiration: Int?
    }
    
    struct RegisterResponse: Codable {
        let id: String?
    }

    
    
    //generic request function
    func request<Request: Encodable, Response: Decodable>(
        allowRetry: Bool = true,
        reqUrl: String,
        reqMethod: String,
        authReq: Bool,
        body: Request? = nil,
        responseType: Response.Type
    ) async throws -> Response {
        
        guard let url = URL(string: apiUrl + reqUrl) else {
            throw NetworkError.invalidURL
        }
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = reqMethod
        
        if reqMethod != "GET" {
            httpRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        }
        
        if let body = body {
            do {
                httpRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingError
            }
        }
        
        if authReq {
            httpRequest = try await authorizedRequest(with: httpRequest)
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(for: httpRequest)
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await request(allowRetry: false, reqUrl: reqUrl, reqMethod: reqMethod, authReq: authReq, body: body, responseType: responseType)
            }

            throw AuthenticationError.invalidCredentials
        }

        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response
        } catch {
            //if there is no data response but a string with change status
            let response = ChangeResponse(response: String(data: data, encoding: .utf8)!)
            print(response)
            return response as! Response
        }
    
    }
    
    private func authorizedRequest(with urlRequest: URLRequest) async throws -> URLRequest {
        var urlRequest = urlRequest
        let token = try await authManager.validToken()
        urlRequest.setValue("Bearer " + (token.token)!, forHTTPHeaderField: "Authorization")
        return urlRequest
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
        KeychainWrapper.standard.create(Data(password.utf8), service: "password", account: "Coffe-Booking-System")
                        
        return loginResponse
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
