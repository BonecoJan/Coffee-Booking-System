import Foundation

class Profile: ObservableObject, Identifiable {
    
    @Published var id:  String
    @Published var name: String
    @Published var isAdmin: Bool
    @Published var balance: Double
    @Published var image: Response.Image
    
    init(){
        self.isAdmin = false
        self.name = ""
        self.id = ""
        self.balance = 0.0
        self.image = Response.Image(encodedImage: NO_PROFILE_IMAGE, timestamp: 0)
    }
}
