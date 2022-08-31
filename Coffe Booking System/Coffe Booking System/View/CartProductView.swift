import SwiftUI

//This View displays one Item in the cart of a user
struct CartProductView: View {
    
    //Item handed over by the ForEach
    @State var product: Item
    
    @EnvironmentObject var cartController : CartController
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(product.name)
                Text(String(product.price) + (String(product.price).countDecimalPlaces() < 2 ? "0" : "") + " €")
            }.padding()
            Spacer()
            Button(action: {
                cartController.addProductToCart(product: Response.Item(id: product.id, name: product.name, amount: product.amount, price: product.price))
            }, label: {
                Image(systemName: IMAGE_PLUS_CIRCLE)
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
            }).padding()
            Text(String(product.amount))
            Button(action: {
                cartController.deleteProductFromCart(product: Response.Item(id: product.id, name: product.name, amount: product.amount, price: product.price))
            }, label: {
                Image(systemName: IMAGE_MINUS_CIRCLE)
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
            }).padding()
        }
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: UInt(COLOR_LIGHT_GRAY)))
            )
    }
}

struct CartProductView_Previews: PreviewProvider {
    static var previews: some View {
        CartProductView(product: Item(id: "", name: "", amount: 0, price: 0.0))
    }
}

