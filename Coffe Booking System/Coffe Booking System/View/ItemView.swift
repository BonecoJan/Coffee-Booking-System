import SwiftUI

struct ItemView: View {
    
    var item: WebService.ItemResponse
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
                
                Menu("Edit") {
                    Text("Edit")
                }
                
                Menu("Delete") {
                    VStack{
                        Text("Do you really want to delete this item?")
                        Button(action: {
                            adminVM.deleteItem(itemID: item.id)
                            adminVM.getItems()
                        }, label: {
                            Text("Yes")
                        })
                    }
                }
            }
        })
        .padding()
    }
}
