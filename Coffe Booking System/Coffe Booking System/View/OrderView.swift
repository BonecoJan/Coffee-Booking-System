import SwiftUI

struct OrderView: View {

    @EnvironmentObject var shop: Shop
    @EnvironmentObject var orderVM : OrderViewModel
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(orderVM.cart) { product in
                        CartProductView(product: product)
                            .environmentObject(orderVM)
                    }
                }
            })
            VStack{
                Text("Your Cart is empty... add some coffee to it first!")
                    .padding()
                    .multilineTextAlignment(.center)
                    .opacity(orderVM.total > 0.0 ? 0 : 1)
            }
            HStack {
                Text(orderVM.total > 0.0 ? "Total:" : "")
                Spacer()
                Text(orderVM.total > 0.0 ? String(orderVM.total) + " €" : "")
            }.padding()
            Button(action: {
                orderVM.purchase(profilVM: profilVM)
            }, label: {
                Text("Pay")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xC08267))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
                    .opacity(orderVM.total > 0.0 ? 1 : 0)
            })
            Spacer()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}

