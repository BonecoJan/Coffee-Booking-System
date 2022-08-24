import Foundation

class UserViewModel: ObservableObject {
    
    struct UsersResponse: Codable, Identifiable {
        var id: String
        var name: String
    }
    
    class User: ObservableObject, Identifiable {
        var userResponse: UsersResponse
        var image: ProfileViewModel.ImageResponse
        
        init(userRespose: UsersResponse) {
            self.userResponse = userRespose
            self.image = ProfileViewModel.ImageResponse(encodedImage: "empty", timestamp: 0)
        }
    }
    
    @Published var users:  [User] = []
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    func getUsers() {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self, unknownType: false)
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
    
    func getImage(user: User) {
        self.isLoading = true
        Task{
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id + "/image", reqMethod: "GET", authReq: true, body: body, responseType: ProfileViewModel.ImageResponse.self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    user.image = response
                    self.users.append(user)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.users.append(user)
                    self.isLoading = false
                    if error.localizedDescription != "No profile image associated with that ID. (StatusCode: 404)" {
                        self.hasError = true
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
}
