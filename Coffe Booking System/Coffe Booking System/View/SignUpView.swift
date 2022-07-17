import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var registerVM: RegisterViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        
        Text("Register")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
        //Register Fields
        HStack{
            Image(systemName: "person.circle")
                .padding()
            TextField("Name", text: $registerVM.name)
                .cornerRadius(5.0)
        }
        HStack{
            Image(systemName: "person.circle")
                .padding()
            TextField("User ID", text: $registerVM.id)
                .cornerRadius(5.0)
        }
        .offset(y: -20)
        HStack{
            Image(systemName: "lock")
                .padding()
            SecureField("Password", text: $registerVM.password)
                .cornerRadius(5.0)
        }
        .offset(y: -40)
        HStack{
            Image(systemName: "lock")
                .padding()
            SecureField("Repeat password", text: $registerVM.repeatedPassword)
                .cornerRadius(5.0)
        }
        .offset(y: -60)
        //try to register with given account data and in case of success login with the new registered account
        Button(action: {
            if registerVM.password.count >= 8 && registerVM.password == registerVM.repeatedPassword {
                registerVM.register(id: registerVM.id, name: registerVM.name, password: registerVM.password)
                    if registerVM.isRegistered == true {
                        loginVM.id = registerVM.id
                        loginVM.password = registerVM.password
                        loginVM.login()
                    }
            }
        },
        label: {
            Text("Sign up")
                .frame(width: 244, height: 39)
                .background(Color(hex: 0xC08267))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(.black)
        })
        .offset(y: -60)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
