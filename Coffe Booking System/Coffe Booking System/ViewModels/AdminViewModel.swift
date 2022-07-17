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
    
    @Published var items: [ItemResponse] = []
    @Published var users:  [UsersResponse] = []
    @Published var success: Bool = false
    
    init() {
        getUsers()
        getItems()
    }
    
    func getItems() {
        Task {
            do {
                let body: WebService.empty? = nil
                let items = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "GET", authReq: false, body: body, responseType: [ItemResponse].self)
                DispatchQueue.main.async {
                    self.items = items
                }
            } catch {
                print("failed to get items from server")
            }
        }
    }
    
    func getUsers() {
        Task {
            do {
                let body: WebService.empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self)
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                print("failed to get users from server")
            }
        }
    }
    
    func deleteItem(itemID: String) {
        self.success = false
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items/" + itemID, reqMethod: "DELETE", authReq: true, body: body, responseType: String.self)
                if response == "Item deleted successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.getItems()
                    }
                }
            } catch {
                print("failed to delete item with id " + itemID)
            }
        }
    }

    func updateItem(itemID: String, name: String, amount: Int, price: Double) {
        self.success = false
        Task {
            do {
                let body = ItemResponse(id: itemID, name: name, amount: amount, price: price)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self)
                print(response.response)
                if response.response == "Item updated successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.getItems()
                    }
                }
            } catch {
                print("failed to update item with id " + itemID)
            }
        }
    }
    
    func updateUser(userID: String, name: String, isAdmin: Bool, password: String) {
        self.success = false
        Task {
            do {
                let body = UserRequest(id: userID, name: name, isAdmin: isAdmin, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/admin", reqMethod: "PUT", authReq: true, body: body, responseType: WebService.ChangeResponse.self)
                print(response.response)
                if response.response == "User updated successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.getUsers()
                    }
                }
            } catch {
                print("could not update user with id " + userID)
            }
        }
    }
    
    func deleteUser(userID: String) {
        self.success = false
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: "DELETE", authReq: true, body: body, responseType: WebService.ChangeResponse.self)
                if response.response == "User deleted successfully." {
                    DispatchQueue.main.async {
                        self.success = true
                        self.getUsers()
                    }
                }
            } catch {
                print("failed to delete item with id " + userID)
            }
        }
    }
    
    //TODO: Create Users and Items
    //TODO: Give credits to user
}
