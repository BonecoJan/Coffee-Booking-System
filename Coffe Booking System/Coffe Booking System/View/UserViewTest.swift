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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack{
                ForEach(userVM.users) { user in
                    UserViewObj(user: user)
                        .environmentObject(userVM)
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
