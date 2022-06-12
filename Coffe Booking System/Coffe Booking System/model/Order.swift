import Foundation

struct Order: Codable, Identifiable {
    
    var id: String
    var amount: Int
    var product: Product
    var user: User
}
