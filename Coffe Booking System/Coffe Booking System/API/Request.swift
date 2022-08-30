import Foundation

enum Request {
    
    enum Login {
        struct User: Codable {
            let id: String
            let password: String
        }
    }
    
    enum Register {
        struct User: Codable {
            let id: String?
            let name: String
            let password: String?
        }
    }
    
    enum Profil {
        struct User: Codable {
            var name: String
            var password: String
        }
    }
    
    enum Admin {
        struct User: Codable {
            let id: String
            let name: String
            let isAdmin: Bool
            let password: String
        }
    }
    
    struct SendMoney: Codable {
        var amount: Double
        var recipientId: String
    }
    
    struct Funding: Codable {
        let amount: Double
    }
    
    struct Item: Codable {
        var name: String
        var amount: Int
        var price: Double
    }

    struct Purchase: Codable {
        var itemId: String
        var amount: Int
    }
    
    struct Empty: Codable {}
}

enum Response {
    
    enum Login {
        struct User: Codable {
            let token: String?
            let expiration: Int?
        }
    }
    
    enum Profil {
        struct User: Codable, Identifiable {
            var id: String
            var name: String
            var balance: Double
        }
    }
    
    struct User: Codable, Identifiable {
        var id: String
        var name: String
        var password: String?
        var balance: Double?
        var imageTimestamp: Int?
    }
    
    struct Item: Codable, Identifiable {
        var id: String
        var name: String
        var amount: Int?
        var price: Double
    }
    
    struct CreateUser: Codable {
        var id: String
    }
    
    struct Image: Codable {
        var encodedImage: String?
        var timestamp: Int?
    }

    struct Transaction: Codable {
        var type: String
        var value: Double
        var timestamp : Int
        var itemId: String?
        var itemName: String?
        var amount: Int?
    }
    
}

struct NoJSON: Codable {
    let response: String
}
