import SwiftUI

struct AdminItemView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(adminVM.items) { item in
                        ItemView(item: item)
                            .environmentObject(adminVM)
                    }
                }
            })
            .padding()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
        
    }
}

struct AdminItemView_Previews: PreviewProvider {
    static var previews: some View {
        AdminItemView()
    }
}
