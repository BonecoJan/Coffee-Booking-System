import Foundation

class User: ObservableObject, Identifiable {
    var userResponse: Response.Admin.User
    var image: Response.Profil.Image

    init(userRespose: Response.Admin.User) {
        self.userResponse = userRespose
        self.image = Response.Profil.Image(encodedImage: "empty", timestamp: 0)
    }
}
