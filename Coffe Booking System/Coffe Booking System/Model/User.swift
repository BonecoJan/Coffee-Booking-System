import Foundation

class User: ObservableObject, Identifiable {
    var userResponse: Response.User
    var image: Response.Image

    init(userRespose: Response.User) {
        self.userResponse = userRespose
        self.image = Response.Image(encodedImage: NO_PROFILE_IMAGE, timestamp: 0)
    }
}
