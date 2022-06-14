//
//  UserList.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 14.06.22.
//

import SwiftUI

struct UserList: View {
    @State var users: [WebService.UsersResponse] = []
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .onAppear {
            WebService().getUsers { (users) in
                self.users = users
            }
        }
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}
