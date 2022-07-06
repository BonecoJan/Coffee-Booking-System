//
//  ProfilView.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 14.06.22.
//

import SwiftUI

struct ProfilView: View {
    
    @EnvironmentObject var modelService: ModelService
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        //TODO: If isAdmin == true then show AdminMenue (with WindowGroup?)
        VStack {
            Text("Your Profile")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            Text("Name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person")
                    .padding()
                Text(modelService.shop.currentUser.name)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {/*TODO: Username Change*/}, label: {
                    Image(systemName: "square.and.pencil")
                        .padding()
                })
            }.offset(y: -20)
            Text("ID")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person.text.rectangle")
                    .padding()
                Text(modelService.shop.currentUser.id)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
            Button(action: {
                //TODO: Password Change
            }, label: {
                Text("Change password")
            })
            Button("Logout") {
                loginVM.logout()
            }
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
