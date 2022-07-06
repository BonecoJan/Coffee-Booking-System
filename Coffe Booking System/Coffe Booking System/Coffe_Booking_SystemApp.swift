import SwiftUI

@main
struct Coffe_Booking_SystemApp: App {
    
    @StateObject var loginVM = LoginViewModel()
    @StateObject var registerVM = RegisterViewModel()
    @StateObject var modelService = ModelService(shop: Shop(currentUser: User(id: "", name: ""), users: [], items: []), webService: WebService(authManager: AuthManager()))
    
    var body: some Scene {
        WindowGroup {
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
}
