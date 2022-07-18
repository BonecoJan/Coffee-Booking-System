import SwiftUI

struct AdminMenue: View {
    
    @ObservedObject var adminVM = AdminViewModel()
    @EnvironmentObject var viewState: ViewState
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    viewState.state = 0
                }, label: {
                    Image(systemName: "arrow.backward")
                        .multilineTextAlignment(.leading)
                })
                .padding()
                Text("Admin Menu")
                    .bold()
                    .multilineTextAlignment(.center)
            }
            TabView {
                AdminItemView(showCreateOverlay: false, newID: "", newName: "", newAmount: "", newPrice: "")
                    .tabItem{
                        Image(systemName: "cart")
                        Text("Items")
                    }
                    .environmentObject(adminVM)
                AdminUserView(showCreateOverlay: false, newID: "", newName: "", isAdmin: false, newPassword: "")
                    .tabItem{
                        Image(systemName: "person")
                        Text("User")
                    }
                    .environmentObject(adminVM)
            }
        }
    }
}

struct AdminMenue_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenue()
    }
}
