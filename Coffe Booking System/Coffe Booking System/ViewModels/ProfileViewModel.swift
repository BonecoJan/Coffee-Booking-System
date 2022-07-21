import Foundation
import JWTDecode
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    struct UserResponse: Codable, Identifiable {
        var id: String
        var name: String
        var balance: Double
    }
    
    struct UserRequest: Codable {
        var name: String
        var password: String
    }
    
    struct sendMoneyRequest: Codable {
        var amount: Double
        var recipientId: String
    }
    
    @Published var id:  String
    @Published var name: String
    @Published var isAdmin: Bool
    @Published var balance: Double
    @Published var success: Bool = false
    
    init() {
        self.isAdmin = false
        self.name = ""
        self.id = ""
        self.balance = 0.0
    }
    
    func loadUserData() {
        Task {
            do {
                //try to get user id from Keychain
                if let readToken = KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System") {
                let tokenID = String(data: readToken, encoding: .utf8)!
                let jwt = try decode(jwt: tokenID)
                let userID = jwt.claim(name: "id").string!
                
                let body: WebService.empty? = nil
                let user = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: "GET", authReq: true, body: body, responseType: UserResponse.self, unknownType: false)
                    
                DispatchQueue.main.async {
                    self.id = user.id
                    self.name = user.name
                    self.balance = user.balance
                }
                    
                } else {
                    print("cannot fetch current user data - missing token")
                }
                
            } catch {
                print("failed to get current user from server")
            }
        }
        self.getAdminData()
    }
    
    func updateUser(name: String) {
        self.success = false
        Task {
            do {
                //try to get user password from Keychain
                if let password = KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System") {
                let password = String(data: password, encoding: .utf8)!
                    
                let body = UserRequest(name: name, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + self.id, reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == "User updated successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.loadUserData()
                    }
                }
                }
            } catch {
                print("failed to update user with id " + self.id)
            }
        }
    }
    
    func updateUser(name: String, password: String) {
        self.success = false
        Task {
            do {
                let body = UserRequest(name: name, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + self.id, reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == "User updated successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.loadUserData()
                    }
                }
            } catch {
                print("failed to update user with id " + self.id)
            }
        }
    }
    
    func getAdminData() {
        if let data = KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System") {
        let tokenID = String(data: data, encoding: .utf8)!
        do {
            let jwt = try decode(jwt: tokenID)
            let adminInfo = jwt.body["isAdmin"]! as? Int
            if adminInfo! == 1 {
                self.isAdmin = true
            } else {
                self.isAdmin = false
            }
        } catch {
            print("Error while trying to decode token")
        }
        } else {
            print("Error while reading token")
            return
        }
    }
    
    func sendMoney(amount: Double, recipientId: String) {
        self.success = false
        Task {
            do {
                let body = sendMoneyRequest(amount: amount, recipientId: recipientId)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + self.id + "/sendMoney", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Funding processed successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.loadUserData()
                    }
                }
            } catch {
                print("failed to send money to user with id " + recipientId)
            }
        }
    }
    
    func cancelLastPurchase() {
        self.success = false
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + self.id + "/purchases/refund", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Purchase refunded successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.loadUserData()
                    }
                }
            } catch {
                print("failed to cancel last purchase")
            }
        }
    }
}
