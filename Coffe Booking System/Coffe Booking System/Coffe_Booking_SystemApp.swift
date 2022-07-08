import SwiftUI

//For changing the views
class ViewState: ObservableObject {
    @Published var state: Int
    init(){
        state = 0
    }
}

@main

struct Coffe_Booking_SystemApp: App {
    
    @ObservedObject var loginVM = LoginViewModel()
    @ObservedObject var registerVM = RegisterViewModel()
    @ObservedObject var shop = Shop(modelService: ModelService(webService: WebService(authManager: AuthManager())), currentUser: User(id: "", name: ""), users: [], items: [])
    @ObservedObject var viewState = ViewState()
    
    var body: some Scene {
        WindowGroup {
            if loginVM.isAuthenticated && viewState.state == 0 {
                MainView().environmentObject(loginVM)
                    .environmentObject(shop)
                    .environmentObject(viewState)
            } else if !loginVM.isAuthenticated && viewState.state == 0{
                LoginView().environmentObject(loginVM)
                    .environmentObject(shop)
                    .environmentObject(registerVM)
                    .environmentObject(viewState)
            } else if viewState.state == 1{
                AdminMenue()
            }
        }
    }
}
