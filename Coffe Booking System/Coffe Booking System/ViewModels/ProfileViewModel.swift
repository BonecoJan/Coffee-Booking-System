import Foundation
import JWTDecode
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    struct UserResponse: Codable, Identifiable {
        var id: String
        var name: String
        var balance: Double
    }
    
    @Published var id:  String
    @Published var name: String
    @Published var isAdmin: Bool
    
    init() {
        self.isAdmin = false
        self.name = ""
        self.id = ""
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
                let user = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: "GET", authReq: true, body: body, responseType: UserResponse.self)
                    
                DispatchQueue.main.async {
                    self.id = user.id
                    self.name = user.name
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
    
    func getAdminData() {
        if let data = KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System") {
        let tokenID = String(data: data, encoding: .utf8)!
        do {
            let jwt = try decode(jwt: tokenID)
            let adminInfo = jwt.body["isAdmin"]! as? Int
            if adminInfo! == 1 {
                self.isAdmin = true
            }
        } catch {
            print("Error while trying to decode token")
        }
        } else {
            print("Error while reading token")
            return
        }
    }
}
