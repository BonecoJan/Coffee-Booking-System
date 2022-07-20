//
//  UserViewTest.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 19.07.22.
//

import SwiftUI



struct UserViewTest: View {
    
    //@EnvironmentObject var userVM : UserViewModel
    @ObservedObject var userVM = UserViewModel()
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                viewState.state = 0
            }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .leading)
            }).padding()
        }
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack{
                ForEach(userVM.users) { user in
                    UserViewObj(user: user)
                        .environmentObject(userVM)
                        .environmentObject(profilVM)
                }
            }
        })
        .onAppear(perform: userVM.getUsers)
    }
}

struct UserViewTest_Previews: PreviewProvider {
    static var previews: some View {
        UserViewTest()
    }
}
