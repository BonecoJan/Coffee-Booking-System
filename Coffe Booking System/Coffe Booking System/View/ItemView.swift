import SwiftUI
import Combine

struct ItemView: View {
    
    var item: WebService.ItemResponse
    @State var showEditOverlay: Bool = false
    @State var showDeleteOverlay: Bool = false
    @State var newName: String = ""
    @State var newAmount: String = ""
    @State var newPrice: String = ""
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text(item.name)
            Text("id: " + item.id)
            
            HStack{
                Text("amount: " + String(item.amount))
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
                    VStack{
                        Text("Edit the item:")
                        Text("Item ID: " + item.id)
                        Text("Current Name: " + item.name)
                        TextField("New name", text: $newName)
                        Text("Current amount: ")
                        TextField("New amount: ", text: $newAmount)
                            .keyboardType(.numberPad)
                                        .onReceive(Just(newAmount)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.newAmount = filtered
                                            }
                                    }
                        Text("Current price: ")
                        TextField("New price: ",text: $newPrice)
                            .keyboardType(.numberPad)
                                        .onReceive(Just(newPrice)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.newPrice = filtered
                                            }
                                    }
                        Button(action: {
                            if newName == "" {
                                newName = item.name
                            }
                            
                            if newAmount == "" {
                                newAmount = String(item.amount)
                            }
                            
                            if newPrice == "" {
                                newPrice = String(item.price)
                            }
                            adminVM.updateItems(itemID: item.id, name: item.name, amount: Int(item.amount), price: Double(item.price))
                            adminVM.getItems()
                        }, label: {
                            Text("Update item")
                        })
                    }
                })
                
                Button(action: {
                    showDeleteOverlay = true
                }, label: {
                    Text("Delete")
                })
                .sheet(isPresented: $showDeleteOverlay, content: {
                    VStack{
                        Text("Do you really want to delete this item?")
                            .frame(alignment: .leading)
                        Button(action: {
                            adminVM.deleteItem(itemID: item.id)
                            adminVM.getItems()
                        }, label: {
                            Text("Yes")
                        })
                    }
                })
                
                
            }
        })
        .padding()
    }
}
