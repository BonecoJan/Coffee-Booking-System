//
//  Auth.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 04.07.22.
//

import Foundation


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
        
        let expiration = Int(String(data: KeychainWrapper.standard.get(service: "access-token-expiration", account: "Coffe-Booking-System")!, encoding: .utf8)!) ?? 0
        let token = Token(token: tokenID, expiration: expiration)
        let currentTimestamp = Int(NSDate().timeIntervalSince1970 * 1000)
        
        if expiration > currentTimestamp && expiration != 0 {
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
            
            let userID = String(data: KeychainWrapper.standard.get(service: "user-id", account: "Coffe-Booking-System")!, encoding: .utf8)!
            let password = String(data: KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System")!, encoding: .utf8)!
            
            //refresh the token
            let response = try await WebService(authManager: self).refreshToken(id: userID, password: password)
            
            return Token(token: response.token, expiration: response.expiration)
        }

        self.refreshTask = task

        return try await task.value
    }

}
