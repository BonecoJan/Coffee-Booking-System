import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    
    @StateObject var orderVM = OrderViewModel()
    @State var searchText = ""
    
    var body: some View {
        //Searchbar
        VStack{
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search item", text: $searchText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            .padding()
            .cornerRadius(50)
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: 0xE3D5CF))
                )
            ScrollView{
                ForEach(searchResults) { product in
                    ProductView(product: product)
                        .environmentObject(homeVM)
                }
            }
        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
    }
    
    //filter the search results by names
    var searchResults: [AdminViewModel.ItemResponse] {
        if searchText.isEmpty {
            return homeVM.products
        } else {
            return homeVM.products.filter { $0.name.contains(searchText)}
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

