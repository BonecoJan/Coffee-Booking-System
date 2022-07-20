//
//  UserViewObj.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 19.07.22.
//

import SwiftUI

struct UserViewObj: View {
    
    @State var showCreateOverlay : Bool = false
    var user: UserViewModel.UsersResponse
    @State var amount: String = ""
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Text("name: " + user.name)
                        .multilineTextAlignment(.leading)
                    Text("UserID: " + user.id)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Button(action: {
                    showCreateOverlay = true
                }, label: {
                    Text("Send Money")
                })
            }
            .sheet(isPresented: $showCreateOverlay, content: {
                VStack(alignment: .leading){
                    Text("Amount")
                        .multilineTextAlignment(.leading)
                        .padding()
                    TextField("0.0 €", text: $amount)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Button(action: {
                        profilVM.sendMoney(amount: Double(amount)!, recipientId: user.id)
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
            .multilineTextAlignment(.leading)
            .padding()
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: 0xD9D9D9))
                )
        }
    }
}
