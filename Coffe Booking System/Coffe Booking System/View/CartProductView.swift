import SwiftUI

struct CartProductView: View {
    
    @State var product: OrderViewModel.ProductInCart
    @EnvironmentObject var orderVM : OrderViewModel
    
    var body: some View {
        HStack{
            VStack {
                Text(product.name)
                    .multilineTextAlignment(.leading)
                Text(String(product.price) + " €")
                    .multilineTextAlignment(.leading)
            }.padding()
            Spacer()
            Button(action: {
                orderVM.addProductToCart(product: AdminViewModel.ItemResponse(id: product.id, name: product.name, amount: product.amount, price: product.price))
            }, label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
            }).padding()
            Text(String(product.amount))
            Button(action: {
                orderVM.deleteProductFromCart(product: AdminViewModel.ItemResponse(id: product.id, name: product.name, amount: product.amount, price: product.price))
            }, label: {
                Image(systemName: "minus.circle")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
            }).padding()
        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
            )
    }
}

struct CartProductView_Previews: PreviewProvider {
    static var previews: some View {
        CartProductView(product: OrderViewModel.ProductInCart(id: "", name: "", amount: 0, price: 0.0))
    }
}

