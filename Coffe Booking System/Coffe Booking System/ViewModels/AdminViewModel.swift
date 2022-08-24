import Foundation

class AdminViewModel: ObservableObject {
    
    struct UsersResponse: Codable, Identifiable {
        var id: String
        var name: String
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
        var amount: Int
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
    
    @Published var items: [ItemResponse] = []
    @Published var users:  [UsersResponse] = []
    @Published var success: Bool = false
    
    @Published var isLoading: Bool = false
    
    init() {
        getUsers()
        getItems()
    }
    
    func getItems() {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let items = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "GET", authReq: false, body: body, responseType: [ItemResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.items = items
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("failed to get items from server")
            }
        }
    }
    
    func getUsers() {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.users = users
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("failed to get users from server")
            }
        }
    }
    
    func deleteItem(itemID: String) {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items/" + itemID, reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Item deleted successfully." {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.success = true
                        self.getItems()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("failed to delete item with id " + itemID)
            }
        }
    }

    func updateItem(itemID: String, name: String, amount: Int, price: Double) {
        self.isLoading = true
        Task {
            do {
                let body = ItemResponse(id: itemID, name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == "Item updated successfully." {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.success = true
                        self.getItems()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("failed to update item with id " + itemID)
            }
        }
    }
    
    func updateUser(userID: String, name: String, isAdmin: Bool, password: String) {
        self.isLoading = true
        Task {
            do {
                let body = UserRequest(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                if response.response == "User updated successfully." {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.success = true
                        self.getUsers()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("could not update user with id " + userID)
            }
        }
    }
    
    func deleteUser(userID: String) {
        self.isLoading = true
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "User deleted successfully." {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.success = true
                        self.getUsers()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("failed to delete item with id " + userID)
            }
        }
    }
    
    //TODO: Create Users and Items
    
    func createUser(userID: String, name: String, isAdmin: Bool, password: String) {
        self.isLoading = true
        Task {
            do {
                let body = UserRequest(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == userID {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.getUsers()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("failed to create user with id " + userID)
            }
        }
    }
    
    //Create Item
    func createItem(name: String, amount: Int, price: Double) {
        self.isLoading = true
        Task {
            do {
                let body = ItemRequest(name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "POST", authReq: true, body: body, responseType: WebService.ChangeResponse.self, unknownType: false)
                print(response.response)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.success = true
                        self.getItems()
                    }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("could not create item.")
            }
        }
    }
    
    //TODO: Give credits to user
}
