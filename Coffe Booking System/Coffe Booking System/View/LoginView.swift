import SwiftUI
import JWTDecode

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var modelService: ModelService
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var showSignUp = false
    
    var body: some View {
        
        VStack{
            Image("loginCoffeeShop")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .clipped()
                .padding(.top)
            if showSignUp == false{
                SignInView().environmentObject(loginVM)
                    .environmentObject(profilVM)
                    .environmentObject(transactionVM)
            } else {
                SignUpView().environmentObject(loginVM)
                    .environmentObject(profilVM)
            }
            Spacer()
            HStack{
                Text(showSignUp ? "Already Member? " : "No Member yet? ")
                    .foregroundColor(.black)
                Button(action: {
                    showSignUp = !showSignUp
                }, label: {
                    Text(showSignUp ? "Sign in" : "Sign up")
                })
            }
            .offset(y: -20)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear(perform: checkToken)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ModelService(webService: WebService(authManager: AuthManager())))
            .environmentObject(LoginViewModel())
    }
}

