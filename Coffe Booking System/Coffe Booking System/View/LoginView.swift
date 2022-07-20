import SwiftUI
import JWTDecode

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var modelService: ModelService
    @EnvironmentObject var profilVM: ProfileViewModel
    @State var showSignUp = false
    
    var body: some View {
        
        Image("loginCoffeeShop")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
            .ignoresSafeArea()
        
        VStack {
            if showSignUp == false{
                SignInView().environmentObject(loginVM)
                    .environmentObject(profilVM)
            } else {
                SignUpView().environmentObject(loginVM)
                    .environmentObject(profilVM)
            }
            
            HStack{
                Text(showSignUp ? "Already Member? " : "No Member yet? ")
                    .foregroundColor(.black)
                Button(action: {
                    showSignUp = !showSignUp
                }, label: {
                    Text(showSignUp ? "Sign in" : "Sign up")
                        .foregroundColor(.black)
                })
            }
            .offset(y: -20)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
        )
        .onAppear(perform: checkToken)
        .ignoresSafeArea()
    }
    
    func checkToken() {
        
        if let tokenID = KeychainWrapper.standard.get(service: "access-token", account: "Coffe-Booking-System")
        {
            let token = String(data: tokenID, encoding: .utf8)!
        do {
            let jwt = try decode(jwt: token)
            if !(jwt.expired) {
                loginVM.password = String(data: KeychainWrapper.standard.get(service: "password", account: "Coffe-Booking-System")!, encoding: .utf8)!
                loginVM.id = jwt.claim(name: "id").string!
                loginVM.login(profilVM: profilVM)
            }
            else {
                return
            }
        } catch let error {
            print(error.localizedDescription)
        }
        } else {
            return
        }
    }
}

struct ForgotPasswordView: View {
    var body: some View {
        Text("Forgot password")
    }
}

//Preview this View
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ModelService(webService: WebService(authManager: AuthManager())))
            .environmentObject(LoginViewModel())
    }
}

