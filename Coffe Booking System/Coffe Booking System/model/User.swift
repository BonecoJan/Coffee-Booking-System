import Foundation

class User: ObservableObject, Identifiable {
    
    @Published var id: String
    @Published var name: String
    @Published var orders: [Order]
    @Published var isAdmin: Bool
    
    init(id: String, name: String){
        self.id = id
        self.name = name
        orders = []
        isAdmin = false
    }
    
    //TODO: Bidirectional connection to Order
}
