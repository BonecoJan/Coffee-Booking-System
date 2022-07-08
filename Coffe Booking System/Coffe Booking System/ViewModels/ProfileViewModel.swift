import Foundation
import JWTDecode

class ProfileViewModel: ObservableObject {
    
    @Published var id:  String
    @Published var name: String
    @Published var isAdmin: Bool
    
    init() {
        self.isAdmin = false
        self.name = ""
        self.id = ""
    }
    
    func loadUserData() {
        Task{
            do {
                let user = try await WebService(authManager: AuthManager()).getUser()
                DispatchQueue.main.async {
                    self.id = user.id
                    self.name = user.name
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
