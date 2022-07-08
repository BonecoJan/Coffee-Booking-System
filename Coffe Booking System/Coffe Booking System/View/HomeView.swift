import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    
    var body: some View {
        ItemList()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
