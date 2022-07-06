import Foundation

class Order: ObservableObject, Identifiable {
    
    @Published var id: String
    @Published var amount: Int
    @Published var item: Item
    @Published var user: User
    
    init(id: String, amount: Int, item: Item, user: User){
        self.id = id
        self.amount = amount
        self.item = item
        self.user = user
    }
    
    //TODO: Bidirectional Connection to User
    
    //TODO: Bidirectional Connection to Item
}
