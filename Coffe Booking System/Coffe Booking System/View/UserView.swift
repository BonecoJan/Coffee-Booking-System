import SwiftUI

struct UserView: View {
    
    var user: WebService.UsersResponse
    @State var showEditOverlay: Bool = false
    @State var showDeleteOverlay: Bool = false
    @EnvironmentObject var adminVM : AdminViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text("name: " + user.name)
            Text("id: " + user.id)
            
            HStack{
                
                Button(action: {
                    showEditOverlay = true
                }, label: {
                    Text("Edit")
                })
                .sheet(isPresented: $showEditOverlay, content: {
                    
                })
                
                Button(action: {
                    showDeleteOverlay = true
                }, label: {
                    Text("Delete")
                })
                .sheet(isPresented: $showEditOverlay, content: {
                    
                })
            }
        })
        .padding()
    }
}

