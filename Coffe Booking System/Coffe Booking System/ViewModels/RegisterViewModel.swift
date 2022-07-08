import Foundation

class RegisterViewModel: ObservableObject {
    
    @Published var id: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var repeatedPassword : String = ""
    @Published var isRegistered: Bool = false
    
    func register(id: String, name: String, password: String){
        WebService(authManager: AuthManager()).register(id: id, name: name, password: password) { result in
            switch result {
            case .success(let registerResponse):
                print("Succsessfully registered")
                DispatchQueue.main.async {
                    self.isRegistered = registerResponse
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
