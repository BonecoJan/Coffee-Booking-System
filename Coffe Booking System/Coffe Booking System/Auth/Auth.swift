import Foundation
import JWTDecode

actor AuthManager {
    
    struct Token: Codable {
        let token: String?
        let expiration: Int?
    }

    enum AuthError: Error {
        case missingToken
    }
    
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?


    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }
        
        guard let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8) else {
            throw AuthError.missingToken
        }
        
        let jwt = try decode(jwt: tokenID)
        
        let token = Token(token: tokenID, expiration: Int(jwt.expiresAt!.timeIntervalSince1970 * 1000))
        
        if !(jwt.expired) {
            return token
        }

        return try await refreshToken()
    }

    func refreshToken() async throws -> Token {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () throws -> Token in
            defer { refreshTask = nil }
            
            guard let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8) else {
                throw AuthError.missingToken
            }
            
            let jwt = try decode(jwt: tokenID)
            
            let userID = jwt.claim(name: "id").string!
            let password = String(data: KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System")!, encoding: .utf8)!
            
            //refresh the token
            let response = try await WebService(authManager: self).refreshToken(id: userID, password: password)
            
            return Token(token: response.token, expiration: response.expiration)
        }

        self.refreshTask = task

        return try await task.value
    }

}
