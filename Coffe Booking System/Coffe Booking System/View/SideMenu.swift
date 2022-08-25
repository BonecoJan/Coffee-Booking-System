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
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
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
                ZStack{
                    MenuContent()
                        .frame(width: self.width)
                        .background(Color.white)
                        .offset(x: self.isOpen ? 0 : -self.width)
                        .animation(.default)
                        .environmentObject(viewState)
                        .environmentObject(loginVM)
                        .environmentObject(profileVM)
                        .environmentObject(transactionVM)
                        .environmentObject(userVM)
                }
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
    @EnvironmentObject var userVM: UserViewModel
    
    @State var overText = false
    
    var body: some View {
            List {
                Text("Cancel last purchase").onTapGesture {
                    confirmRefund()
                }.alert("Error", isPresented: $profileVM.hasError, presenting: profileVM.error) { detail in
                    Button("Ok", role: .cancel) {}
                } message: { detail in
                    if case let error = detail {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .alert("Purchase refunded successfully.", isPresented: $profileVM.success) {
                    Button("OK", role: .cancel) {
                        profileVM.success = false
                    }
                }
                Text("Send money").onTapGesture {
                    userVM.getUsers()
                    viewState.state = 3
                }
                Text("Transaction History").onTapGesture {
                    transactionVM.getTransactions(userID: profileVM.id)
                    viewState.state = 5
                }
                Text("Statistics").onTapGesture {
                    viewState.state = 6
                }
                Text("Achievements").onTapGesture {
                    viewState.state = 7
                }
                Text("Logout").onTapGesture {
                    loginVM.logout(profilVM: profileVM)
                    viewState.state = 0
                }
                if $profileVM.isAdmin.wrappedValue {
                    Text("Admin Menue").onTapGesture {
                        viewState.state = 1
                    }
                }
            }
    }
    
    func confirmRefund() {
        let alert = UIAlertController(title: "Cancel last purchase", message: "Are you sure?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Yes", style: .default) { (_) in
            profileVM.cancelLastPurchase()
        }
        
        let abort = UIAlertAction(title: "Abort", style: .destructive) { (_) in
            //Do nothing
        }
        
        alert.addAction(cancel)
        
        alert.addAction(abort)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
}
