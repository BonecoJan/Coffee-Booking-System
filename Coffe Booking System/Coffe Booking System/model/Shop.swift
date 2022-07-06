import Foundation

class Shop: ObservableObject {
    
    @Published var currentUser: User
    @Published var users: [User]
    @Published var items: [Item]
    
    init(currentUser: User, users: [User], items: [Item]){
        self.currentUser = currentUser
        self.users = users
        self.items = items
    }
    
    func getItems() -> [Item] {
        return self.items
    }
}

