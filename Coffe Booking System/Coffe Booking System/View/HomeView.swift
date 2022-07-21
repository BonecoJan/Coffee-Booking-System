import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profilVM: ProfileViewModel
    @ObservedObject var homeVM = HomeViewModel()
    @StateObject var orderVM = OrderViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack{
                ForEach(homeVM.products) { product in
                    ProductView(product: product)
                        .environmentObject(homeVM)
                }
            }
        })
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

