//
//  Auth.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 04.07.22.
//

import Foundation


//struct Token: Codable {
//    let token: String?
//    let isValid: Bool
//    let expiration: Int?
//}
//
//enum AuthError: Error {
//    case missingToken
//}
//
//actor AuthManager {
//    private var currentToken: Token?
//    private var refreshTask: Task<Token, Error>?
//
//
//    func validToken() async throws -> Token {
//        if let handle = refreshTask {
//            return try await handle.value
//        }
//
//        guard let token = currentToken else {
//            throw AuthError.missingToken
//        }
//
//        if token.isValid {
//            return token
//        }
//
//        return try await refreshToken()
//    }
//
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
//            let userID = KeychainWrapper.standard.get(service: "user-id", account: "CoffeeBooking", secClass: kSecClassIdentity)!
//            let password = KeychainWrapper.standard.get(service: "password", account: "CoffeeBooking", secClass: kSecClassGenericPassword)!
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
//            WebService().login(id: id, password: password) { result in
//                switch result {
//                    case .success(let loginResponse):
//                    let newToken = Token(token: loginResponse.token, isValid: true, expiration: loginResponse.expiration)
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                }
//                return newToken
//            }
//
//
//        }
//
//        self.refreshTask = task
//
//        return try await task.value
//    }
///*
//
//    func validToken() async throws -> Token {
//
//    }
//
//    func refreshToken() async throws -> Token {
//
//    }
//*/
//}
