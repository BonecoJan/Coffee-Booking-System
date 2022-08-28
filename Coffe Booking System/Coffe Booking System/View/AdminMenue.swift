import SwiftUI

struct AdminMenue: View {
    
    @ObservedObject var adminController = AdminController()
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
                AdminItemView()
                    .tabItem{
                        Image(systemName: "cart")
                        Text("Items")
                    }
                    .environmentObject(adminController)
                AdminUserView()
                    .tabItem{
                        Image(systemName: "person")
                        Text("User")
                    }
                    .environmentObject(adminController)
//                AdminItemView(showCreateOverlay: false, newID: "", newName: "", newAmount: "", newPrice: "")
//                    .tabItem{
//                        Image(systemName: "cart")
//                        Text("Items")
//                    }
//                    .environmentObject(adminController)
//                AdminUserView(showCreateOverlay: false, newID: "", newName: "", isAdmin: false, newPassword: "")
//                    .tabItem{
//                        Image(systemName: "person")
//                        Text("User")
//                    }
//                    .environmentObject(adminController)
            }
        }
    }
}

struct AdminMenue_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenue()
    }
}
