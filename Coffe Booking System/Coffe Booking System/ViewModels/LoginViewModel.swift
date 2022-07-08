import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        WebService(authManager: AuthManager()).login(id: id, password: password) { result in
            switch result {
                case .success(let loginResponse):
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
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
