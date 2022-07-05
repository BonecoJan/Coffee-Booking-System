import SwiftUI

@main
struct Coffe_Booking_SystemApp: App {
    
    @StateObject var loginVM = LoginViewModel()
    @StateObject var registerVM = RegisterViewModel()
        
    var body: some Scene {
        WindowGroup {
            if loginVM.isAuthenticated {
                MainView().environmentObject(loginVM)
            } else {
                //RegisterView().environmentObject(registerVM)
                LoginView().environmentObject(loginVM)
            }
        }
    }
}
