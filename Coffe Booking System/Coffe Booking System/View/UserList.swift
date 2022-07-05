import SwiftUI

struct UserList: View {
    @State var users: [WebService.UsersResponse] = []
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .onAppear {
            WebService(authManager: AuthManager()).getUsers { (users) in
                self.users = users
            }
        }
//        .task {
//            do {
//                let user = try await WebService(authManager: AuthManager()).getUser()
//                print(user.id!)
//                print(user.name!)
//                Text(user.id!)
//                Text(user.name!)
//            } catch {
//            }
//        }
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}
