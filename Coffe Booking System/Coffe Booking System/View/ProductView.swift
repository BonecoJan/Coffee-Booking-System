import SwiftUI

struct ProductView: View {
    
    var product: AdminViewModel.ItemResponse
    @EnvironmentObject var orderVM : OrderViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    
    var body: some View {
        HStack {
            VStack{
                Text(product.name)
                    .multilineTextAlignment(.leading)
                Text(String(product.price) + " €")
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Button (action: {
                orderVM.addProductToCart(product: AdminViewModel.ItemResponse(id: product.id, name: product.name, amount: 1, price: product.price))
            }, label: {
                Image(systemName: "plus")
                    .background(
                        RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
                        .fill(Color(hex: 0xC08267))
                    )
                    .foregroundColor(.black)
                    .frame(width: 25, height: 25)
                    .padding()
            })
        }
        .padding()
        .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: 0xD9D9D9))
                )
        .multilineTextAlignment(.leading)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: AdminViewModel.ItemResponse(id: "", name: "", amount: 0, price: 0.0))
    }
}

