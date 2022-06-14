import Foundation

class LoginViewModel: ObservableObject {
    
    var id: String = ""
    var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        let defaults = UserDefaults.standard
        print(id)
        print(password)
        WebService().login(id: id, password: password) { result in
            switch result {
                case .success(let loginResponse):
                print("case success")
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
