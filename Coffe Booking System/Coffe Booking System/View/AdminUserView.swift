import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

extension View {
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
    
    @EnvironmentObject var adminController : AdminController
    @EnvironmentObject var shop: Shop
    
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

    
    enum ActiveAlert {
        case idMissing, nameMissing, passwordMissing, passwordLength
    }
    
    
    init() {
        // Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        
        // Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        UINavigationBar.appearance().tintColor = UIColor.orange
    }
    
    //Search results for search bar
    var searchResults: [User] {
        if searchText.isEmpty {
            return shop.users
        } else {
            return shop.users.filter { $0.userResponse.id.contains(searchText)}
        }
    }

    //Navigation view
    var body: some View {
        VStack{
             NavigationView {
                List {
                    ForEach(searchResults) { user in
                        NavigationLink(
                            destination: AdminUserDetail(user: user)
                                .environmentObject(shop)
                                .onAppear(perform: {
                                    detailView = true
                                    adminController.getUser(user: user)
                                })
                                .onDisappear(perform: {
                                    detailView = false
                                    adminController.getUsers(shop: shop)
                                })
                                ) {
                                    AdminUserRow(user: user)
                                        .environmentObject(shop)

                                }
                    }
                }
                .searchable(text: $searchText)
                .navigationBarTitle("Users")

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

    }
    
    //create user view
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
            Text("Password: ")
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.leading)
            SecureField("password: ", text: $newPassword)
                .padding()
                .multilineTextAlignment(.leading)
            Button(action: toggle){
                        HStack{
                            Image(systemName: isAdmin ? IMAGE_SQUARE_MARK: IMAGE_SQUARE)
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
                                    adminController.createUser(shop: shop, userID: newID, name: newName, isAdmin: isAdmin, password: newPassword)
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
                        .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                })
                .alert("Error", isPresented: $adminController.hasError, presenting: adminController.error) { detail in
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
                .alert("User created successfully.", isPresented: $adminController.userCreated) {
                    Button("OK", role: .cancel) {
                        adminController.userCreated = false
                        self.showCreateOverlay = false
                    }
                }
            }.frame(maxWidth: .infinity)

        }
    }
    
}

//representation of rows in navigation view
struct AdminUserRow: View {
    var user: User
    
    var body: some View {
        HStack {
            if user.image.encodedImage == NO_PROFILE_IMAGE {
                Image(IMAGE_NO_PROFILE_IMAGE)
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

//detail view
struct AdminUserDetail: View {
    
    @EnvironmentObject var adminController : AdminController
    @EnvironmentObject var shop: Shop

    
    enum ActiveAlert {
        case passwordMissing, userUpdated, balanceUpdated
    }

    var user: User
    
    @State var isAdmin: Bool = false
    @State private var passwordMissing = false
    @State private var userUpdated = false
    
    @State private var showAlert: Bool = false
    @State private var deletePicture: Bool = false
    @State private var deleteUser: Bool = false
    @State private var activeAlert: ActiveAlert = .passwordMissing

    
    func toggle(){isAdmin = !isAdmin}
    
    func resetValues() {
        adminController.userPlaceholder.id = user.userResponse.id
        adminController.userPlaceholder.name = user.userResponse.name
        adminController.userPlaceholder.password = ""
        adminController.userPlaceholder.balance = user.userResponse.balance
    }

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
            if user.image.encodedImage == NO_PROFILE_IMAGE {
                Image(IMAGE_NO_PROFILE_IMAGE)
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
                    adminController.uploadImage(user: user, image: uiImage)
                }, label: {
                    Text("Change")
                        .opacity(self.selectedImage == Image("") ? 0 : 1)
                }).disabled(self.selectedImage == Image(""))
                Button(action: {
                    deletePicture = true
                }, label: {
                    Text("Delete")
                        .opacity(user.image.encodedImage == NO_PROFILE_IMAGE ? 0 : 1)
                })
                .disabled(user.image.encodedImage == NO_PROFILE_IMAGE)
                .alert(isPresented:$deletePicture) {
                            Alert(
                                title: Text("Are you sure you want to delete this picture?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        adminController.deleteImage(user: user)
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
                    TextField("", text: $adminController.userPlaceholder.id)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Name")
                        .font(.subheadline)
                        .bold()
                    TextField("" ,text: $adminController.userPlaceholder.name)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Balance")
                        .font(.subheadline)
                        .bold()
                    TextField("" ,value: $adminController.userPlaceholder.balance, formatter: formatter)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Password")
                        .font(.subheadline)
                        .bold()
                    SecureField("Password" ,text: $adminController.userPlaceholder.password.toUnwrapped(defaultValue: ""))
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Button(action: toggle){
                                HStack{
                                    Image(systemName: isAdmin ? IMAGE_SQUARE_MARK: IMAGE_SQUARE)
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
                .alert(isPresented:$deleteUser) {
                            Alert(
                                title: Text("Are you sure you want to delete this user?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        adminController.deleteUser(shop: shop, user: user)
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
                        //update balance
                        if adminController.userPlaceholder.balance != user.userResponse.balance {
                                let difference = (adminController.userPlaceholder.balance ?? 0.0) - (user.userResponse.balance ?? 0.0)
                                adminController.funding(shop: self.shop, userID: user.userResponse.id, amount: difference)

                            self.showAlert = true
                            activeAlert = .balanceUpdated
                        }
                        else {
                            //update user
                            if adminController.userPlaceholder.password != "" && (adminController.userPlaceholder.password ?? "").count >= 8 {
                                adminController.updateUser(shop: shop, userID: adminController.userPlaceholder.id, name: adminController.userPlaceholder.name, isAdmin: isAdmin, password: adminController.userPlaceholder.password!)
                                adminController.userPlaceholder.password = ""
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

                //Canecel edit action
                Button (action: {
                    withAnimation {
                        resetValues()

                        editMode?.wrappedValue = .inactive
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
        .navigationBarTitle(Text(verbatim: user.userResponse.id), displayMode: .inline)
    }
}



struct AdminUserView_Previews: PreviewProvider {
    
    static var previews: some View {
        AdminUserView()
    }
}
