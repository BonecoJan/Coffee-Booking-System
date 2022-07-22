//
//  UserViewObj.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 19.07.22.
//

import SwiftUI

struct UserViewObj: View {

    var user: UserViewModel.UsersResponse
    @State var amount: String = ""
    @State var showPopUp: Bool = false
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        ZStack{
            HStack{
                VStack(alignment: .leading){
                    Text("name: " + user.name)
                        .padding()
                }
                Spacer()
                Button(action: {
                    showPopUp = true
                }, label: {
                    Text("Send Money")
                })
            }
            .padding()
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                    .fill(Color(hex: 0xD9D9D9))
                )
            if $showPopUp.wrappedValue {
                ZStack {
                    Color.white
                    VStack(alignment: .leading){
                        Text("Amount")
                            .multilineTextAlignment(.leading)
                            .padding()
                        TextField("0.0 €", text: $amount)
                            .multilineTextAlignment(.leading)
                            .padding()
                        HStack{
                            Button(action: {
                                profilVM.sendMoney(amount: Double(amount)!, recipientId: user.id)
                                showPopUp = false
                            }, label: {
                                Text("Send money")
                                    .padding()
                            })
                            Button(action: {
                                showPopUp = false
                            }, label: {
                                Text("abort")
                                    .padding()
                            })
                        }
                    }
                }
                .frame(width: 300, height: 200)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
    }
}
