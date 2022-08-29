import Foundation

class Transaction {
    
    @Published var type: String
    @Published var value: Double
    @Published var timestamp : Int
    @Published var itemId: String?
    @Published var itemName: String?
    @Published var amount: Int?
    
    init(transaction: Response.Transaction) {
        self.type = transaction.type
        self.value = transaction.value
        self.timestamp = transaction.timestamp
        self.itemId = transaction.itemId
        self.itemName = transaction.itemName
        self.amount = transaction.amount
    }
    
}
