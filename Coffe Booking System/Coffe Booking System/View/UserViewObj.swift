//
//  UserViewObj.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 19.07.22.
//

import SwiftUI

struct UserViewObj: View {
    
    var user: UserViewModel.UsersResponse
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text("name: " + user.name)
            //Text("id: " + user.id)
            
        })
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
            )
        
    }
}
