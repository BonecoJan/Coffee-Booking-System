import SwiftUI

struct AdminUserView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    @State var showCreateOverlay: Bool = false
    @State var newID: String
    @State var newName: String
    @State var isAdmin: Bool
    @State var newPassword: String
    
    var body: some View {
        VStack{
            Button(action: {
                showCreateOverlay = true
            }, label: {
                Text("Create User")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
            })
            .sheet(isPresented: $showCreateOverlay, content: {
                VStack(alignment: .leading){
                    Text("create a new User:")
                        .padding()
                        .multilineTextAlignment(.leading)
                    Text("what ID should the user have?")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("User ID", text: $newID)
                    Text("what is the username? ")
                        .multilineTextAlignment(.leading)
                        .padding()
                    TextField("username", text: $newName)
                        .padding()
                        .multilineTextAlignment(.leading)
                    //TODO: Admin checkbox
                    Text("should the User be an Admin? ")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("password: ", text: $newPassword)
                        .padding()
                        .multilineTextAlignment(.leading)
                    Button(action: {
                        if newPassword.count >= 8{
                            adminVM.createUser(userID: newID, name: newName, isAdmin: false, password: newPassword)
                        }
                    }, label: {
                        Text("Create User")
                            .frame(width: 244, height: 39)
                            .background(Color(hex: 0xD9D9D9))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    })
                }
            })
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(adminVM.users) { user in
                        UserView(user: user)
                            .environmentObject(adminVM)
                    }
                }
            })
            .padding()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
    }
}

struct AdminUserView_Previews: PreviewProvider {
    static var previews: some View {
        AdminUserView(showCreateOverlay: false, newID: "", newName: "", isAdmin: false, newPassword: "")
    }
}
