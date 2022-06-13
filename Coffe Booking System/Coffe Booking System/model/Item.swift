import Foundation

struct Item: Codable, Identifiable {
    
    var id: String
    var name: String
    var amount: Int
    var price: Double
}
