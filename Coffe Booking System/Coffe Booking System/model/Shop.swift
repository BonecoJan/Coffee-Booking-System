import Foundation

struct Shop: Codable {
    
    var currentUser: User
    var user: [User]
    var items: [Item]
}
