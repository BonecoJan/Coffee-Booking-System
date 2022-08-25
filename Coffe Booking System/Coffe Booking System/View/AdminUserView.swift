import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}


struct AdminUserView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel

    @State var showCreateOverlay: Bool = false
    @State var newID: String = ""
    @State var newName: String = ""
    @State var isAdmin: Bool = false
    @State var newPassword: String = ""
    @State var detailView: Bool = false
    @State var searchText: String = ""
    
    func toggle(){isAdmin = !isAdmin}
    
    
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .passwordMissing

//    var searchResults: [AdminViewModel.UsersResponse] {
//            if searchText.isEmpty {
//                return adminVM.users
//            } else {
//                return adminVM.users.filter { $0.userResponse.id.contains(searchText) }
//            }
//        }
    
    enum ActiveAlert {
        case idMissing, nameMissing, passwordMissing, passwordLength//, failedCreation
    }
    
    
    init() {
        // Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        
        // Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        UINavigationBar.appearance().tintColor = UIColor.orange
    }
    
    var searchResults: [AdminViewModel.User] {
        if searchText.isEmpty {
            return adminVM.users
        } else {
            return adminVM.users.filter { $0.userResponse.id.contains(searchText)}
        }
    }

    
    var body: some View {
        VStack{
             NavigationView {
                List {
                    ForEach(searchResults) { user in
                        NavigationLink(
                            destination: AdminUserDetail(user: user)
                                .onAppear(perform: {
                                    detailView = true
                                    adminVM.getUser(user: user)
                                })
                                .onDisappear(perform: {
                                    detailView = false
                                    adminVM.getUsers()
                                })
                                ) {
                                    //Text("\(user.userResponse.id)")
                                    AdminUserRow(user: user)
//                                        .onAppear(perform: {
//                                            adminVM.getUser(user: user)
//                                        })
                                }
                    }
                }
                .searchable(text: $searchText)
                .navigationBarTitle("Users")
                //.navigationBarHidden(true)
                //.searchable(text: $newID)
                .toolbar {
                    Button(action: {
                        showCreateOverlay = true
                    }, label: {
                        Text("Create User")
                    })
                    .sheet(isPresented: $showCreateOverlay, content: {
                        adminCreateUser
                    })
                    
                }
            }
            .navigationViewStyle(DefaultNavigationViewStyle())
            
        }
//        .background(
//            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
//                .fill(Color(hex: 0xCCB9B1))
//            )

    }
    
    var adminCreateUser: some View {
        VStack(alignment: .leading){
            Text("New User")
                .bold()
                .padding()
                .multilineTextAlignment(.leading)
            Text("ID:")
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.leading)
            TextField("User ID", text: $newID)
                .padding()
                .multilineTextAlignment(.leading)
            Text("Username:")
                .multilineTextAlignment(.leading)
                .padding([.top, .leading, .trailing])
            TextField("Username", text: $newName)
                .padding()
                .multilineTextAlignment(.leading)
            //TODO: Admin checkbox
            Text("Password: ")
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.leading)
            SecureField("password: ", text: $newPassword)
                .padding()
                .multilineTextAlignment(.leading)
            Button(action: toggle){
                        HStack{
                            Image(systemName: isAdmin ? "checkmark.square": "square")
                            Text("Admin")
                        }

                    }
            .padding([.top, .leading, .trailing])
            .multilineTextAlignment(.leading)
            HStack(alignment: .center){
                Button(action: {
                    if self.newID != "" {
                        if self.newName != "" {
                            if self.newPassword != "" {
                                if newPassword.count >= 8{
                                    adminVM.createUser(userID: newID, name: newName, isAdmin: isAdmin, password: newPassword)
                                    print($adminVM.hasError)
                                } else {
                                    self.showAlert = true
                                    activeAlert = .passwordLength
                                }
                            } else {
                                self.showAlert = true
                                activeAlert = .passwordMissing
                            }
                        } else {
                            self.showAlert = true
                            activeAlert = .nameMissing
                        }
                    } else {
                        self.showAlert = true
                        activeAlert = .idMissing
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
                .alert("Error", isPresented: $adminVM.hasError, presenting: adminVM.error) { detail in
                    Button("Ok") {
                        //Do nothing
                    }
                } message: { detail in
                    if case let error = detail {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .idMissing:
                        return Alert(title: Text("Important message"), message: Text("Enter an ID."), dismissButton: .default(Text("Got it!")))
                    case .nameMissing:
                        return Alert(title: Text("Important message"), message: Text("Enter a name."), dismissButton: .default(Text("Got it!")))
                    case .passwordMissing:
                        return Alert(title: Text("Important message"), message: Text("Enter a password."), dismissButton: .default(Text("Got it!")))
                    case .passwordLength:
                        return Alert(title: Text("Important message"), message: Text("Length of password must be at least 8 characters."), dismissButton: .default(Text("Got it!")))
                    }
                }
                .alert("User created successfully.", isPresented: $adminVM.userCreated) {
                    Button("OK", role: .cancel) {
                        adminVM.userCreated = false
                        self.showCreateOverlay = false
                    }
                }
            }.frame(maxWidth: .infinity)

        }
    }
    
}

