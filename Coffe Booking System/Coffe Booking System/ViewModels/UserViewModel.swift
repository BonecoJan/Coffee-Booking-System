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
    
    func getUsers() {
        Task {
            do {
                let body: WebService.empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.users = []
                    for user in users {
                        let tmpUser = User(userRespose: user)
                        self.getImage(user: tmpUser)
                    }
                }
            } catch {
                print("failed to get users from server")
            }
        }
    }
    
    func getImage(user: User) {
        Task{
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id + "/image", reqMethod: "GET", authReq: true, body: body, responseType: ProfileViewModel.ImageResponse.self, unknownType: false)
                DispatchQueue.main.async {
                    user.image = response
                    self.users.append(user)
                }
            } catch {
                print("user with id \(user.userResponse.id) has no image uploaded")
                DispatchQueue.main.async {
                    self.users.append(user)
                }
            }
        }
    }
}
