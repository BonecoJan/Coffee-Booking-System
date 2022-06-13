import Foundation

struct Order: Codable, Identifiable {
    
    var id: String
    var amount: Int
    var item: Item
    var user: User
}
