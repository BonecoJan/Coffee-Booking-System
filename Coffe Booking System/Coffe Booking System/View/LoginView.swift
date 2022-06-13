//
//  LoginView.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 13.06.22.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVC = LoginViewController()
    @StateObject private var itemVC = ItemViewController()
    
    var body: some View {
        Form{
            VStack {
                TextField("User ID", text: $loginVC.id)
                SecureField("Password", text: $loginVC.password)
                HStack{
                    Spacer()
                    Button("Login") {
                        loginVC.login()
                        if loginVC.isAuthenticated {
                            //itemVC.getAllItems()
                            //ItemView()
                            ItemList()
                        }
                    }
                    Button("Register") {
                        //TODO
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
