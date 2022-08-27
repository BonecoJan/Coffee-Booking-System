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
        
        struct SendMoney: Codable {
            var amount: Double
            var recipientId: String
        }
        
        struct Funding: Codable {
            let amount: Double
        }
    }

    enum Admin {
        
        struct User: Codable {
            let id: String
            let name: String
            let isAdmin: Bool
            let password: String
        }
        
        struct Item: Codable {
            var name: String
            var amount: Int
            var price: Double
        }
        
    }

    enum Cart {
        
        struct Purchase: Codable {
            var itemId: String
            var amount: Int
        }
        
    }
    
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
        
        struct Image: Codable {
            var encodedImage: String?
            var timestamp: Int?
        }
        
    }
    
    enum Admin {
        
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
        
    }
    
    enum Transaction {
        
        struct Transaction: Codable, Identifiable {
            var id: Int { timestamp } //needs to be done for the Identifiable protocol
            
            var type: String
            var value: Double
            var timestamp : Int
            var itemId: String?
            var itemName: String?
            var amount: Int?
        }
        
    }
    
    struct empty: Codable {}
    
    struct Change: Codable {
        let response: String
    }
    
}
