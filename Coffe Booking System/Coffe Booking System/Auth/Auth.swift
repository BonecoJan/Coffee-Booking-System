//
//  Auth.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 04.07.22.
//

import Foundation


struct Token: Codable {
    let token: String?
    let expiration: Int64?
}

enum AuthError: Error {
    case missingToken
}

actor AuthManager {
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?


    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }
        
        guard let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8) else {
            throw AuthError.missingToken
        }
        
        let expiration = Int64(String(data: KeychainWrapper.standard.get(service: "access-token-expiration", account: "Coffe-Booking-System")!, encoding: .utf8)!) ?? 0
        let token = Token(token: tokenID, expiration: expiration)
        let currentTimestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
        
        if expiration > currentTimestamp && expiration != 0 {
            return token
        }

        //return try await refreshToken()
        return token
    }

//    func refreshToken() async throws -> Token {
//        if let refreshTask = refreshTask {
//            return try await refreshTask.value
//        }
//
//        let task = Task { () throws -> Token in
//            defer { refreshTask = nil }
//
//            //// Normally you'd make a network call here. Could look like this:
//            //// return await networking.refreshToken(withRefreshToken: token.refreshToken)
//
//            //// I'm just generating a dummy token
//            //let tokenExpiresAt = Date().addingTimeInterval(10)
//            //let newToken = Token(token: ,isValid: true, expiration: tokenExpiresAt)
//            //currentToken = newToken
//
//            //return newToken
//
//            let userID = KeychainWrapper.standard.get(service: "user-id", account: "CoffeeBooking")!
//            let password = KeychainWrapper.standard.get(service: "password", account: "CoffeeBooking")!
//
//            WebService().login(id: String(data: userID, encoding: .utf8)!, password: String(data: password, encoding: .utf8)!) { result in
//                switch result {
//                    case .success(let loginResponse):
//                    return Token(token: loginResponse.token, isValid: true, expiration: loginResponse.expiration)
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                }
//            }
//
//            print(accessToken)
//
//
//        }
//
//        self.refreshTask = task
//
//        return try await task.value
//    }
/*

    func validToken() async throws -> Token {

    }

    func refreshToken() async throws -> Token {

    }
*/
}
