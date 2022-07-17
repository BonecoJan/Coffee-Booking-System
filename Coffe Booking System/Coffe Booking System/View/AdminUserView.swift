import SwiftUI

struct AdminUserView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(adminVM.users) { user in
                        UserView(user: user)
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

struct AdminUserView_Previews: PreviewProvider {
    static var previews: some View {
        AdminUserView()
    }
}
