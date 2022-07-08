import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    @StateObject var profileVM = ProfileViewModel()
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
                .environmentObject(shop)
            OrderView()
                .tabItem{
                    Image(systemName: "cart")
                    Text("Order")
                }
                .environmentObject(shop)
            ProfilView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profil")
                }
                .environmentObject(shop)
                .environmentObject(loginVM)
                .environmentObject(profileVM)
                .environmentObject(viewState)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(LoginViewModel())
    }
}