struct AdminUserRow: View {
    var user: AdminViewModel.User
    
    var body: some View {
        HStack {
            //CircleImage(imageName: user.image,size: 50).padding()
            if user.image.encodedImage == "empty" {
                Image("noProfilPicture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            } else {
                Image(base64String: user.image.encodedImage!)!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            }
            Text(user.userResponse.id)
                .bold()
                .font(.callout)
            Spacer()
        }.frame(height: 40)
    }
}


struct AdminUserDetail: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    

    
    enum ActiveAlert {
        case passwordMissing, userUpdated, balanceUpdated
    }

    var user: AdminViewModel.User
    
    @State var isAdmin: Bool = false
    @State private var passwordMissing = false
    @State private var userUpdated = false
    
    @State private var showAlert: Bool = false
    @State private var deletePicture: Bool = false
    @State private var deleteUser: Bool = false
    @State private var activeAlert: ActiveAlert = .passwordMissing

    
    func toggle(){isAdmin = !isAdmin}
    
    func resetValues() {
        adminVM.userPlaceholder.id = user.userResponse.id
        adminVM.userPlaceholder.name = user.userResponse.name
        adminVM.userPlaceholder.password = ""
        adminVM.userPlaceholder.balance = user.userResponse.balance
    }

    //var currentUser: AdminViewModel.Users = AdminViewModel.Users(id: "", name: "")
    //var currentUser:  AdminViewModel.UsersResponse = AdminViewModel.UsersResponse(id: "", name: "")

    
    @State private var showingImagePicker = false
    @State private var selectedImage: Image? = Image("")

    @Environment(\.editMode) var editMode
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    @ObservedObject var input = NumbersOnly()
    
    @State private var confirmationShown = false
    
    var body: some View {
        VStack {
            //CircleImage(imageName: employee.image, size: 120).padding()
//            Text(employee.preferredFullName)
//                .font(.title)
//            Divider()
            if user.image.encodedImage == "empty" {
                Image("noProfilPicture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            } else {
                Image(base64String: user.image.encodedImage!)!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .clipped()
                    .padding()
            }
            HStack {
                Button(action: {
                    self.showingImagePicker = true
                }, label: {
                    Text("Select Image")
                })
                Button(action: {
                    let uiImage: UIImage = self.selectedImage.asUIImage()
                    //adminVM.uploadImage(userID: user.userResponse.id, image: uiImage)
                    adminVM.uploadImage(user: user, image: uiImage)
                }, label: {
                    Text("Change")
                        .opacity(self.selectedImage == Image("") ? 0 : 1)
                }).disabled(self.selectedImage == Image(""))
                Button(action: {
                    deletePicture = true
                    //adminVM.deleteImage(user: user)
                }, label: {
                    Text("Delete")
                        .opacity(user.image.encodedImage == "empty" ? 0 : 1)
                })
                .disabled(user.image.encodedImage == "empty")
                .alert(isPresented:$deletePicture) {
                            Alert(
                                title: Text("Are you sure you want to delete this picture?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        adminVM.deleteImage(user: user)
                                        deletePicture = false
            }
                                },
                                secondaryButton: .cancel()
                            )
                        }

            }
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(image: self.$selectedImage)
            })
            Divider()
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("ID")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
                    TextField("", text: $adminVM.userPlaceholder.id)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
//                    Text(adminVM.currentUser.id)
//                        .font(.subheadline)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Name")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
                    TextField("" ,text: $adminVM.userPlaceholder.name)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Balance")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
//                    Text(String(adminVM.currentUser.balance ?? 0.00))
//                        .font(.subheadline)
                    TextField("" ,value: $adminVM.userPlaceholder.balance, formatter: formatter)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Password")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
                    SecureField("Password" ,text: $adminVM.userPlaceholder.password.toUnwrapped(defaultValue: ""))
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Button(action: toggle){
                                HStack{
                                    Image(systemName: isAdmin ? "checkmark.square": "square")
                                    Text("Admin")
                                }

                            }
                }
                .disabled(!isEditing)
                .isHidden(!isEditing)
                .padding([.top, .leading, .trailing])
            }
            Spacer()
            HStack(alignment: .bottom){
                //Delete User
                Button(role: .destructive, action: {
                    confirmationShown = true
                    deleteUser = true
                }){
                    Image(systemName: "trash")
                }
                .padding([.bottom, .leading, .trailing])
//                .confirmationDialog("Are you sure?", isPresented: $confirmationShown, titleVisibility: .visible) {
//                    Button("Yes", role: .destructive) {
//                        withAnimation {
//                            adminVM.deleteUser(userID: adminVM.currentUser.id)
//                        }
//                    }
//                }
                .alert(isPresented:$deleteUser) {
                            Alert(
                                title: Text("Are you sure you want to delete this user?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                adminVM.deleteUser(user: user)
                deleteUser = false
            }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                //Switch to edit mode
                Button(action: {
                    withAnimation {
                        editMode?.wrappedValue = isEditing ? .inactive : .active
                    }
                    if !isEditing {
                        if adminVM.userPlaceholder.balance != user.userResponse.balance {
                            if adminVM.userPlaceholder.balance ?? 0.0 > user.userResponse.balance ?? 0.0 {
                                //TODO: funding
                            }
                            adminVM.funding(userID: user.userResponse.id, amount: adminVM.userPlaceholder.balance ?? 0.0)
                            self.showAlert = true
                            activeAlert = .balanceUpdated
                        }
                        //adminVM.tmpUser.id != adminVM.currentUser.id || adminVM.tmpUser.name != adminVM.currentUser.name
                        else {
                            if adminVM.userPlaceholder.password != "" && (adminVM.userPlaceholder.password ?? "").count >= 8 {
                                adminVM.updateUser(userID: adminVM.userPlaceholder.id, name: adminVM.userPlaceholder.name, isAdmin: isAdmin, password: adminVM.userPlaceholder.password!)
                                adminVM.userPlaceholder.password = ""
                                self.showAlert = true
                                activeAlert = .userUpdated
                            } else {
                                self.showAlert = true
                                resetValues()
                                activeAlert = .passwordMissing
                            }
                        }
                    }
                        }
                       , label: {
                            Text(isEditing ? "save" : "edit")
                            .alert(isPresented: $showAlert) {
                                switch activeAlert {
                                case .passwordMissing:
                                    return Alert(title: Text("Important message"), message: Text("Enter a password."), dismissButton: .default(Text("Got it!")))
                                case .userUpdated:
                                    return Alert(title: Text(""), message: Text("User updated successfully"), dismissButton: .default(Text("Ok")))
                                case .balanceUpdated:
                                    return Alert(title: Text(""), message: Text("Balance updated successfully"), dismissButton: .default(Text("Ok")))
                                }
                            }
                        }
                )
                .padding([.bottom, .leading, .trailing])

                //Update User
                Button (action: {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
//                    if adminVM.tmpUser.id != adminVM.currentUser.id {
//                        adminVM.updateUser(userID: adminVM.tmpUser.id, name: adminVM.tmpUser.name, isAdmin: isAdmin, password: adminVM.tmpUser.password!)
//                    }
                    if !isEditing {
                        resetValues()
                    }
                }, label: {
                    Text("cancel")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding([.bottom, .trailing])
                })
                .disabled(!isEditing)
                .isHidden(!isEditing)
            }

        }
//        .background(
//            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
//                .fill(Color(hex: 0xCCB9B1))
//            )
        .navigationBarTitle(Text(verbatim: user.userResponse.id), displayMode: .inline)
        .onAppear(perform: {
            //self.userID = adminVM.currentUser.id
        })
    }
}



