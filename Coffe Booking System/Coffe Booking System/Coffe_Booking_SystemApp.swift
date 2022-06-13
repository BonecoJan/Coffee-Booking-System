//
//  Coffe_Booking_SystemApp.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 09.06.22.
//

import SwiftUI

@main
struct Coffe_Booking_SystemApp: App {
    
    var body: some Scene {
        WindowGroup {
            LoginView()
            ItemList()
        }
    }
}
