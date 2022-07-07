import SwiftUI
import JWTDecode

@main
struct Coffe_Booking_SystemApp: App {
    
    @StateObject var loginVM = LoginViewModel()
    @StateObject var registerVM = RegisterViewModel()
    @StateObject var modelService = ModelService(shop: Shop(currentUser: User(id: "", name: ""), users: [], items: []), webService: WebService(authManager: AuthManager()))
    
    var body: some Scene {
        WindowGroup {
            //if checkToken() {
            if loginVM.isAuthenticated {
                MainView().environmentObject(loginVM)
                    .environmentObject(modelService)
            } else {
                //RegisterView().environmentObject(registerVM)
                LoginView().environmentObject(loginVM)
                    .environmentObject(modelService)
            }
        }
    }
    
    func checkToken() -> Bool {
        let tokenID = String(data: KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")!, encoding: .utf8)!

        do {
            let jwt = try decode(jwt: tokenID)
            if !(jwt.expired) {
                loginVM.password = String(data: KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System")!, encoding: .utf8)!
                loginVM.id = jwt.claim(name: "id").string!
                print(tokenID)
                loginVM.login()
                return true
            }
            else {
                return false
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
}
