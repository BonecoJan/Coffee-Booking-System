import SwiftUI

struct AdminMenue: View {
    
    @ObservedObject var adminVM = AdminViewModel()
    @EnvironmentObject var viewState: ViewState
    
    var body: some View {
        VStack {
            Button(action: {
                viewState.state = 0
            }, label: {
                Image(systemName: "arrow.backward")
            })
            .padding()
            .frame(alignment: .leading)
            TabView {
                AdminItemView()
                    .tabItem{
                        Image(systemName: "cart")
                        Text("Items")
                    }
                    .environmentObject(adminVM)
                AdminUserView()
                    .tabItem{
                        Image(systemName: "person")
                        Text("User")
                    }
                    .environmentObject(adminVM)
                CreateView()
                    .tabItem{
                        Image(systemName: "plus")
                        Text("Add Item/User")
                    }
            }
        }
    }
}

struct AdminMenue_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenue()
    }
}
