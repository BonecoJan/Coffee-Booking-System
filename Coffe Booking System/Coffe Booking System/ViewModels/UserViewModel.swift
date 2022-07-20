//
//  UserViewModel.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 19.07.22.
//

import Foundation

class UserViewModel: ObservableObject {
    
    struct UsersResponse: Codable, Identifiable {
        var id: String
        var name: String
    }
    
    @Published var users:  [UsersResponse] = []
    
    func getUsers() {
        Task {
            do {
                let body: WebService.empty? = nil
                let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users", reqMethod: "GET", authReq: false, body: body, responseType: [UsersResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                print("failed to get users from server")
            }
        }
    }
    
    
}
