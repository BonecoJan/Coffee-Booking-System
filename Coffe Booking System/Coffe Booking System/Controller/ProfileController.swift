import Foundation
import JWTDecode
import SwiftUI

class ProfileController: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var updatedUser: Bool = false
    @Published var updatedImage: Bool = false
    @Published var error: String = ""
    
    
    func loadUserData(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                //try to get user id from Keychain
                if let readToken = KeychainWrapper.standard.get(service: SERVICE_TOKEN, account: ACCOUNT) {
                let tokenID = String(data: readToken, encoding: .utf8)!
                let jwt = try decode(jwt: tokenID)
                let userID = jwt.claim(name: "id").string!
                
                let body: Request.Empty? = nil
                    let user = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID, reqMethod: GET, authReq: true, body: body, responseType: Response.Profil.User.self, unknownType: false)
                    
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    shop.profile.id = user.id
                    shop.profile.name = user.name
                    shop.profile.balance = user.balance
                    self.getImage(shop: shop)
                }
                    
                } else {
                    throw RequestError.custom(errorMessage: ERROR_TOKEN)
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
        self.getAdminData(shop: shop)
    }
    
    func updateUser(shop: Shop, name: String) {
        self.isLoading = true
        Task {
            do {
                //try to get user password from Keychain
                if let password = KeychainWrapper.standard.get(service: SERVICE_PASSWORD, account: ACCOUNT) {
                let password = String(data: password, encoding: .utf8)!
                    
                let body = Request.Profil.User(name: name, password: password)
                    let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + shop.profile.id, reqMethod: PUT, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                print(response.response)
                if response.response == SUCCESS_UPDATE_USER {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.updatedUser = true
                        self.hasError = false
                        self.loadUserData(shop: shop)
                    }
                }
                }
            } catch let error {
                self.isLoading = false
                self.hasError = true
                self.error = error.localizedDescription
            }
        }
    }
    
    func updateUser(shop: Shop, name: String, password: String) {
        self.isLoading = true
        Task {
            do {
                let body = Request.Profil.User(name: name, password: password)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + shop.profile.id, reqMethod: PUT, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                
                if response.response == SUCCESS_UPDATE_USER {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.updatedUser = true
                        self.hasError = false
                        self.loadUserData(shop: shop)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func getAdminData(shop: Shop) {
        if let data = KeychainWrapper.standard.get(service: SERVICE_TOKEN, account: ACCOUNT) {
        let tokenID = String(data: data, encoding: .utf8)!
        do {
            let jwt = try decode(jwt: tokenID)
            let adminInfo = jwt.body["isAdmin"]! as? Int
            if adminInfo! == 1 {
                shop.profile.isAdmin = true
            } else {
                shop.profile.isAdmin = false
            }
        } catch {
            print("Error while trying to decode token")
        }
        } else {
            print("Error while reading token")
            return
        }
    }
    
    func sendMoney(shop: Shop, amount: Double, recipientId: String) {
        self.isLoading = true
        Task {
            do {
                let body = Request.SendMoney(amount: amount, recipientId: recipientId)
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + shop.profile.id + "/sendMoney", reqMethod: POST, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_FUNDING {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.success = true
                        self.loadUserData(shop: shop)
                    }
                }
            } catch let error{
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func cancelLastPurchase(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + shop.profile.id + "/purchases/refund", reqMethod: POST, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_REFUND {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.success = true
                        self.loadUserData(shop: shop)
                    }
                }
            } catch let error{
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func getImage(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + shop.profile.id + "/image", reqMethod: GET, authReq: true, body: body, responseType: Response.Image.self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    shop.profile.image = response
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func uploadImage(shop: Shop, image: UIImage) {
        self.isLoading = true
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).uploadImage(image: image, userID: shop.profile.id)
                if response.response == SUCCESS_UPLOAD_IMAGE {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.updatedImage = true
                        self.loadUserData(shop: shop)
                    }
                }
            } catch let error{
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func deleteImage(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body : Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "/users/" + shop.profile.id + "/image", reqMethod: DELETE, authReq: true, body: body, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_DELETE_IMAGE {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.updatedImage = true
                        shop.profile.image = Response.Image(encodedImage: "empty", timestamp: 0)
                    }
                }
            } catch let error{
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
