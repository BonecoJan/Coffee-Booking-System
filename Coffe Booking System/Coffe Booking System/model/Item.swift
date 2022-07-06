import Foundation

class Item: ObservableObject, Identifiable {
    
    @Published var id: String
    @Published var name: String
    @Published var amount: Int
    @Published var price: Double
    @Published var orders: [Order]
    
    init(id: String, name: String, amount: Int, price: Double){
        self.id = id
        self.name = name
        self.amount = amount
        self.price = price
        self.orders = []
    }
    
    //TODO: Bidirectional connection to Order
}
