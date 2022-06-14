import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        Form{
            VStack {
                Text("Login")
                    .font(.largeTitle)
                TextField("User ID", text: $loginVM.id)
                TextField("Password", text: $loginVM.password)
                HStack{
                    Spacer()
                    Button("Login") {
                        loginVM.login()
                    }
                    Button("Register") {
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
