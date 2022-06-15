import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        
        Form{
            VStack {
                Text("Login")
                    .font(.largeTitle)
                
                TextField("User ID", text: $loginVM.id)
                    .padding()
                    .cornerRadius(5.0)
                    .padding()
                
                SecureField("Password", text: $loginVM.password)
                    .padding()
                    .cornerRadius(5.0)
                    .padding()
                
                HStack{
                    Spacer()
                    Button("Login") {
                        loginVM.login()
                    }
                    Button("Register") {
                        //TODO
                    }
                    Button("Forgot Password"){
                        //TODO
                    }
                }
            }
            
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
