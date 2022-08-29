import Foundation

class UserController: ObservableObject {
    
    @Published var users:  [User] = []
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    func getUsers() {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: GET, authReq: false, body: body, responseType: [Response.User].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    self.users = []
                    for user in users {
                        let tmpUser = User(userRespose: user)
                        self.getImage(user: tmpUser)
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
    
    //TODO: Gleiche Funktion wie im Profil
    func getImage(user: User) {
        self.isLoading = true
        Task{
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id + "/image", reqMethod: GET, authReq: true, body: body, responseType: Response.Image.self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    user.image = response
                    self.users.append(user)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.users.append(user)
                    self.isLoading = false
                    if error.localizedDescription != ERROR_NO_IMAGE {
                        self.hasError = true
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
}