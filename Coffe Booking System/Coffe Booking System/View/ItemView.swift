import SwiftUI
import Combine

struct ItemView: View {
    
    var item: Response.Item
    @State var showEditOverlay: Bool = false
    @State var showDeleteOverlay: Bool = false
    @State var newName: String = ""
    @State var newAmount: String = ""
    @State var newPrice: String = ""
    @EnvironmentObject var adminController : AdminController
    @EnvironmentObject var shop: Shop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text(item.name)
            Text("id: " + item.id)
            
            HStack{
                Text("amount: " + String(item.amount ?? 0))
                Spacer()
                Text("price:" + String(item.price))
            }
            
            HStack{
                
                Button(action: {
                    showEditOverlay = true
                }, label: {
                    Text("Edit")
                })
                .sheet(isPresented: $showEditOverlay, content: {
                    VStack(alignment: .leading){
                        Text("Edit the item:")
                            .padding()
                            .multilineTextAlignment(.leading)
                        Text("Item ID: " + item.id)
                            .padding()
                            .multilineTextAlignment(.leading)
                        Text("Current Name: " + item.name)
                            .multilineTextAlignment(.leading)
                            .padding()
                        TextField("New name", text: $newName)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Text("Current amount: " + String(item.amount ?? 0))
                            .padding()
                            .multilineTextAlignment(.leading)
                        TextField("New amount: ", text: $newAmount)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.numberPad)
                                        .onReceive(Just(newAmount)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.newAmount = filtered
                                            }
                                    }
                        Text("Current price: " + String(item.price))
                            .padding()
                            .multilineTextAlignment(.leading)
                        TextField("New price: ",text: $newPrice)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Button(action: {
                            if newName == "" {
                                newName = item.name
                            }
                            
                            if newAmount == "" {
                                newAmount = String(item.amount ?? 0)
                            }
                            
                            if newPrice == "" {
                                newPrice = String(item.price)
                            }
                            adminController.updateItem(shop: shop, itemID: item.id, name: newName, amount: Int(newAmount)!, price: Double(newPrice)!)
                        }, label: {
                            Text("Update item")
                                .frame(width: 244, height: 39)
                                .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        })
                    }
                })
                Button(action: {
                    showDeleteOverlay = true
                }, label: {
                    Text("Delete")
                })
                .sheet(isPresented: $showDeleteOverlay, content: {
                    VStack(alignment: .leading){
                        Text("Do you really want to delete this item?")
                            .frame(alignment: .leading)
                        Button(action: {
                            adminController.deleteItem(shop: shop, itemID: item.id)
                            adminController.getItems(shop: shop)
                        }, label: {
                            Text("Yes")
                                .frame(width: 244, height: 39)
                                .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        })
                    }
                })
                Spacer()
                
            }
        })
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: UInt(COLOR_LIGHT_GRAY)))
            )
    }
}
