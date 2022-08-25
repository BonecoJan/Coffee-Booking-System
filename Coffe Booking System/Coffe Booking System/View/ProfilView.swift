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
        SideMenu(width: 270, isOpen: self.menuOpen, menuClose: self.openMenu)
                .environmentObject(viewState)
                .environmentObject(loginVM)
                .environmentObject(profileVM)
                .environmentObject(transactionVM)
                .environmentObject(userVM)
        }.ignoresSafeArea()
        .alert("Error", isPresented: $profileVM.hasError, presenting: profileVM.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
            }
        }
        .alert("User updated successfully.", isPresented: $profileVM.updatedUser) {
            Button("OK", role: .cancel) {
                profileVM.updatedUser = false
            }
        }
        .alert("Image updated successfully.", isPresented: $profileVM.updatedImage) {
            Button("OK", role: .cancel) {
                profileVM.updatedImage = false
            }
        }
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
                    confirmChange(type: "image")
                }, label: {
                    Text("Change")
                        .opacity(self.selectedImage == Image("") ? 0 : 1)
                }).disabled(self.selectedImage == Image(""))
                Button(action: {
                    confirmChange(type: "deleteImage")
                }, label: {
                    Text("Delete")
                        .opacity(profileVM.image.encodedImage == "empty" ? 0 : 1)
                }).disabled(profileVM.image.encodedImage == "empty")
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
                    if self.userName != profileVM.name {
                        confirmChange(type: "username")
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
                Text(String(profileVM.balance.rounded(toPlaces: 2)) + (String(profileVM.balance.rounded(toPlaces: 2)).countDecimalPlaces() < 2 ? "0" : ""))
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
                //showChangeOverlay = true
                changePassword2()
            }, label: {
                Text("Change password")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $showChangeOverlay, content: {changePassword.background(Color(hex: 0xCCB9B1).edgesIgnoringSafeArea(.all))})
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
                        confirmChange(type: "password")
                    } else {
                        if newPassword.count < 8 && newPassword != repeatedPassword {
                            throw WebService.RequestError.custom(errorMessage: "Your new password must have a length of 8 at least. Also check that the repeated password is the same")
                        } else if newPassword.count < 8 && newPassword == repeatedPassword {
                            throw WebService.RequestError.custom(errorMessage: "Your new password must have a length of 8 at least.")
                        } else {
                            throw WebService.RequestError.custom(errorMessage: "Repeated password has to be the same")
                        }
                    }
                } else {
                    throw WebService.RequestError.custom(errorMessage: "Current password is not correct")
                }
            } catch let error {
                profileVM.error = error.localizedDescription
                profileVM.hasError = true
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
        let alert = UIAlertController(title: type == "deleteImage" ? "Delete image" : "Change \(type)", message: "Are you sure?", preferredStyle: .alert)
        
        let change = UIAlertAction(title: "Yes", style: .default) { (_) in
            if type == "username" {
                profileVM.updateUser(name: self.userName)
            } else if type == "password" {
                profileVM.updateUser(name: self.userName, password: newPassword)
            } else if type == "image" {
                let uiImage: UIImage = self.selectedImage.asUIImage()
                profileVM.uploadImage(image: uiImage)
            } else if type == "deleteImage" {
                profileVM.deleteImage()
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
