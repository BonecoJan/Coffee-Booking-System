//
//  SideMenu.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 19.07.22.
//

import SwiftUI

struct SideMenu: View {
    let width: CGFloat
    let isOpen: Bool
    let menuClose: () -> Void
    
    @State var state: Int = 0
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(self.isOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.menuClose()
            }
            
            HStack {
                MenuContent()
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.default)
                Spacer()
            }
        }
    }
}

struct MenuContent: View {
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    @State private var overText = false
    @State private var showPopUp = false
    
    var body: some View {
        ZStack{
            List {
                Text("Cancel last purchase").onTapGesture {
                    self.showPopUp = true
                }
                Text("Send money").onTapGesture {
                    viewState.state = 3
                }
                Text("Transaction History").onTapGesture {
                    transactionVM.getTransactions(userID: profileVM.id)
                    viewState.state = 5
                }
                Text("Statistics").onTapGesture {
                    viewState.state = 2
                }
                Text("Logout").onTapGesture {
                    viewState.state = 0
                    loginVM.logout()
                }
                if $profileVM.isAdmin.wrappedValue {
                    Text("Admin Menue").onTapGesture {
                        viewState.state = 1
                    }
                }
            }
            if $showPopUp.wrappedValue {
                ZStack {
                    Color.white
                    VStack {
                        Text("Are you sure?")
                        Spacer()
                        Button(action: {
                            self.showPopUp = false
                            profileVM.cancelLastPurchase()
                        }, label: {
                            Text("yes")
                        }).padding()
                        Button(action: {
                            self.showPopUp = false
                        }, label: {
                            Text("abort")
                        })
                    }.padding()
                }
                .frame(width: 300, height: 200)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
    }
}
