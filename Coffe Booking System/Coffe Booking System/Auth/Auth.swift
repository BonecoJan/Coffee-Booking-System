import Foundation
import JWTDecode

actor AuthManager {
    
    struct Token: Codable {
        let token: String?
        let expiration: Int?
    }

    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?


    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }
        
//        guard let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8) else {
//            throw AuthError.missingToken
//        }
        
        if let tokenID = KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System") {
            let tokenID = String(data: tokenID, encoding: .utf8)!
            
            
            let jwt = try decode(jwt: tokenID)
            
            let token = Token(token: tokenID, expiration: Int(jwt.expiresAt!.timeIntervalSince1970 * 1000))
            
            if !(jwt.expired) {
                return token
            }

            return try await refreshToken()
            
        } else {
            throw WebService.RequestError.custom(errorMessage: "missing token")
        }

    }

    func refreshToken() async throws -> Token {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () throws -> Token in
            defer { refreshTask = nil }
            
//            guard let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8) else {
//                throw AuthError.missingToken
//            }
            if let tokenID = KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System") {
                let tokenID = String(data: tokenID, encoding: .utf8)!
                
                let jwt = try decode(jwt: tokenID)
                
                let userID = jwt.claim(name: "id").string!
                let password = String(data: KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System")!, encoding: .utf8)!
                
                //refresh the token
                let response = try await WebService(authManager: self).refreshToken(id: userID, password: password)
                
                return Token(token: response.token, expiration: response.expiration)
                
                
            } else {
                throw WebService.RequestError.custom(errorMessage: "missing token")
            }
        }

        self.refreshTask = task

        return try await task.value
    }

}