struct AdminUserView_Previews: PreviewProvider {
    
    static var previews: some View {
        AdminUserView()
    }
}





//import SwiftUI
//
//struct AdminUserView: View {
//
//    @EnvironmentObject var adminVM : AdminViewModel
//    @State var showCreateOverlay: Bool = false
//    @State var newID: String
//    @State var newName: String
//    @State var isAdmin: Bool
//    @State var newPassword: String
//
//    var body: some View {
//        VStack{
//            Button(action: {
//                showCreateOverlay = true
//            }, label: {
//                Text("Create User")
//                    .frame(width: 244, height: 39)
//                    .background(Color(hex: 0xD9D9D9))
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .foregroundColor(.black)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            })
//            .sheet(isPresented: $showCreateOverlay, content: {
//                VStack(alignment: .leading){
//                    Text("create a new User:")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    Text("what ID should the user have?")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    TextField("User ID", text: $newID)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    Text("what is the username? ")
//                        .multilineTextAlignment(.leading)
//                        .padding()
//                    TextField("username", text: $newName)
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    //TODO: Admin checkbox
//                    Text("should the User be an Admin? ")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    TextField("password: ", text: $newPassword)
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    Button(action: {
//                        if newPassword.count >= 8{
//                            adminVM.createUser(userID: newID, name: newName, isAdmin: false, password: newPassword)
//                        }
//                    }, label: {
//                        Text("Create User")
//                            .frame(width: 244, height: 39)
//                            .background(Color(hex: 0xD9D9D9))
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .foregroundColor(.black)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                    })
//                }
//            })
//            ScrollView(.vertical, showsIndicators: false, content: {
//                VStack{
//                    ForEach(adminVM.users) { user in
//                        UserView(user: user)
//                            .environmentObject(adminVM)
//                    }
//                }
//            })
//            .padding()
//        }.background(
//            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
//                .fill(Color(hex: 0xCCB9B1))
//            )
//    }
//}
//
//struct AdminUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminUserView(showCreateOverlay: false, newID: "", newName: "", isAdmin: false, newPassword: "")
//    }
//}
