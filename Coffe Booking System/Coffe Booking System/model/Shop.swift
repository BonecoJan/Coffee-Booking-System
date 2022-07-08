import Foundation

class Shop: ObservableObject {
    
    @Published var currentUser: User
    @Published var users: [User]
    @Published var items: [Item]
    @Published var modelService: ModelService
    
    init(modelService: ModelService, currentUser: User, users: [User], items: [Item]){
        self.currentUser = currentUser
        self.users = users
        self.items = items
        self.modelService = modelService
    }
    
    func getItems() -> [Item] {
        return self.items
    }
}

