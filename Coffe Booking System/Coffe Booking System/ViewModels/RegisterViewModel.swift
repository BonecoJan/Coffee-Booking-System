//
//  RegisterViewModel.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 02.07.22.
//

import Foundation

class RegisterViewModel: ObservableObject {
    
    //@Published var id: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    
    func register() {
        
        WebService().register(/*id: id, */name: name, password: password) { result in
            switch result {
                case .success(let registerResponse):
                print(registerResponse.id) // Use expiration for automatic token refresh
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
