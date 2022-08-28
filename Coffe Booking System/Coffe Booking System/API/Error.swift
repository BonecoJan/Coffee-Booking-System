import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

enum RequestError: Error {
    case invalidURL
    case decodingError
    case encodingError
    case custom(errorMessage: String)
}
