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
    
    struct RegisterRequest: Codable {
        let id: String?
        let name: String
        let password: String?
    }
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var error: String = ""
    
    func login(profilVM: ProfileViewModel) {
        self.isLoading = true
        Task {
            do {
                let loginResponse = try await WebService(authManager: AuthManager())
                    .request(reqUrl: "login", reqMethod: "POST", authReq: false, body: LoginRequestBody(id: id, password: password), responseType: LoginResponse.self, unknownType: false)
                
                KeychainWrapper.standard.create(Data((loginResponse.token!).utf8), service: "access-token", account: "Coffe-Booking-System")
                KeychainWrapper.standard.create(Data(password.utf8), service: "password", account: "Coffe-Booking-System")
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    self.success = true
                    profilVM.loadUserData()
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    if error.localizedDescription == "missing token" {
                        self.error = "ID or password incorrect"
                    } else {
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func register(id: String, name: String, password: String, profilVM: ProfileViewModel) {
        self.isLoading = true
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "POST", authReq: false, body: RegisterRequest(id: id, name: name, password: password), responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == id {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.id = id
                        self.password = password
                        self.login(profilVM: profilVM)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        KeychainWrapper.standard.delete(service: "access-token", account: "Coffe-Booking-System")
        KeychainWrapper.standard.delete(service: "password", account: "Coffe-Booking-System")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}
