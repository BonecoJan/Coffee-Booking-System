import SwiftUI

struct CartProductView: View {
    
    @State var product: OrderViewModel.ProductInCart
    @EnvironmentObject var orderVM : OrderViewModel
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(product.name)
                Text(String(product.price) + (String(product.price).countDecimalPlaces() < 2 ? "0" : "") + " €")
            }.padding()
            Spacer()
            Button(action: {
                orderVM.addProductToCart(product: AdminViewModel.ItemResponse(id: product.id, name: product.name, amount: product.amount, price: product.price))
            }, label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
            }).padding()
            Text(String(product.amount))
            Button(action: {
                orderVM.deleteProductFromCart(product: AdminViewModel.ItemResponse(id: product.id, name: product.name, amount: product.amount, price: product.price))
            }, label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)
            }).padding()
        }
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

