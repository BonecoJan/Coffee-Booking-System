import Foundation
import SwiftUI

class AdminController: ObservableObject {
    
    enum MyError: Error {
        case runtimeError(String)
    }
    
    @Published var error: String = ""
    
    @Published var items: [Response.Item] = []
    //@Published var users:  [Response.User] = []
    //@Published var users:  [User] = []
    @Published var itemPlaceholder:  Response.Item = Response.Item(id: "", name: "", amount: 0, price: 0.0)
    @Published var userPlaceholder:  Response.User = Response.User(id: "", name: "", password: "")

    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var userCreated: Bool = false
    @Published var itemCreated: Bool = false
    
    @Published var isLoading: Bool = false
    
    func getUsers(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let usersLoaded = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: GET, authReq: false, body: body, responseType: [Response.User].self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    shop.users = []
                    for user in usersLoaded {
                        let tmpUser = User(userRespose: user)
                        self.getImage(user: tmpUser)
                        shop.users.append(tmpUser)
                    }
                    self.isLoading = false
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func getUser(user: User) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let userLoaded = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id, reqMethod: GET, authReq: true, body: body, responseType: Response.User.self, unknownType: false)
                DispatchQueue.main.async {
                    //self.currentUser = userLoaded
                    self.getImage(user: user)
                    self.hasError = false
                    user.userResponse = userLoaded
                    self.userPlaceholder = userLoaded
                    self.isLoading = false
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    //TODO: Gleiche Anfrage wie in ProfilVM
    func getImage(user: User) {
        self.isLoading = true
        Task{
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id + "/image", reqMethod: GET, authReq: true, body: body, responseType: Response.Image.self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    user.image = response
                    self.isLoading = false
                    //self.users.append(user)
                }
            } catch let error {
                DispatchQueue.main.async {
                    if error.localizedDescription == ERROR_NO_IMAGE {
                        self.hasError = false
                        user.image = Response.Image(encodedImage: "empty", timestamp: 0)
                        //self.users.append(user)
                    } else {
                        self.hasError = true
                        self.error = error.localizedDescription
                    }
                    self.isLoading = false
                    
                }
            }
//                catch {
//                print("user with id \(user.userResponse.id) has no image uploaded")
//                DispatchQueue.main.async {
//                    self.users.append(user)
//                }
//            }
        }
    }
    
    func getItems(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let items = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: GET, authReq: false, body: body, responseType: [Response.Item].self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    shop.items = []
                    for item in items {
                        shop.items.append(Item(item: item))
                    }
                    self.isLoading = false
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    
    func getItem(itemID: String) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let item = try await WebService(authManager: AuthManager()).request(reqUrl: "items/" + itemID, reqMethod: GET, authReq: true, body: body, responseType: Response.Item.self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    self.itemPlaceholder = item
                    self.itemPlaceholder.amount = self.itemPlaceholder.amount ?? 0
                    self.isLoading = false
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func getUser(userID: String) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let user = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: GET, authReq: true, body: body, responseType: Response.User.self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    self.userPlaceholder = user
                    self.isLoading = false
//                    self.getImage(userID: userID)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func getImage(userID: String) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/image", reqMethod: GET, authReq: true, body: body, responseType: Response.Image.self, unknownType: false)
                print(response)
                DispatchQueue.main.async {
                    self.hasError = false
                    self.isLoading = false
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func uploadImage(userID: String, image: UIImage) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).uploadImage(image: image, userID: userID)
                if response.response == SUCCESS_UPLOAD_IMAGE {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUser(userID: userID)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func uploadImage(user: User, image: UIImage) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).uploadImage(image: image, userID: user.userResponse.id)
                if response.response == SUCCESS_UPLOAD_IMAGE {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUser(user: user)
                        self.isLoading = false
                        //self.getUsers()
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    
    func deleteImage(userID: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body : Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "/users/" + userID + "/image", reqMethod: DELETE, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_DELETE_IMAGE {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func deleteImage(user: User) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body : Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "/users/" + user.userResponse.id + "/image", reqMethod: DELETE, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_DELETE_IMAGE {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        //self.currentImage = ProfileViewModel.ImageResponse(encodedImage: "empty", timestamp: 0)
                        self.getUser(user: user)
                        self.isLoading = false
                        //self.getUsers()
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    
//    func getUsers() {
//        Task {
//            do {
//                let body: WebService.empty? = nil
//                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self, unknownType: false)
//                DispatchQueue.main.async {
//                    self.users = users
//                }
//            } catch {
//                print("failed to get users from server")
//            }
//        }
//    }
    
    func deleteItem(shop: Shop, itemID: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items/" + itemID, reqMethod: DELETE, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_DELETE_ITEM {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getItems(shop: shop)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func updateItem(shop: Shop, itemID: String, name: String, amount: Int, price: Double) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = Response.Item(id: itemID, name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: PUT, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                print(response.response)
                if response.response == SUCCESS_UPDATE_ITEM {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getItems(shop: shop)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func updateUser(shop: Shop, userID: String, name: String, isAdmin: Bool, password: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = Request.Admin.User(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: PUT, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                print(response.response)
                if response.response == SUCCESS_UPDATE_USER {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers(shop: shop)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func deleteUser(shop: Shop, userID: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: DELETE, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_DELETE_USER {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers(shop: shop)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func deleteUser(shop: Shop, user: User) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id, reqMethod: DELETE, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_DELETE_USER {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers(shop: shop)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    //TODO: Create Users and Items
    
    func createUser(shop: Shop, userID: String, name: String, isAdmin: Bool, password: String) {
        self.isLoading = true
        self.userCreated = false
        Task {
            do {
                let body = Request.Admin.User(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: POST, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == userID {
                    DispatchQueue.main.async {
                        self.hasError = false
                        self.userCreated = true
                        self.getUsers(shop: shop)
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.userCreated = false
                    if error.localizedDescription == String(STATUS_CONFLICT) {
                        self.error = ERROR_USER_EXISTS
                    } else {
                        self.error = error.localizedDescription
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    //Create Item
    func createItem(shop: Shop, name: String, amount: Int, price: Double) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = Request.Item(name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: POST, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                print(response.response)
                    DispatchQueue.main.async {
                        self.itemCreated = true
                        self.hasError = false
                        self.getItems(shop: shop)
                        self.isLoading = false
                    }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }        }
    }
    
    //TODO: Give credits to user
    func funding(shop: Shop, userID: String, amount: Double) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = Request.Funding(amount: amount)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/funding", reqMethod: POST, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                print(response.response)
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers(shop: shop)
                        self.isLoading = false
                    }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
