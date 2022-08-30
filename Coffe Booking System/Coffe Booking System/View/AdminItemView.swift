import SwiftUI

struct AdminItemView: View {
    
    @EnvironmentObject var adminController : AdminController
    @EnvironmentObject var shop: Shop
    
    @State var showCreateOverlay: Bool = false
    
    @State var newID: String = ""
    @State var newName: String = ""
    @State var newAmount: Int = 0
    @State var newPrice: Double = 0.0
    
    @State var detailView: Bool = false
    @State var searchText: String = ""
    
    
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .idMissing
    
    enum ActiveAlert {
        case idMissing, nameMissing, amountMissing, priceMissing//, failedCreation
    }
    
    init() {
        // Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        
        // Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        UINavigationBar.appearance().tintColor = UIColor.orange
    }
    
    var searchResults: [Item] {
        if searchText.isEmpty {
            return shop.items
        } else {
            return shop.items.filter { $0.name.contains(searchText)}
        }
    }

    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        VStack{
             NavigationView {
                List {
                    ForEach(searchResults) { item in
                        NavigationLink(
                            destination: AdminItemDetail(item: item)
                                .environmentObject(shop)
                                .onAppear(perform: {
                                    detailView = true
                                    adminController.getItem(itemID: item.id)
                                })
                                .onDisappear(perform: {
                                    detailView = false
                                    adminController.getItems(shop: shop)
                                })
                                ) {
                                    Text("\(item.name)")
                                    //AdminItemRow(item: item)
//                                        .onAppear(perform: {
//                                            adminController.getUser(user: user)
//                                        })
                                }
                    }
                }
                .searchable(text: $searchText)
                .navigationBarTitle("Items")
                //.navigationBarHidden(true)
                //.searchable(text: $newID)
                .toolbar {
                    Button(action: {
                        showCreateOverlay = true
                    }, label: {
                        Text("Create Item")
                    })
                    .sheet(isPresented: $showCreateOverlay, content: {
                        adminCreateItem
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
    
    var adminCreateItem: some View {
        VStack(alignment: .leading){
            Text("New Item")
                .bold()
                .padding()
                .multilineTextAlignment(.leading)
            Text("ID:")
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.leading)
            TextField("Item ID", text: $newID)
                .padding()
                .multilineTextAlignment(.leading)
            Text("Name:")
                .multilineTextAlignment(.leading)
                .padding([.top, .leading, .trailing])
            TextField("Name", text: $newName)
                .padding()
                .multilineTextAlignment(.leading)
            Text("Amount: ")
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.leading)
            TextField("" ,value: $newAmount, formatter: formatter)
                .padding()
                .multilineTextAlignment(.leading)
            Text("Price: ")
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.leading)
            TextField("" ,value: $newPrice, formatter: formatter)
            .padding([.top, .leading, .trailing])
            .multilineTextAlignment(.leading)
            HStack(alignment: .center){
                Button(action: {
                    if self.newID != "" {
                        if self.newName != "" {
                            if self.newAmount > 0 {
                                if newPrice > 0.0 {
                                    adminController.createItem(shop: shop, name: newName, amount: newAmount, price: newPrice)
                                    print($adminController.hasError)
                                } else {
                                    self.showAlert = true
                                    activeAlert = .priceMissing
                                }
                            } else {
                                self.showAlert = true
                                activeAlert = .amountMissing
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
                    Text("Create Item")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: 0xD9D9D9))
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
                    case .amountMissing:
                        return Alert(title: Text("Important message"), message: Text("Enter amount."), dismissButton: .default(Text("Got it!")))
                    case .priceMissing:
                        return Alert(title: Text("Important message"), message: Text("Enter price."), dismissButton: .default(Text("Got it!")))
                    }
                }
                .alert("Item created successfully.", isPresented: $adminController.itemCreated) {
                    Button("OK", role: .cancel) {
                        adminController.itemCreated = false
                        self.showCreateOverlay = false
                    }
                }
            }.frame(maxWidth: .infinity)

        }
    }
    
}

struct AdminItemRow: View {
    var item: Item
    
    var body: some View {
        HStack {
            Text(item.name)
                .bold()
                .font(.callout)
            Spacer()
        }.frame(height: 40)
    }
}


struct AdminItemDetail: View {
    
    @EnvironmentObject var adminController : AdminController
    @EnvironmentObject var shop: Shop
    
    enum ActiveAlert {
        case passwordMissing, itemUpdated, balanceUpdated
    }

    var item: Item
    
    @State private var passwordMissing = false
    @State private var itemUpdated = false
    
    @State private var showAlert: Bool = false
    @State private var deleteItem: Bool = false
    @State private var activeAlert: ActiveAlert = .passwordMissing

        
    func resetValues() {
        adminController.itemPlaceholder.id = item.id
        adminController.itemPlaceholder.name = item.name
        adminController.itemPlaceholder.amount = item.amount ?? 0
        adminController.itemPlaceholder.price = item.price
    }

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
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("ID")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
                    TextField("", text: $adminController.itemPlaceholder.id)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
//                    Text(adminController.currentUser.id)
//                        .font(.subheadline)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Name")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
                    TextField("" ,text: $adminController.itemPlaceholder.name)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Amount")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
//                    Text(String(adminController.currentUser.balance ?? 0.00))
//                        .font(.subheadline)
                    TextField("" ,value: $adminController.itemPlaceholder.amount, formatter: formatter)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
                HStack(alignment: .top) {
                    Text("Price")
                        .font(.subheadline)
                        .bold()
                    //Spacer()
                    TextField("" ,value: $adminController.itemPlaceholder.price, formatter: formatter)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                        .disabled(!isEditing)
                }.padding([.top, .leading, .trailing])
            }
            Spacer()
            HStack(alignment: .bottom){
                //Delete User
                Button(role: .destructive, action: {
                    confirmationShown = true
                    deleteItem = true
                }){
                    Image(systemName: "trash")
                }
                .padding([.bottom, .leading, .trailing])
//                .confirmationDialog("Are you sure?", isPresented: $confirmationShown, titleVisibility: .visible) {
//                    Button("Yes", role: .destructive) {
//                        withAnimation {
//                            adminController.deleteUser(userID: adminController.currentUser.id)
//                        }
//                    }
//                }
                .alert(isPresented:$deleteItem) {
                            Alert(
                                title: Text("Are you sure you want to delete this item?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        adminController.deleteItem(shop: shop, itemID: item.id)
                deleteItem = false
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
                        adminController.updateItem(shop: shop, itemID: adminController.itemPlaceholder.id, name: adminController.itemPlaceholder.name, amount: adminController.itemPlaceholder.amount ?? 0, price: adminController.itemPlaceholder.price)
                        self.showAlert = true
                        activeAlert = .itemUpdated
                    }
                        }
                       , label: {
                            Text(isEditing ? "save" : "edit")
                            .alert(isPresented: $showAlert) {
                                switch activeAlert {
                                case .passwordMissing:
                                    return Alert(title: Text("Important message"), message: Text("Enter a password."), dismissButton: .default(Text("Got it!")))
                                case .itemUpdated:
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
//                    if adminController.tmpUser.id != adminController.currentUser.id {
//                        adminController.updateUser(userID: adminController.tmpUser.id, name: adminController.tmpUser.name, isAdmin: isAdmin, password: adminController.tmpUser.password!)
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
        .navigationBarTitle(Text(verbatim: item.id), displayMode: .inline)
        .onAppear(perform: {
            //self.userID = adminController.currentUser.id
        })
    }
}



struct AdminItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        AdminItemView()
    }
}





//import SwiftUI
//
//struct AdminItemView: View {
//
//    @EnvironmentObject var adminController : AdminViewModel
//    @State var showCreateOverlay: Bool = false
//    @State var newID: String
//    @State var newName: String
//    @State var newAmount: String
//    @State var newPrice: String
//
//    var body: some View {
//        VStack{
//
//            Button(action: {
//                showCreateOverlay = true
//            }, label: {
//                Text("Create Item")
//                    .frame(width: 244, height: 39)
//                    .background(Color(hex: 0xD9D9D9))
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .foregroundColor(.black)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            })
//            .sheet(isPresented: $showCreateOverlay, content: {
//                VStack(alignment: .leading){
//                    Text("create a new Item:")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    Text("What is the Item ID? ")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    TextField("Item ID", text: $newID)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    Text("what is the Item name? ")
//                        .multilineTextAlignment(.leading)
//                        .padding()
//                    TextField("Name", text: $newName)
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    Text("what is the amount? ")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    TextField("amount ", text: $newAmount)
//                        .keyboardType(.decimalPad)
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    Text("what is the price? ")
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                    TextField("price: ", text: $newPrice)
//                        .keyboardType(.decimalPad)
//                        .padding()
//                        .multilineTextAlignment(.leading)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                    Button(action: {
//                        //TODO: Create Item here
//                        adminController.createItem(name: newName, amount: Int(newAmount)!, price: Double(newPrice)!)
//                    }, label: {
//                        Text("Create Item")
//                            .frame(width: 244, height: 39)
//                            .background(Color(hex: 0xD9D9D9))
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .foregroundColor(.black)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                    })
//                }
//            })
//
//            ScrollView(.vertical, showsIndicators: false, content: {
//                VStack{
//                    ForEach(adminController.items) { item in
//                        ItemView(item: item)
//                            .environmentObject(adminController)
//                    }
//                }
//            })
//            .padding()
//        }.background(
//            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
//                .fill(Color(hex: 0xCCB9B1))
//            )
//
//    }
//}
//
//struct AdminItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminItemView(showCreateOverlay: false, newID: "", newName: "", newAmount: "", newPrice: "")
//    }
//}
