import SwiftUI

struct OrderView: View {

    @EnvironmentObject var shop: Shop
    
    var body: some View {
        Text("OrderView")
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
