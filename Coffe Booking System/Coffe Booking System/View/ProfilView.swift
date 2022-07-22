import SwiftUI

struct ProfilView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @State var userName: String = ""
    @State var userID: String = ""
    
    @State private var showingImagePicker = false
    @State private var selectedImage: Image? = Image("")
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var repeatedPassword: String = ""
    
    @State var menuOpen: Bool = false
    @State var showChangeOverlay: Bool = false
    @Environment(\.editMode) var editMode
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        ZStack{
        VStack {
            HStack{
                if !self.menuOpen {
                    Button(action: {
                        transactionVM.getTransactions(userID: profileVM.id)
                        self.openMenu()
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
                }
                Text(profileVM.isAdmin ? "Your Profile(Admin)" : "Your Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Button(action: {
                    viewState.state = 0
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 25, height: 20, alignment: .leading)
                }).padding()
            }.padding()
            profilPicture
            showUserData
            bottomSection
        }.ignoresSafeArea()

        .onAppear(perform: {
            self.userName = profileVM.name

        })
            SideMenu(width: 270,
                     isOpen: self.menuOpen,
                     menuClose: self.openMenu)
            .environmentObject(userVM)
        }.ignoresSafeArea()
    }
    
    var profilPicture: some View {
        VStack{
            if profileVM.image.encodedImage == "empty" {
                Image("noProfilPicture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            } else {
                Image(base64String: profileVM.image.encodedImage!)!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            }
            HStack{
                Button(action: {
                    self.showingImagePicker = true
                }, label: {
                    Text("Select Image")
                })
                Button(action: {
                    let uiImage: UIImage = self.selectedImage.asUIImage()
                    profileVM.uploadImage(image: uiImage)
                }, label: {
                    Text("Change")
                })
                Button(action: {
                    profileVM.deleteImage()
                }, label: {
                    Text("Delete")
                        .opacity(profileVM.image.encodedImage == "empty" ? 0 : 1)
                })
            }
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(image: self.$selectedImage)
            }
            )
            
        }
    }
    
    var showUserData: some View {
        VStack{
            if !self.menuOpen {
                Button (action: {
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
            HStack{
                Image(systemName: "person")
                    .padding()
                TextField("", text: $userName)
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
            HStack{
                Image(systemName: "person.text.rectangle")
                    .padding()
                Text(profileVM.id)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
            HStack{
                Image(systemName: "eurosign.circle")
                    .padding()
                Text(String(profileVM.balance))
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
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
