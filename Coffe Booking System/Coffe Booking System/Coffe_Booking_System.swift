import SwiftUI

//For changing the views
class ViewState: ObservableObject {
    @Published var state: Int
    init(){
        state = 0
    }
}

@main

struct Coffe_Booking_System: App {
    
    @ObservedObject var shop = Shop()
    @ObservedObject var loginController = LoginController()
    @ObservedObject var viewState = ViewState()
    @ObservedObject var profileController = ProfileController()
    @ObservedObject var transactionController = TransactionController()
    @ObservedObject var userController = UserController()
    @ObservedObject var homeController = HomeController()
    @ObservedObject var cartController = CartController()
    @ObservedObject var monitor = NetworkMonitor()
    
    var body: some Scene {
            WindowGroup {
                ZStack{
                    VStack{
                        if loginController.isAuthenticated && viewState.state == 0 {
                            MainView().environmentObject(loginController)
                                .environmentObject(viewState)
                                .environmentObject(profileController)
                                .environmentObject(cartController)
                                .environmentObject(homeController)
                                .environmentObject(transactionController)
                                .environmentObject(shop)
                        } else if !loginController.isAuthenticated && viewState.state == 0 {
                            LoginView().environmentObject(loginController)
                                .environmentObject(profileController)
                                .environmentObject(transactionController)
                                .environmentObject(homeController)
                                .environmentObject(viewState)
                                .environmentObject(shop)
                                .background(Color(hex: UInt(COLOR_BACKGROUND)))
                        } else if viewState.state == 1 {
                            AdminMenue()
                                .environmentObject(viewState)
                                .environmentObject(shop)
                        } else if viewState.state == 2 {
                            BookingView()
                                .environmentObject(viewState)
                                .environmentObject(profileController)
                                .environmentObject(transactionController)
                                .environmentObject(shop)
                        } else if viewState.state == 3 {
                            UserViewTest()
                                .environmentObject(viewState)
                                .environmentObject(profileController)
                                .background(Color(hex: UInt(COLOR_BACKGROUND)))
                                .environmentObject(userController)
                                .environmentObject(shop)
                        } else if viewState.state == 4 {
                            ProfilView()
                                .environmentObject(loginController)
                                .environmentObject(profileController)
                                .environmentObject(viewState)
                                .environmentObject(transactionController)
                                .environmentObject(userController)
                                .environmentObject(shop)
                                .background(Color(hex: UInt(COLOR_BACKGROUND)))
                        } else if viewState.state == 5 {
                            BookingView()
                                .environmentObject(viewState)
                                .environmentObject(profileController)
                                .environmentObject(transactionController)
                                .environmentObject(shop)
                                .background(Color(hex: UInt(COLOR_BACKGROUND)))
                        } else if viewState.state == 6 {
                            ChartSelection()
                                .environmentObject(viewState)
                                .environmentObject(transactionController)
                                .environmentObject(shop)
                        } else if viewState.state == 7 {
                            AchievementView()
                                .environmentObject(viewState)
                                .environmentObject(transactionController)
                                .environmentObject(profileController)
                                .environmentObject(shop)
                                .background(Color(hex: UInt(COLOR_BACKGROUND)))
                        }
                    }
                    .alert("Error", isPresented: $profileController.hasError, presenting: profileController.error) { detail in
                        Button("Ok", role: .cancel) { }
                    } message: { detail in
                        if case let error = detail {
                            Text(error)
                        }
                    }
                    .alert("Error", isPresented: $homeController.hasError, presenting: homeController.error) { detail in
                        Button("Ok", role: .cancel) { }
                    } message: { detail in
                        if case let error = detail {
                            Text(error)
                        }
                    }
                    .alert("Error", isPresented: $transactionController.hasError, presenting: transactionController.error) { detail in
                        Button("Ok", role: .cancel) { }
                    } message: { detail in
                        if case let error = detail {
                            Text(error)
                        }
                    }
                    .alert("No Internet Connection", isPresented: $monitor.isNotConnected) {
                        Button("Ok", role: .cancel) { }
                    }
                    
                    if loginController.isLoading || profileController.isLoading || transactionController.isLoading || cartController.isLoading || homeController.isLoading || userController.isLoading {
                        ZStack {
                            Color(.white)
                                .opacity(0.3)
                                .ignoresSafeArea()
                            VStack{
                                ProgressView("Loading")
                                Button(action: {
                                    loginController.isLoading = false
                                    profileController.isLoading = false
                                    transactionController.isLoading = false
                                    cartController.isLoading = false
                                    homeController.isLoading = false
                                }, label: {
                                    Text("Cancel")
                                }).padding(.top)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                            )
                            .shadow(radius: 10)
                        }
                    }
                    
                }
            }
    }
}
