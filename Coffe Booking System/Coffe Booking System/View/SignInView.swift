import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        Text("Login")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
        //Login Fields
        HStack{
            Image(systemName: "person.circle")
                .padding()
            TextField("User ID", text: $loginVM.id)
                .cornerRadius(5.0)
        }
        HStack{
            Image(systemName: "lock")
                .padding()
            SecureField("Password", text: $loginVM.password)
                .cornerRadius(5.0)
        }
        .offset(y: -20)
        
        //Forgot password Button
        Button(action: {}, label: {
            Text("Forgot password?")
                .foregroundColor(.black)
        })
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        
        //Sign in button
        Button(action: {
            loginVM.login()
        },
        label: {
            Text("Sign in")
                .frame(width: 244, height: 39)
                .background(Color(hex: 0xC08267))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(.black)
        })
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
