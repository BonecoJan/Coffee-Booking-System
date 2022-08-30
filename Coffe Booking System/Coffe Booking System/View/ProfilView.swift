import SwiftUI

struct ProfilView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var shop: Shop
    
    @State private var showingImagePicker = false
    @State private var selectedImage: Image? = Image("")
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var repeatedPassword: String = ""
    @State var userName: String = ""
    @State var userID: String = ""
    
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
                        transactionController.getTransactions(shop: shop, userID: shop.profile.id)
                        self.openMenu()
                    }, label: {
                        Image(systemName: IMAGE_LIST)
                    })
                }
                Text(shop.profile.isAdmin ? "Your Profile(Admin)" : "Your Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Button(action: {
                    viewState.state = 0
                }, label: {
                    Image(systemName: IMAGE_ARROW_LEFT)
                        .resizable()
                        .frame(width: 25, height: 20, alignment: .leading)
                }).padding()
            }.padding()
            profilPicture
            showUserData
            bottomSection
        }.ignoresSafeArea()
        .onAppear(perform: {
            self.userName = shop.profile.name
        })
        SideMenu(width: 270, isOpen: self.menuOpen, menuClose: self.openMenu)
                .environmentObject(viewState)
                .environmentObject(loginController)
                .environmentObject(profileController)
                .environmentObject(transactionController)
                .environmentObject(userController)
        }.ignoresSafeArea()
        .alert("Error", isPresented: $profileController.hasError, presenting: profileController.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
            }
        }
        .alert(SUCCESS_UPDATE_USER, isPresented: $profileController.updatedUser) {
            Button("OK", role: .cancel) {
                profileController.updatedUser = false
            }
        }
        .alert(SUCCESS_UPDATE_IMAGE, isPresented: $profileController.updatedImage) {
            Button("OK", role: .cancel) {
                profileController.updatedImage = false
            }
        }
    }
    
    var profilPicture: some View {
        VStack{
            if shop.profile.image.encodedImage == NO_PROFILE_IMAGE {
                Image(IMAGE_NO_PROFILE_IMAGE)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            } else {
                Image(base64String: shop.profile.image.encodedImage!)!
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
                    confirmChange(type: "image")
                }, label: {
                    Text("Change")
                        .opacity(self.selectedImage == Image("") ? 0 : 1)
                }).disabled(self.selectedImage == Image(""))
                Button(action: {
                    confirmChange(type: TYPE_DELETE_IMAGE)
                }, label: {
                    Text("Delete")
                        .opacity(shop.profile.image.encodedImage == NO_PROFILE_IMAGE ? 0 : 1)
                }).disabled(shop.profile.image.encodedImage == NO_PROFILE_IMAGE)
            }
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(image: self.$selectedImage)
            })
        }
    }
    
    var showUserData: some View {
        VStack{
            if !self.menuOpen {
                Button (action: {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                    if self.userName != shop.profile.name {
                        confirmChange(type: TYPE_USERNAME)
                    }
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                })
            }
            HStack{
                Image(systemName: IMAGE_PROFILE)
                    .padding()
                TextField("", text: $userName)
                    .disabled(!isEditing)
                Spacer()
                Button(action: {
                    withAnimation {
                        editMode?.wrappedValue = isEditing ? .inactive : .active
                    }
                    if !isEditing {
                        self.userName = shop.profile.name
                    }
                        }, label: {
                            Image(systemName: isEditing ? IMAGE_PENCIL_EDIT : IMAGE_PENCIL)
                            .padding()
                        })
            }.offset(y: -20)
            HStack{
                Image(systemName: IMAGE_ID)
                    .padding()
                Text(shop.profile.id)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
            HStack{
                Image(systemName: IMAGE_EURO)
                    .padding()
                Text(String(shop.profile.balance.rounded(toPlaces: 2)) + (String(shop.profile.balance.rounded(toPlaces: 2)).countDecimalPlaces() < 2 ? "0" : ""))
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
        }
    }
    
    var changePassword: some View {
            VStack{
                Text("Current password:")
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                TextField("current password", text: $currentPassword)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                Text("New password")
                    .multilineTextAlignment(.leading)
                TextField("new password", text: $newPassword)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                TextField("repeat new password: ", text: $repeatedPassword)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                Spacer()
                Button(action: {
                    if newPassword.count >= 8 && newPassword == repeatedPassword {
                        if checkPassword(password: currentPassword) {
                            profileController.updateUser(shop: shop, name: self.userName, password: newPassword)
                        }
                    }
                }, label: {
                    Text("Change password")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
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
                //showChangeOverlay = true
                changePassword2()
            }, label: {
                Text("Change password")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $showChangeOverlay, content: {changePassword.background(Color(hex: UInt(COLOR_BACKGROUND)).edgesIgnoringSafeArea(.all))})
        }
    }
    
    func checkPassword(password: String) -> Bool {
        //try to get user password from Keychain
        if let password = KeychainWrapper.standard.get(service: SERVICE_PASSWORD, account: ACCOUNT) {
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
    
    func changePassword2() {
        let alert = UIAlertController(title: "Change your password", message: "Enter your current password first and then type in the new one", preferredStyle: .alert)
        
        alert.addTextField{ (pass) in
            pass.isSecureTextEntry = true
            pass.placeholder = "current password"
        }
        
        alert.addTextField{ (newPass) in
            newPass.isSecureTextEntry = true
            newPass.placeholder = "new password"
        }
        
        alert.addTextField() { (repPass) in
            repPass.isSecureTextEntry = true
            repPass.placeholder = "repeat new password"
        }
        
        let change = UIAlertAction(title: "Change", style: .default) { (_) in
            currentPassword = alert.textFields![0].text!
            newPassword = alert.textFields![1].text!
            repeatedPassword = alert.textFields![2].text!
            do {
                if checkPassword(password: currentPassword) {
                    if newPassword.count >= 8 && newPassword == repeatedPassword {
                        confirmChange(type: TYPE_PASSWORD)
                    } else {
                        if newPassword.count < 8 && newPassword != repeatedPassword {
                            throw RequestError.custom(errorMessage: "Your new password must have a length of 8 at least. Also check that the repeated password is the same")
                        } else if newPassword.count < 8 && newPassword == repeatedPassword {
                            throw RequestError.custom(errorMessage: "Your new password must have a length of 8 at least.")
                        } else {
                            throw RequestError.custom(errorMessage: "Repeated password has to be the same")
                        }
                    }
                } else {
                    throw RequestError.custom(errorMessage: "Current password is not correct")
                }
            } catch let error {
                profileController.error = error.localizedDescription
                profileController.hasError = true
            }
            
        }
        
        let abort = UIAlertAction(title: "Abort", style: .destructive) { (_) in
            //Do nothing
        }
        
        alert.addAction(change)
        
        alert.addAction(abort)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
    func confirmChange(type: String) {
        let alert = UIAlertController(title: type == TYPE_DELETE_IMAGE ? "Delete image" : "Change \(type)", message: "Are you sure?", preferredStyle: .alert)
        
        let change = UIAlertAction(title: "Yes", style: .default) { (_) in
            if type == TYPE_USERNAME {
                profileController.updateUser(shop: shop, name: self.userName)
            } else if type == TYPE_PASSWORD {
                profileController.updateUser(shop: shop, name: self.userName, password: newPassword)
            } else if type == TYPE_UPLOAD_IMAGE {
                let uiImage: UIImage = self.selectedImage.asUIImage()
                profileController.uploadImage(shop: shop, image: uiImage)
            } else if type == TYPE_DELETE_IMAGE {
                profileController.deleteImage(shop: shop)
            }
        }
        
        let abort = UIAlertAction(title: "Abort", style: .destructive) { (_) in
            //Do nothing
        }
        
        alert.addAction(change)
        
        alert.addAction(abort)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
