//
//  HomeView.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 14.06.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var modelService: ModelService
    
    var body: some View {
        ItemList()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
