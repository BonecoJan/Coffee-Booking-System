import Foundation
import JWTDecode
import SwiftUI

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
    
    enum RequestError: Error {
        case invalidURL
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
        responseType: Response.Type,
        unknownType: Bool
    ) async throws -> Response {
        
        guard let url = URL(string: apiUrl + reqUrl) else {
            throw RequestError.invalidURL
        }
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = reqMethod
        
        if reqMethod != "GET" {
            httpRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        }
        
        //try to encode the body
        if let body = body {
            do {
                httpRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw RequestError.encodingError
            }
        }
        
        if authReq {
            httpRequest = try await authorizedRequest(with: httpRequest)
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(for: httpRequest)
        print(String(data: data, encoding: .utf8)!)
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if httpResponse.statusCode == 401 {
                if allowRetry {
                    _ = try await authManager.refreshToken()
                    return try await request(allowRetry: false, reqUrl: reqUrl, reqMethod: reqMethod, authReq: authReq, body: body, responseType: responseType, unknownType: unknownType)
                }
            }
            throw RequestError.custom(errorMessage: String(data: data, encoding: .utf8)! + " (StatusCode: " + String(httpResponse.statusCode) + ")")
        }
        
        if responseType == ChangeResponse.self {
            //if there is no json response but a string with change status
            let response = ChangeResponse(response: String(data: data, encoding: .utf8)!)
            print(response)
            return response as! Response
        } else {
            //If the JSON Response is more complex return the raw data and parse manually
            if unknownType {
                let rawResponse = try? JSONSerialization.jsonObject(with: data)
                return rawResponse as! Response
            }
            //try to decode fetched data
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                return response
            } catch {
                throw RequestError.decodingError
            }
        }
    }
    
    //uploading image. source: https://gist.github.com/codecat15/6c1eaa5b7ea48b26b10d907fef68abf2
    func uploadImage(allowRetry: Bool = true, image: UIImage, userID: String) async throws -> ChangeResponse {
        let url = URL(string: apiUrl + "users/" + userID + "/image")
        var httpRequest = URLRequest(url: url!)
        httpRequest.httpMethod = "POST"
        let bodyBoundary = "--------------------------\(UUID().uuidString)"
                httpRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")
        let imageData = image.jpegData(compressionQuality: 0.7)
        let requestData = createRequestBody(imageData: imageData!, boundary: bodyBoundary, attachmentKey: "profilePicture", fileName: "profilPicture.jpg")
        httpRequest = try await authorizedRequest(with: httpRequest)
        
        httpRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
                httpRequest.httpBody = requestData
        
        let (data, urlResponse) = try await URLSession.shared.data(for: httpRequest)
        // check the http status code and refresh + retry if we received 401 Unauthorized
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await uploadImage(allowRetry: true, image: image, userID: userID)
            }

            throw AuthenticationError.invalidCredentials
        }
        let response = ChangeResponse(response: String(data: data, encoding: .utf8)!)
        return response
    }
    
    func createRequestBody(imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data {
            let lineBreak = "\r\n"
            var requestBody = Data()

            requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
            requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
            requestBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
            requestBody.append(imageData)
            requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)

            return requestBody
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
            throw RequestError.custom(errorMessage: String(httpResponse.statusCode))
        }

        let decoder = JSONDecoder()
        let loginResponse = try decoder.decode(LoginResponse.self, from: data)
            
        KeychainWrapper.standard.create(Data((loginResponse.token!).utf8), service: "access-token", account: "Coffe-Booking-System")
        KeychainWrapper.standard.create(Data(password.utf8), service: "password", account: "Coffe-Booking-System")
                        
        return loginResponse
    }
}
