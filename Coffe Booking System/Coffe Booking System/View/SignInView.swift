import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        Text("Login")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .font(.title)
        //Login Fields
        HStack{
            Image(systemName: "person.text.rectangle")
                .padding()
            TextField("User ID", text: $loginVM.id)
                .cornerRadius(5.0)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        HStack{
            Image(systemName: "lock")
                .padding()
            SecureField("Password", text: $loginVM.password)
                .cornerRadius(5.0)
        }
        .offset(y: -20)
        
        //Sign in button
        Button(action: {
            loginVM.login(profilVM: profilVM)
        },
        label: {
            Text("Sign in")
                .frame(width: 244, height: 39)
                .background(Color(hex: 0xC08267))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(.black)
        })
        .alert("Error", isPresented: $loginVM.hasError, presenting: loginVM.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .alert("Successfully logged in", isPresented: $loginVM.success) {
            Button("OK", role: .cancel) {
                loginVM.success = false
                loginVM.isAuthenticated = true
                homeVM.getProducts()
                transactionVM.getTransactions(userID: profilVM.id)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView().environmentObject(LoginViewModel())
            SignInView().environmentObject(LoginViewModel())
        }
    }
}
