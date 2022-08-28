import SwiftUI

struct ProductView: View {
    
    var product: Response.Item
    @EnvironmentObject var cartController : CartController
    @EnvironmentObject var homeController : HomeController
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(product.name)
                Text(String(product.price) + (String(product.price).countDecimalPlaces() < 2 ? "0" : "") + " €")
            }
            Spacer()
            Button (action: {
                cartController.addProductToCart(product: Response.Item(id: product.id, name: product.name, amount: 1, price: product.price))
            }, label: {
                Image(systemName: IMAGE_PLUS)
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 25, height: 25)
                    .padding()
            })
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
        ProductView(product: Response.Item(id: "", name: "", amount: 0, price: 0.0))
    }
}

