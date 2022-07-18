import SwiftUI

struct AdminItemView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    @State var showCreateOverlay: Bool = false
    @State var newID: String
    @State var newName: String
    @State var newAmount: String
    @State var newPrice: String
    
    var body: some View {
        VStack{
            
            Button(action: {
                showCreateOverlay = true
            }, label: {
                Text("Create Item")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
            })
            .sheet(isPresented: $showCreateOverlay, content: {
                VStack(alignment: .leading){
                    Text("create a new Item:")
                        .padding()
                        .multilineTextAlignment(.leading)
                    Text("What is the Item ID? ")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("Item ID", text: $newID)
                    Text("what is the Item name? ")
                        .multilineTextAlignment(.leading)
                        .padding()
                    TextField("Name", text: $newName)
                        .padding()
                        .multilineTextAlignment(.leading)
                    Text("what is the amount? ")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("amount ", text: $newAmount)
                        .padding()
                        .multilineTextAlignment(.leading)
                    Text("what is the price? ")
                        .padding()
                        .multilineTextAlignment(.leading)
                    TextField("price: ", text: $newPrice)
                        .padding()
                        .multilineTextAlignment(.leading)
                    Button(action: {
                        //TODO: Create Item here
                        adminVM.createItem(name: newName, amount: Int(newAmount)!, price: Double(newPrice)!)
                    }, label: {
                        Text("Create Item")
                            .frame(width: 244, height: 39)
                            .background(Color(hex: 0xD9D9D9))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    })
                }
            })
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(adminVM.items) { item in
                        ItemView(item: item)
                            .environmentObject(adminVM)
                    }
                }
            })
            .padding()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
        
    }
}

struct AdminItemView_Previews: PreviewProvider {
    static var previews: some View {
        AdminItemView(showCreateOverlay: false, newID: "", newName: "", newAmount: "", newPrice: "")
    }
}
