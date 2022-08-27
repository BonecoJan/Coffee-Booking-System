import Foundation

class Profil: ObservableObject, Identifiable {
    
    @Published var id:  String
    @Published var name: String
    @Published var isAdmin: Bool
    @Published var balance: Double
    @Published var image: ProfileViewModel.ImageResponse
    
    init(id: String, name: String){
        self.isAdmin = false
        self.name = ""
        self.id = ""
        self.balance = 0.0
        self.image = ProfileViewModel.ImageResponse(encodedImage: "empty", timestamp: 0)
    }
    
}
