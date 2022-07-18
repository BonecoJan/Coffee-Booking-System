import SwiftUI

struct OrderView: View {

    @EnvironmentObject var shop: Shop
    @StateObject var orderVM = OrderViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(orderVM.cart) { product in
                        //TODO: PurchaseItem View
                    }
                }
            })
            HStack {
                Text("Total")
                Spacer()
                Text(String(orderVM.total) + " €")
            }.padding()
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
