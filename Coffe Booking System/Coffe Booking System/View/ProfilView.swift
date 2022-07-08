import SwiftUI

struct ProfilView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    @State var userName: String = ""
    @State var userID: String = ""
    
    var body: some View {
        //TODO: If isAdmin == true then show AdminMenue (with WindowGroup?)
        VStack {
            Text(profileVM.isAdmin ? "Your Profile(Admin)" : "Your Profile")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            Text("Name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person")
                    .padding()
                Text(profileVM.name)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {/*TODO: Username Change*/}, label: {
                    Image(systemName: "square.and.pencil")
                        .padding()
                })
            }.offset(y: -20)
            Text("ID")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person.text.rectangle")
                    .padding()
                Text(profileVM.id)
                //Text(self.userID)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
            //this Button is hidden if the user is not an admin
            if self.$profileVM.isAdmin.wrappedValue {
                Button (action: {
                    //go to Admin Menue
                    viewState.state = 1
                }, label: {
                    Text("Admin Menue")
                })
            }
            Button(action: {
                //TODO: Password Change
            }, label: {
                Text("Change password")
            })
            Button("Logout") {
                loginVM.logout()
            }
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        Task{
            do {
                let user = try await self.shop.modelService.webService.getUser()
                print(user.id)
                print(user.name)
                print("test")
                self.userID = user.id
                self.userName = user.name
                self.shop.currentUser.id = user.id
                self.shop.currentUser.name = user.name
            } catch {
                print("fail")
            }
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
