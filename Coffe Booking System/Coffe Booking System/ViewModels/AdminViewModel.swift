import Foundation
import SwiftUI

class AdminViewModel: ObservableObject {
    
    
    class User: ObservableObject, Identifiable {
        var userResponse: UsersResponse
        var image: ProfileViewModel.ImageResponse

        init(userRespose: UsersResponse) {
            self.userResponse = userRespose
            self.image = ProfileViewModel.ImageResponse(encodedImage: "empty", timestamp: 0)
        }
    }
    
    struct UsersResponse: Codable, Identifiable {
        var id: String
        var name: String
        var password: String?
        var balance: Double?
        var imageTimestamp: Int?
    }
    
    struct FundingRequest: Codable {
        let amount: Double
    }
    
    struct UserRequest: Codable {
        let id: String
        let name: String
        let isAdmin: Bool
        let password: String
    }
    
    struct ItemResponse: Codable, Identifiable {
        var id: String
        var name: String
        var amount: Int?
        var price: Double
    }
    
    struct ItemRequest: Codable {
        var name: String
        var amount: Int
        var price: Double
    }
    
    struct CreateUserResponse: Codable {
        var id: String
    }
    
    enum MyError: Error {
        case runtimeError(String)
    }
    
    @Published var error: String = ""
    
    @Published var items: [ItemResponse] = []
    //@Published var users:  [UsersResponse] = []
    @Published var users:  [User] = []
    @Published var itemPlaceholder:  ItemResponse = ItemResponse(id: "", name: "", amount: 0, price: 0.0)
    @Published var userPlaceholder:  UsersResponse = UsersResponse(id: "", name: "", password: "")

    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var userCreated: Bool = false
    @Published var itemCreated: Bool = false
    
    @Published var isLoading: Bool = false
    
    init() {
        getUsers()
        getItems()
    }
    
    func getUsers() {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let usersLoaded = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    self.users = []
                    for user in usersLoaded {
                        let tmpUser = User(userRespose: user)
                        self.getImage(user: tmpUser)
                        self.users.append(tmpUser)
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
                let body: WebService.empty? = nil
                let userLoaded = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id, reqMethod: "GET", authReq: true, body: body, responseType: UsersResponse.self, unknownType: false)
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
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id + "/image", reqMethod: "GET", authReq: true, body: body, responseType: ProfileViewModel.ImageResponse.self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    user.image = response
                    self.isLoading = false
                    //self.users.append(user)
                }
            } catch let error {
                DispatchQueue.main.async {
                    if error.localizedDescription == "No profile image associated with that ID. (StatusCode: 404)" {
                        self.hasError = false
                        user.image = ProfileViewModel.ImageResponse(encodedImage: "empty", timestamp: 0)
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
    
    func getItems() {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let items = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "GET", authReq: false, body: body, responseType: [ItemResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.hasError = false
                    self.items = items
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
                let body: WebService.empty? = nil
                let item = try await WebService(authManager: AuthManager()).request(reqUrl: "items/" + itemID, reqMethod: "GET", authReq: true, body: body, responseType: ItemResponse.self, unknownType: false)
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
                let body: WebService.empty? = nil
                let user = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: "GET", authReq: true, body: body, responseType: UsersResponse.self, unknownType: false)
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
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/image", reqMethod: "GET", authReq: true, body: body, responseType: ProfileViewModel.ImageResponse.self, unknownType: false)
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
                if response.response == "Image uploaded successfully." {
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
                if response.response == "Image uploaded successfully." {
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
                let body : WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "/users/" + userID + "/image", reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Image deleted successfully." {
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
                let body : WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "/users/" + user.userResponse.id + "/image", reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Image deleted successfully." {
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
    
    func deleteItem(itemID: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items/" + itemID, reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Item deleted successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getItems()
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

    func updateItem(itemID: String, name: String, amount: Int, price: Double) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = ItemResponse(id: itemID, name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == "Item updated successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getItems()
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
    
    func updateUser(userID: String, name: String, isAdmin: Bool, password: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = UserRequest(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == "User updated successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers()
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
    
    func deleteUser(userID: String) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "User deleted successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers()
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
    
    func deleteUser(user: User) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + user.userResponse.id, reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "User deleted successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers()
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
    
    func createUser(userID: String, name: String, isAdmin: Bool, password: String) {
        self.isLoading = true
        self.userCreated = false
        Task {
            do {
                let body = UserRequest(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == userID {
                    DispatchQueue.main.async {
                        self.hasError = false
                        self.userCreated = true
                        self.getUsers()
                        self.isLoading = false
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.userCreated = false
                    if error.localizedDescription == "409" {
                        self.error = "User with that ID already exists."
                    } else {
                        self.error = "An error was thrown while trying to communicate with the server. Status Code: " + error.localizedDescription
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    //Create Item
    func createItem(name: String, amount: Int, price: Double) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = ItemRequest(name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                    DispatchQueue.main.async {
                        self.itemCreated = true
                        self.hasError = false
                        self.getItems()
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
    func funding(userID: String, amount: Double) {
        self.isLoading = true
        self.success = false
        Task {
            do {
                let body = FundingRequest(amount: amount)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/funding", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                    DispatchQueue.main.async {
                        self.success = true
                        self.hasError = false
                        self.getUsers()
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
