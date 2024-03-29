import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profileController : ProfileController
    @EnvironmentObject var homeController : HomeController
    @EnvironmentObject var cartController : CartController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var shop: Shop
    
    //For coloring the TabBar (normal way doesnt work with TabView)
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(hex: UInt(COLOR_RED_BROWN)))
    }
    
    var body: some View {
        HStack{
            VStack{
                Text("Welcome")
                    .multilineTextAlignment(.leading)
                Text(shop.profile.name)
                    .bold()
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Button(action: {
                viewState.state = 4
            }, label: {
                Image(systemName: IMAGE_PROFILE)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
            })
        }.padding()
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: IMAGE_HOME)
                        .foregroundColor(.black)
                    Text("Home")
                        .foregroundColor(.black)
                }
                .environmentObject(profileController)
                .environmentObject(cartController)
                .environmentObject(homeController)
                .environmentObject(shop)
            OrderView()
                .tabItem{
                    Image(systemName: IMAGE_CART)
                        .foregroundColor(.black)
                    Text("Cart")
                        .foregroundColor(.black)
                }
                .environmentObject(cartController)
                .environmentObject(profileController)
                .environmentObject(transactionController)
                .environmentObject(homeController)
                .environmentObject(shop)
            QRView()
                .tabItem{
                    Image(systemName: IMAGE_QR)
                        .foregroundColor(.black)
                    Text("QR-Buy")
                        .foregroundColor(.black)
                }
                .environmentObject(cartController)
                .environmentObject(profileController)
                .environmentObject(transactionController)
                .environmentObject(homeController)
                .environmentObject(viewState)
                .environmentObject(shop)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(LoginController())
    }
}
