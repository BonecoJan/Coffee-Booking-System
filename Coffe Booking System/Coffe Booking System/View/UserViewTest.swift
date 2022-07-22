//
import SwiftUI



struct UserViewTest: View {
    
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
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
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(userVM.users) { user in
                        UserViewObj(user: user)
                            .environmentObject(profilVM)
                    }
                }
            })
        }
    }
}

struct UserViewTest_Previews: PreviewProvider {
    static var previews: some View {
        UserViewTest()
    }
}
