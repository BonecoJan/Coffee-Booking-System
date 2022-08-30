import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var shop: Shop
    
    @State var newID: String = ""
    @State var newName: String = ""
    @State var newPassword: String = ""
    @State var repeatedPassword: String = ""
    @State var invalidUserData: Bool = false
    
    var body: some View {
        
        Text("Register")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .font(.title)
        
        //Register Fields
        HStack{
            Image(systemName: IMAGE_NAME)
                .padding()
            TextField("Name", text: $newName)
                .cornerRadius(5.0)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        HStack{
            Image(systemName: IMAGE_ID)
                .padding()
            TextField("User ID", text: $newID)
                .cornerRadius(5.0)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .offset(y: -20)
        HStack{
            Image(systemName: IMAGE_PASSWORD)
                .padding()
            SecureField("Password (at least 8 characters)", text: $newPassword)
                .cornerRadius(5.0)
        }
        .offset(y: -40)
        HStack{
            Image(systemName: IMAGE_PASSWORD)
                .padding()
            SecureField("Repeat password", text: $repeatedPassword)
                .cornerRadius(5.0)
        }
        .offset(y: -60)
        //try to register with given account data and in case of success login with the new registered account
        Button(action: {
            if newPassword.count >= 8 && newName != "" && newPassword == repeatedPassword{
                loginController.register(shop: shop, id: newID, name: newName, password: newPassword, profileController: profileController)
            } else {
                invalidUserData = true
            }
        },
        label: {
            Text("Sign up")
                .frame(width: 244, height: 39)
                .background(Color(hex: UInt(COLOR_RED_BROWN)))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(.black)
        })
        .alert("Error", isPresented: $loginController.hasError, presenting: loginController.error) { detail in
            Button("Ok") {
                //Do nothing
            }
        } message: { detail in
            if case let error = detail {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .alert(SUCCESS_REGISTER, isPresented: $loginController.success) {
            Button("OK", role: .cancel) {
                loginController.success = false
                loginController.isAuthenticated = true
            }
        }
        .offset(y: -60)
        Text(invalidUserData ? "Please check your password and username" : "")
            .offset(y: -60)
            .foregroundColor(.red)
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
