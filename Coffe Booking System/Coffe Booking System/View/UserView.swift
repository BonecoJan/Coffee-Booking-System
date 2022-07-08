import SwiftUI

struct UserView: View {
    
    var user: WebService.UsersResponse
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text("name: " + user.name)
            Text("id: " + user.id)
            
            HStack{
                
                Menu("Edit") {
                    Text("Edit Menu")
                }
                
                Menu("Delete") {
                    Text("Delete Menu")
                }
                
            }
        })
        .padding()
    }
}

