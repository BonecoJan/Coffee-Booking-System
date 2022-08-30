import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var shop: Shop
    
    var body: some View {
        Text("Login")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .font(.title)
        //Login Fields
        HStack{
            Image(systemName: IMAGE_ID)
                .padding()
            TextField("User ID", text: $loginController.id)
                .cornerRadius(5.0)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        HStack{
            Image(systemName: IMAGE_PASSWORD)
                .padding()
            SecureField("Password", text: $loginController.password)
                .cornerRadius(5.0)
        }
        .offset(y: -20)
        
        //Sign in button
        Button(action: {
            loginController.login(shop: shop, profileController: profileController)
        },
        label: {
            Text("Sign in")
                .frame(width: 244, height: 39)
                .background(Color(hex: UInt(COLOR_RED_BROWN)))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(.black)
        })
        .alert("Error", isPresented: $loginController.hasError, presenting: loginController.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .alert(SUCCESS_LOGIN, isPresented: $loginController.success) {
            Button("OK", role: .cancel) {
                loginController.success = false
                loginController.isAuthenticated = true
                homeController.getProducts(shop: shop)
                transactionController.getTransactions(userID: shop.profile.id)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView().environmentObject(LoginController())
            SignInView().environmentObject(LoginController())
        }
    }
}
