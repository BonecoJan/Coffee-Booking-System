//
//  ContentView.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 09.06.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
        var api = API()
        api.apiGetRequest("users")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
