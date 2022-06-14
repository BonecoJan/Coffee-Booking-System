import SwiftUI

@main
struct Coffe_Booking_SystemApp: App {
    
    @StateObject var loginVM = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            if loginVM.isAuthenticated {
                MainView()
            } else {
                LoginView().environmentObject(loginVM)
            }
        }
    }
}
