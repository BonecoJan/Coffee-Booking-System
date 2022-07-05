import SwiftUI

struct ItemList: View {
    @State var items: [Item] = []
    
    var body: some View {
        List(items) { item in
            Text(item.name)
        }
        .onAppear {
            WebService(authManager: AuthManager()).getItems { (items) in
                self.items = items
            }
            
        }
    }
}

struct ItemsList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList()
    }
}
