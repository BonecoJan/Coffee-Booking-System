import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var modelService: ModelService
    @State var showSignUp = false
    
    var body: some View {
        
        Image("loginCoffeeShop")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
        
        VStack {
            if showSignUp == false{
                SignInView().environmentObject(loginVM)
            } else {
                SignUpView().environmentObject(loginVM)
            }
            
            HStack{
                Text(showSignUp ? "No member yet? " : "Already member? ")
                    .foregroundColor(.black)
                Button(action: {
                    showSignUp = !showSignUp
                }, label: {
                    Text(showSignUp ? "Sign in" : "Sign up")
                        .foregroundColor(.black)
                })
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(UIColor.white))
        )
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
    }
}

