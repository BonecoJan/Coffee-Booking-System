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
        .multilineTextAlignment(.leading)
    Spacer()
    Button(action: {
        showCreateOverlay = true
    }, label: {
        Text("Send Money")
            .frame(width: 244, height: 39)
            .background(Color(hex: 0xC08267))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .foregroundColor(.black)
    })
    .sheet(isPresented: $showCreateOverlay, content: {
        VStack(alignment: .leading){
            //TODO: Send money
            Text("Amount")
            Button(action: {
                //TODO: perform api-request
            }, label: {
                Text("Send money")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
            })
        }
    })
}
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
            )
    }
}
