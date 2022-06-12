import Foundation

struct Product: Codable, Identifiable {
    
    var id: Int
    var name: String
    var amount: Int
    var price: Double
}
