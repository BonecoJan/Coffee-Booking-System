import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profilController: ProfileController
    @EnvironmentObject var homeController : HomeController
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var cartController : CartController
    
    @State var searchText = ""
    
    var body: some View {
        
        VStack{
            //Searchbar
            HStack {
                Image(systemName: IMAGE_SEARCH).foregroundColor(.gray)
                TextField("Search item", text: $searchText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            .padding()
            .cornerRadius(50)
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: UInt(COLOR_SEARCH_BAR)))
                )
            
            //Iterate through Items and display it as a ProdictView
            ScrollView{
                ForEach(searchResults) { product in
                    ProductView(product: product)
                        .environmentObject(cartController)
                }
            }
        }
        .onAppear(perform: {
            homeController.getProducts(shop: shop)
        })
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: UInt(COLOR_BACKGROUND)))
            )
    }
    
    //filter the items by searched name
    var searchResults: [Item] {
        if searchText.isEmpty {
            return shop.items
        } else {
            return shop.items.filter { $0.name.contains(searchText)}
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

