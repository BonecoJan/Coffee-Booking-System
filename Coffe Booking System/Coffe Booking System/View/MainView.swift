import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    @StateObject var profileVM = ProfileViewModel()
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
            Image(systemName: "list.bullet.rectangle.portrait")
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
            OrderView()
                .tabItem{
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                    Text("Order")
                        .foregroundColor(.black)
                }
                .environmentObject(shop)
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
