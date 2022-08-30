import Foundation

class LoginController: ObservableObject {
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var error: String = ""
    
    func login(shop: Shop, profileController: ProfileController) {
        self.isLoading = true
        Task {
            do {
                let loginResponse = try await WebService(authManager: AuthManager())
                    .request(reqUrl: "login", reqMethod: POST, authReq: false, body: Request.Login.User(id: id, password: password), responseType: Response.Login.User.self, unknownType: false)
                
                KeychainWrapper.standard.create(Data((loginResponse.token!).utf8), service: SERVICE_TOKEN, account: ACCOUNT)
                KeychainWrapper.standard.create(Data(password.utf8), service: SERVICE_PASSWORD, account: ACCOUNT)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    self.success = true
                    profileController.loadUserData(shop: shop)
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    if error.localizedDescription == ERROR_TOKEN {
                        self.error = ERROR_LOGIN
                    } else {
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func register(shop: Shop, id: String, name: String, password: String, profileController: ProfileController) {
        self.isLoading = true
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "POST", authReq: false, body: Request.Register.User(id: id, name: name, password: password), responseType: NoJSON.self, unknownType: false)
                print(response.response)
                if response.response == id {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.id = id
                        self.password = password
                        self.login(shop: shop, profileController: profileController)
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
    
    func logout(shop: Shop) {
        KeychainWrapper.standard.delete(service: SERVICE_TOKEN, account: ACCOUNT)
        KeychainWrapper.standard.delete(service: SERVICE_PASSWORD, account: ACCOUNT)
        DispatchQueue.main.async {
            self.isAuthenticated = false
            shop.profile = Profile()
        }
    }
}
