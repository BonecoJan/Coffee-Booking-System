import SwiftUI

struct UserView: View {
    
    var user: Response.User
    @State var showEditOverlay: Bool = false
    @State var showDeleteOverlay: Bool = false
    @EnvironmentObject var adminController : AdminController
    
    @State var newName: String = ""
    @State var newPassword: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text("name: " + user.name)
            Text("id: " + user.id)
            
            HStack{
                Button(action: {
                    showEditOverlay = true
                }, label: {
                    Text("Edit")
                })
                .sheet(isPresented: $showEditOverlay, content: {
                    VStack(alignment: .leading){
                        Text("Edit the User:")
                            .padding()
                            .multilineTextAlignment(.leading)
                        Text("User ID: " + user.id)
                            .padding()
                            .multilineTextAlignment(.leading)
                        Text("Current Name: " + user.name)
                            .multilineTextAlignment(.leading)
                            .padding()
                        TextField("New Name", text: $newName)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Text("Should the User be an Admin?")
                            .padding()
                            .multilineTextAlignment(.leading)
                        //TODO: Checkbox for isAdmin
                        //TODO: Get
                        Text("Set a new password (optional): ")
                            .padding()
                            .multilineTextAlignment(.leading)
                        TextField("New password",text: $newPassword)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Button(action: {
                            if newName == "" {
                                newName = user.name
                            }
                            adminController.updateUser(userID: user.id, name: newName, isAdmin: false, password: newPassword)
                        }, label: {
                            Text("Update User")
                                .frame(width: 244, height: 39)
                                .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        })
                    }
                })
                Button(action: {
                    showDeleteOverlay = true
                }, label: {
                    Text("Delete")
                })
                .sheet(isPresented: $showDeleteOverlay, content: {
                    VStack(alignment: .leading){
                        Text("Do you really want to delete this User?")
                            .frame(alignment: .leading)
                        Button(action: {
                            adminController.deleteUser(userID: user.id)
                            adminController.getUsers()
                        }, label: {
                            Text("Yes")
                                .frame(width: 244, height: 39)
                                .background(Color(hex: UInt(COLOR_LIGHT_GRAY)))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        })
                    }
                })
                Spacer()
            }
        })
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: UInt(COLOR_LIGHT_GRAY)))
            )
        
    }
}

