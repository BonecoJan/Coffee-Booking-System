//
import SwiftUI



struct UserViewTest: View {
    
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewState.state = 4
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 25, height: 20, alignment: .leading)
                }).padding()
                Text("Send money")
                    .padding()
                    .font(.title)
                Spacer()
            }
            //Searchbar
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search", text: $searchText)
            }
            .padding()
            .cornerRadius(50)
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: 0xE3D5CF))
                )
            ScrollView{
                ForEach(searchResults) { user in
                    UserViewObj(user: user).environmentObject(profilVM)
                }
            }
            .background(Color(hex: 0xCCB9B1))
        }.padding()
    }
    
    //filter the search results by names
    var searchResults: [UserViewModel.UsersResponse] {
        if searchText.isEmpty {
            return userVM.users
        } else {
            return userVM.users.filter { $0.name.contains(searchText)}
        }
    }
}

struct UserViewTest_Previews: PreviewProvider {
    static var previews: some View {
        UserViewTest()
    }
}
