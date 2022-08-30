import Foundation

class Shop: ObservableObject {
    
    @Published var profile: Profile
    @Published var users: [User]
    @Published var items: [Item]
    @Published var transactions: [Transaction]
    
    init() {
        profile = Profile()
        users = []
        items = []
        transactions = []
    }
}
