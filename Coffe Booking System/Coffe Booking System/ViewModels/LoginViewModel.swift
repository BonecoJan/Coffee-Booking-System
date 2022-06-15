import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        let defaults = UserDefaults.standard
        
        WebService().login(id: id, password: password) { result in
            switch result {
                case .success(let loginResponse):
                print(loginResponse.token)
                print(loginResponse.expiration) // Use expiration for automatic token refresh
                defaults.setValue(loginResponse.token, forKey: "jsonwebtoken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jsonwebtoken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}
