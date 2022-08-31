import SwiftUI

//This View Displays one Item in the Itemlist of the HomeView
struct ProductView: View {
    
    //Item handed over by the ForEach
    var product: Item
    
    @EnvironmentObject var cartController : CartController
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(product.name)
                Text(String(product.price) + (String(product.price).countDecimalPlaces() < 2 ? "0" : "") + " €")
                Text("Amount: " + String(product.amount))
                    .font(.footnote)
            }
            Spacer()
            
            //If the amount of an Item is 0 show the Text and dismiss "+" button
            if(product.amount < 1) {
                Text("Not available at the moment")
                    .foregroundColor(.red)
            }
            Button (action: {
                cartController.addProductToCart(product: Response.Item(id: product.id, name: product.name, amount: 1, price: product.price))
            }, label: {
                Image(systemName: IMAGE_PLUS)
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 25, height: 25)
                    .padding()
                    .opacity(product.amount >= 1 ? 1 : 0)
            })
            .disabled(product.amount < 1)
            
        }
        .padding()
        .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                )
        .multilineTextAlignment(.leading)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: Item(id: "", name: "", amount: 0, price: 0.0))
    }
}

