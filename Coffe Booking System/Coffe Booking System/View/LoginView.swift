import SwiftUI
import JWTDecode

struct LoginView: View {
    
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var homeController: HomeController
    
    @State var showSignUp = false
    
    var body: some View {
        
        VStack{
            Image(IMAGE_LOGIN)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .clipped()
                .padding(.top)
            if showSignUp == false{
                SignInView().environmentObject(loginController)
                    .environmentObject(profileController)
                    .environmentObject(transactionController)
            } else {
                SignUpView().environmentObject(loginController)
                    .environmentObject(profileController)
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
        
        if let tokenID = KeychainWrapper.standard.get(service: SERVICE_TOKEN, account: ACCOUNT)
        {
            let token = String(data: tokenID, encoding: .utf8)!
        do {
            let jwt = try decode(jwt: token)
            if !(jwt.expired) {
                loginController.password = String(data: KeychainWrapper.standard.get(service: SERVICE_PASSWORD, account: ACCOUNT)!, encoding: .utf8)!
                loginController.id = jwt.claim(name: "id").string!
                loginController.login(profileController: profileController)
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginController())
    }
}

