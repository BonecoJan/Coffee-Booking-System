//
//  RegisterView.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 02.07.22.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var registerVM: RegisterViewModel
    
    var body: some View {
        
        Form{
            VStack {
                Text("Register")
                    .font(.largeTitle)
                
                //TextField("User ID", text: $registerVM.id)
                //    .padding()
                //    .cornerRadius(5.0)
                //    .padding()
                
                TextField("Username", text: $registerVM.name)
                    .padding()
                    .cornerRadius(5.0)
                    .padding()
                
                SecureField("Password", text: $registerVM.password)
                    .padding()
                    .cornerRadius(5.0)
                    .padding()
                
                HStack{
                    Spacer()
                    Button("Register") {
                        registerVM.register()
                    }
                }
            }
            
            
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
