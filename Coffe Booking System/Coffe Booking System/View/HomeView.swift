import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profilController: ProfileController
    @EnvironmentObject var homeController : HomeController
    
    @StateObject var orderVM = CartController()
    @State var searchText = ""
    
    var body: some View {
        //Searchbar
        VStack{
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
            ScrollView{
                ForEach(searchResults) { product in
                    ProductView(product: product)
                        .environmentObject(homeController)
                }
            }
        }
        .onAppear(perform: {
            homeController.getProducts()
        })
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: UInt(COLOR_BACKGROUND)))
            )
    }
    
    //filter the search results by names
    var searchResults: [Response.Item] {
        if searchText.isEmpty {
            return homeController.products
        } else {
            return homeController.products.filter { $0.name.contains(searchText)}
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

