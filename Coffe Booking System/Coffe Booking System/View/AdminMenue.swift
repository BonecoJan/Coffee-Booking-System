import SwiftUI

struct AdminMenue: View {
    
    @ObservedObject var adminController = AdminController()
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var viewState: ViewState
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    viewState.state = 0
                }, label: {
                    Image(systemName: IMAGE_ARROW_LEFT)
                        .multilineTextAlignment(.leading)
                })
                .padding()
                Text("Admin Menu")
                    .bold()
                    .multilineTextAlignment(.center)
            }
            TabView {
                //show items
                AdminItemView()
                    .tabItem{
                        Image(systemName: "cart")
                        Text("Items")
                    }
                    .environmentObject(adminController)
                    .environmentObject(shop)
                //show users
                AdminUserView()
                    .tabItem{
                        Image(systemName: "person")
                        Text("User")
                    }
                    .environmentObject(adminController)
                    .environmentObject(shop)
            }
        }
    }
}

struct AdminMenue_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenue()
    }
}
