//
//  MainView.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 14.06.22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var modelService: ModelService
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
                .environmentObject(modelService)
            OrderView()
                .tabItem{
                    Image(systemName: "cart")
                    Text("Order")
                }
                .environmentObject(modelService)
            ProfilView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profil")
                }
                .environmentObject(modelService)
                .environmentObject(loginVM)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(LoginViewModel())
    }
}
