import SwiftUI

struct AdminUserView: View {
    
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack{
            Text("Items")
                .fontWeight(.bold)
                .frame(alignment: .leading)
                .padding()
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    ForEach(adminVM.users) { user in
                        UserView(user: user)
                            .environmentObject(adminVM)
                    }
                }
            })
            .padding()
        }
    }
}

struct AdminUserView_Previews: PreviewProvider {
    static var previews: some View {
        AdminUserView()
    }
}
