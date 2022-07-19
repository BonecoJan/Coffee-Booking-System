import SwiftUI

struct ProfilView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var userVM: UserViewModel
    @State var userName: String = ""
    @State var userID: String = ""
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var repeatedPassword: String = ""
    //@State var isVisible: Bool = false
    
    @State var menuOpen: Bool = false
    @State var showChangeOverlay: Bool = false
    @Environment(\.editMode) var editMode
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        ZStack{
        VStack {
            Text(profileVM.isAdmin ? "Your Profile(Admin)" : "Your Profile")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            if !self.menuOpen {
                Button (action: {
                    //TODO update user
                    self.openMenu()
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                    if self.userName != profileVM.name {
                        profileVM.updateUser(name: self.userName)
                    }
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                })
            }
            Text("Name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person")
                    .padding()
                TextField("", text: $userName)
                    //.fontWeight(.bold)
                    .disabled(!isEditing)
                Spacer()
                Button(action: {
                            withAnimation {
                                editMode?.wrappedValue = isEditing ? .inactive : .active
                            }
                    if !isEditing {
                        self.userName = profileVM.name
                    }
                        }, label: {
                            Image(systemName: isEditing ? "pencil.slash" : "pencil")
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
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
            Text("Balance: " + String(profileVM.balance) + " €")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            //this Button is hidden if the user is not an admin
            if self.$profileVM.isAdmin.wrappedValue {
                Button (action: {
                    //go to Admin Menue
                    viewState.state = 1
                }, label: {
                    Text("Admin Menue")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: 0xD9D9D9))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                })
            }
            bottomSection
            //TODO: zu viele Elemente
            //Spacer()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
        .onAppear(perform: {
            self.userName = profileVM.name
            //self.isVisible = (self.userName != profileVM.name)
        })
            SideMenu(width: 270,
                     isOpen: self.menuOpen,
                     menuClose: self.openMenu)
        }
    }
    
    var changePassword: some View {
            VStack(alignment: .leading){
                Text("Current password:")
                    .padding()
                    .multilineTextAlignment(.leading)
                TextField("Password", text: $currentPassword)
                    .padding()
                    .multilineTextAlignment(.leading)
                Text("New Password")
                    .multilineTextAlignment(.leading)
                    .padding()
                TextField("username", text: $newPassword)
                    .padding()
                    .multilineTextAlignment(.leading)
                Text("Repeat new password")
                    .padding()
                    .multilineTextAlignment(.leading)
                TextField("password: ", text: $repeatedPassword)
                    .padding()
                    .multilineTextAlignment(.leading)
                Button(action: {
                    if newPassword.count >= 8 && newPassword == repeatedPassword {
                        if checkPassword(password: currentPassword) {
                            profileVM.updateUser(name: self.userName, password: newPassword)
                        }
                    }
                }, label: {
                    Text("Change password")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: 0xD9D9D9))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                })
            }
    }
    
    var bottomSection: some View {
        VStack{
            Button(action: {
                //TODO: bool
                viewState.state = 3
            }, label: {
                Text("Show Users")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            Button(action: {
                //TODO: Password Change
                showChangeOverlay = true
            }, label: {
                Text("Change password")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $showChangeOverlay, content: {changePassword})
            Button(action: {
                loginVM.logout()
            }, label: {
                Text("Logout")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
        }
    }
    
    func checkPassword(password: String) -> Bool {
                    //try to get user password from Keychain
                    if let password = KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System") {
                    let password = String(data: password, encoding: .utf8)!

                        if password != currentPassword {
                            return false
                        }

                    } else {
                        print("cannot fetch current user data - missing token")
                        return false
                    }

        return true
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
