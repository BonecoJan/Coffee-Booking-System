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
                print(self.password)
                defaults.setValue(loginResponse.token, forKey: "jsonwebtoken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                
//                //Save data in keychain
//                //let accessToken = loginResponse.token!
//                //print(accessToken)
//                let accessToken = loginResponse.token!
//                let data = Data(accessToken.utf8)
//                KeychainWrapper.standard.create(data, service: "access-token", account: "CoffeeBooking", secClass: kSecClassKey)
//                KeychainWrapper.standard.create(Data(self.id.utf8), service: "user-id", account: "CoffeeBooking", secClass: kSecClassIdentity)
//                KeychainWrapper.standard.create(Data(self.password.utf8), service: "password", account: "CoffeeBooking", secClass: kSecClassGenericPassword)
//
//                let token = KeychainWrapper.standard.get(service: "access-token", account: "CoffeeBooking", secClass: kSecClassKey)!
//                let userID = KeychainWrapper.standard.get(service: "user-id", account: "CoffeeBooking", secClass: kSecClassIdentity)!
//                let password = KeychainWrapper.standard.get(service: "password", account: "CoffeeBooking", secClass: kSecClassGenericPassword)!
//                print(token)
//                print(userID)
//                print(password)
                
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
