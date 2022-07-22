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
    @ObservedObject var profilVM = ProfileViewModel()
    @ObservedObject var transactionVM = TransactionViewModel()
    @ObservedObject var userVM = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            if loginVM.isAuthenticated && viewState.state == 0 {
                MainView().environmentObject(loginVM)
                    .environmentObject(shop)
                    .environmentObject(viewState)
                    .environmentObject(profilVM)
            } else if !loginVM.isAuthenticated && viewState.state == 0{
                LoginView().environmentObject(loginVM)
                    .environmentObject(profilVM)
                    .environmentObject(shop)
                    .environmentObject(registerVM)
                    .environmentObject(viewState)
            } else if viewState.state == 1{
                AdminMenue()
                    .environmentObject(viewState)
            } else if viewState.state == 2{
                BookingView()
                    .environmentObject(viewState)
                    .environmentObject(profilVM)
                    .environmentObject(transactionVM)
            } else if viewState.state == 3 {
                UserViewTest()
                    .environmentObject(viewState)
                    .environmentObject(profilVM)
                    .background(Color(hex: 0xCCB9B1))
                    .environmentObject(userVM)
            } else if viewState.state == 4 {
                ProfilView()
                    .environmentObject(shop)
                    .environmentObject(loginVM)
                    .environmentObject(profilVM)
                    .environmentObject(viewState)
                    .environmentObject(transactionVM)
                    .environmentObject(userVM)
                    .background(Color(hex: 0xCCB9B1))
            } else if viewState.state == 5{
                BookingView()
                    .environmentObject(viewState)
                    .environmentObject(profilVM)
                    .environmentObject(transactionVM)
                    .background(Color(hex: 0xCCB9B1))
            }
        }
    }
}
