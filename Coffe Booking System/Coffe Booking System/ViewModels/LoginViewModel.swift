import Foundation

class LoginViewModel: ObservableObject {
    
    struct LoginRequestBody: Codable {
        let id: String
        let password: String
    }
    
    struct LoginResponse: Codable {
        let token: String?
        let expiration: Int?
    }
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        Task {
            do {
                let loginResponse = try await WebService(authManager: AuthManager())
                    .request(reqUrl: "login", reqMethod: "POST", authReq: false, body: LoginRequestBody(id: id, password: password), responseType: LoginResponse.self)
                
                KeychainWrapper.standard.create(Data((loginResponse.token!).utf8), service: "access-token", account: "Coffe-Booking-System")
                KeychainWrapper.standard.create(Data(password.utf8), service: "password", account: "Coffe-Booking-System")
                
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } catch {
                print("failed to login")
            }
        }
    }
    
    func register() {
        //TODO: register and login afterwards
    }
    
    func logout() {
        KeychainWrapper.standard.delete(service: "access-token", account: "Coffe-Booking-System")
        KeychainWrapper.standard.delete(service: "password", account: "Coffe-Booking-System")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}
