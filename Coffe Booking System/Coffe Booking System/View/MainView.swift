import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var orderVM = OrderViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(hex: 0xC08267))
    }
    
    var body: some View {
        HStack{
            VStack{
                Text("Welcome")
                    .multilineTextAlignment(.leading)
                Text(profileVM.name)
                    .bold()
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Button(action: {
                //TODO: Show Transaction History
            }, label: {
                Image(systemName: "list.bullet.rectangle.portrait")
                    .resizable()
                    .frame(width: 20, height: 25)
                    .foregroundColor(.black)
            })
            
            Image(systemName: "location")
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
                .environmentObject(profileVM)
                .environmentObject(orderVM)
            OrderView()
                .tabItem{
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                    Text("Order")
                        .foregroundColor(.black)
                }
                .environmentObject(shop)
                .environmentObject(orderVM)
                .environmentObject(profileVM)
            ProfilView()
                .tabItem{
                    Image(systemName: "person")
                        .foregroundColor(.black)
                    Text("Profil")
                        .foregroundColor(.black)
                }
                .environmentObject(shop)
                .environmentObject(loginVM)
                .environmentObject(profileVM)
                .environmentObject(viewState)
        }
        .onAppear(perform: profileVM.loadUserData)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(LoginViewModel())
    }
}
