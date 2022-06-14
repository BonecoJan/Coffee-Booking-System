//
//  MainView.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 14.06.22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            OrderView()
                .tabItem{
                    Image(systemName: "cart")
                    Text("Order")
                }
            ProfilView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profil")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(LoginViewModel())
    }
}
