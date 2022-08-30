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
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var shop: Shop
    
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
                        .environmentObject(loginController)
                        .environmentObject(profileController)
                        .environmentObject(transactionController)
                        .environmentObject(userController)
                        .environmentObject(shop)
                }
                Spacer()
            }
        }
    }
}

struct MenuContent: View {
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var shop: Shop
    
    @State var overText = false
    
    var body: some View {
            List {
                Text("Cancel last purchase").onTapGesture {
                    confirmRefund()
                }.alert("Error", isPresented: $profileController.hasError, presenting: profileController.error) { detail in
                    Button("Ok", role: .cancel) {}
                } message: { detail in
                    if case let error = detail {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .alert(SUCCESS_REFUND, isPresented: $profileController.success) {
                    Button("OK", role: .cancel) {
                        profileController.success = false
                    }
                }
                Text("Send money").onTapGesture {
                    userController.getUsers(shop: shop)
                    viewState.state = 3
                }
                Text("Transaction History").onTapGesture {
                    transactionController.getTransactions(userID: shop.profile.id)
                    viewState.state = 5
                }
                Text("Statistics").onTapGesture {
                    viewState.state = 6
                }
                Text("Achievements").onTapGesture {
                    viewState.state = 7
                }
                Text("Logout").onTapGesture {
                    loginController.logout(shop: shop)
                    viewState.state = 0
                }
                if $shop.profile.isAdmin.wrappedValue {
                    Text("Admin Menue").onTapGesture {
                        viewState.state = 1
                    }
                }
            }
    }
    
    func confirmRefund() {
        let alert = UIAlertController(title: "Cancel last purchase", message: "Are you sure?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Yes", style: .default) { (_) in
            profileController.cancelLastPurchase(shop: shop)
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
