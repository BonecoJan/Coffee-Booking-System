import Foundation

class AdminViewModel: ObservableObject {
    
    @Published var items: [WebService.ItemResponse] = []
    @Published var users:  [WebService.UsersResponse] = []
    
    init() {
        getUsers()
        getItems()
    }
    
    func getItems() {
        Task{
            do {
                let items = try await WebService(authManager: AuthManager()).getItems()
                DispatchQueue.main.async {
                    self.items = items
                }
            } catch {
                print("failed to get items from server")
            }
        }
    }
    
    func getUsers() {
        Task{
            do {
                let users = try await WebService(authManager: AuthManager()).getUsers()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                print("failed to get users from server")
            }
        }
    }
    
    func deleteItem(itemID: String) {
        Task{
            do {
                try await WebService(authManager: AuthManager()).deleteItem(itemID: itemID)
            } catch {
                print("failed to delete item with id " + itemID)
            }
        }
    }
    
}
