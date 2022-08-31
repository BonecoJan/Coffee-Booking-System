import Foundation
import JWTDecode

actor AuthManager {
    
    struct Token: Codable {
        let token: String?
        let expiration: Int?
    }

    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?

    //check if token is valid
    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }
        
        if let tokenID = KeychainWrapper.standard.get(service: SERVICE_TOKEN, account: ACCOUNT) {
            let tokenID = String(data: tokenID, encoding: .utf8)!
            
            
            let jwt = try decode(jwt: tokenID)
            
            let token = Token(token: tokenID, expiration: Int(jwt.expiresAt!.timeIntervalSince1970 * 1000))
            
            if !(jwt.expired) {
                return token
            }

            return try await refreshToken()
            
        } else {
            throw RequestError.custom(errorMessage: ERROR_TOKEN)
        }

    }

    //refresh token
    func refreshToken() async throws -> Token {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () throws -> Token in
            defer { refreshTask = nil }

            if let tokenID = KeychainWrapper.standard.get(service: SERVICE_TOKEN, account: ACCOUNT) {
                let tokenID = String(data: tokenID, encoding: .utf8)!
                
                let jwt = try decode(jwt: tokenID)
                
                let userID = jwt.claim(name: "id").string!
                let password = String(data: KeychainWrapper.standard.get(service: SERVICE_PASSWORD, account: ACCOUNT)!, encoding: .utf8)!
                
                //refresh the token
                let response = try await WebService(authManager: self).refreshToken(id: userID, password: password)
                
                return Token(token: response.token, expiration: response.expiration)
                
                
            } else {
                throw RequestError.custom(errorMessage: ERROR_TOKEN)
            }
        }

        self.refreshTask = task

        return try await task.value
    }

}
