import Foundation

struct User: Codable, Identifiable {
    
    var id: String
    var name: String
    var password: String
    var isAdmin: Bool
    var orders: [Order]
}
