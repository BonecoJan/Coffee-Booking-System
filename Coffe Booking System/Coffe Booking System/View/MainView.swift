import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profilVM : ProfileViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var orderVM : OrderViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(hex: 0xC08267))
    }
    
    var body: some View {
        HStack{
            VStack{
                Text("Welcome")
                    .multilineTextAlignment(.leading)
                Text(profilVM.name)
                    .bold()
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Button(action: {
                viewState.state = 4
            }, label: {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
            })
        }.padding()
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house")
                        .foregroundColor(.black)
                    Text("Home")
                        .foregroundColor(.black)
                }
                .environmentObject(shop)
                .environmentObject(profilVM)
                .environmentObject(orderVM)
                .environmentObject(homeVM)
            OrderView()
                .tabItem{
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                    Text("Order")
                        .foregroundColor(.black)
                }
                .environmentObject(shop)
                .environmentObject(orderVM)
                .environmentObject(profilVM)
                .environmentObject(transactionVM)
            QRView()
                .tabItem{
                    Image(systemName: "qrcode")
                        .foregroundColor(.black)
                    Text("QR-Buy")
                        .foregroundColor(.black)
                }
                .environmentObject(orderVM)
                .environmentObject(profilVM)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(LoginViewModel())
    }
}
