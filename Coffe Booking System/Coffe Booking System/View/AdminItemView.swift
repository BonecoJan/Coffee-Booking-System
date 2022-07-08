import SwiftUI

struct AdminItemView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack{
            Text("Items")
                .fontWeight(.bold)
                .frame(alignment: .leading)
                .padding()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(adminVM.items) { item in
                        ItemView(item: item)
                            .environmentObject(adminVM)
                    }
                }
            })
            .padding()
        }
    }
}

struct AdminItemView_Previews: PreviewProvider {
    static var previews: some View {
        AdminItemView()
    }
}
