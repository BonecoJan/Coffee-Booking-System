import Foundation

class UserController: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    
    func getUsers(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: GET, authReq: false, body: body, responseType: [Response.User].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    shop.users = []
                    
                    //get and set the image of all returned users
                    for user in users {
                        self.getImage(shop: shop, user: User(userRespose: user))
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
    
    func getImage(shop: Shop, user: User) {
        self.isLoading = true
        Task{
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id + "/image", reqMethod: GET, authReq: true, body: body, responseType: Response.Image.self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    user.image = response
                    shop.users.append(user)
                }
            } catch let error {
                DispatchQueue.main.async {
                    shop.users.append(user)
                    self.isLoading = false
                    
                    //We dont use ERROR_NO_IMAGE as a real error so it needs to be excluded from the error handling
                    if error.localizedDescription != ERROR_NO_IMAGE {
                        self.hasError = true
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
}
