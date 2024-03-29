import Foundation

class Item: ObservableObject, Identifiable {
    var id: String
    var name: String
    var amount: Int
    var price: Double
    
    init(id: String, name: String, amount: Int, price: Double) {
        self.id = id
        self.name = name
        self.amount = amount
        self.price = price
    }
    
    init(item: Response.Item) {
        self.id = item.id
        self.name = item.name
        self.price = item.price
        if item.amount == nil {
            self.amount = 0
        } else {
            self.amount = item.amount!
        }
    }
}
