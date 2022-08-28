//
import SwiftUI



struct UserViewTest: View {
    
    @EnvironmentObject var userController : UserController
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profileController: ProfileController
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewState.state = 4
                }, label: {
                    Image(systemName: IMAGE_ARROW_LEFT)
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
                Image(systemName: IMAGE_SEARCH).foregroundColor(.gray)
                TextField("Search user", text: $searchText)
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
                ForEach(searchResults) { user in
                    UserViewObj(user: user).environmentObject(profileController)
                }
            }
            .background(Color(hex: UInt(COLOR_BACKGROUND)))
        }.padding()
    }
    
    //filter the search results by names
    var searchResults: [User] {
        if searchText.isEmpty {
            return userController.users.filter { $0.userResponse.id != profileController.profile.id}
        } else {
            return userController.users.filter { $0.userResponse.name.contains(searchText) && $0.userResponse.id != profileController.profile.id}
        }
    }
}

struct UserViewTest_Previews: PreviewProvider {
    static var previews: some View {
        UserViewTest()
    }
}
