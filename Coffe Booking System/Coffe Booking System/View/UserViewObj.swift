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
    @State var notEnoughMoney: Bool = false
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("name: " + user.name)
                    .padding()
            }
            Spacer()
            Button(action: {
                sendMoneyPopUp()
            }, label: {
                Text("Send Money")
            })
        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
            )
    }
    
    func sendMoneyPopUp() {
        let alert = UIAlertController(title: "Send Money", message: "Enter the amount to be sent", preferredStyle: .alert)
        
        alert.addTextField{ (amount) in
            amount.placeholder = "amount"
        }
        
        let change = UIAlertAction(title: "Send", style: .default) { (_) in
            amount = alert.textFields![0].text!
            if profilVM.balance - Double(amount)! >= 0.0 {
                profilVM.sendMoney(amount: Double(amount)!, recipientId: user.id)
                if profilVM.success {
                    sendMoneySuccess()
                } else {
                    sendMoneyFailure()
                }
            } else {
                notEnoughMoney = true
            }
        }
        
        let abort = UIAlertAction(title: "Abort", style: .destructive) { (_) in
            notEnoughMoney = false
        }
        
        alert.addAction(change)
        
        alert.addAction(abort)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
    func sendMoneySuccess() {
        let alert = UIAlertController(title: "Send Money", message: "money sent successfully", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
    func sendMoneyFailure() {
        let alert = UIAlertController(title: "Send Money", message: "failed to send money", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
}
