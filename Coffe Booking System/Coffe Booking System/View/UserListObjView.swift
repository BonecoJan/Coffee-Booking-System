import SwiftUI

struct UserListObjView: View {

    var user: User
    @State var amount: String = ""
    @State var showPopUp: Bool = false
    @State var notEnoughMoney: Bool = false
    @EnvironmentObject var userController : UserController
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var shop: Shop
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                VStack(alignment: .leading){
                    if user.image.encodedImage == NO_PROFILE_IMAGE {
                        Image(IMAGE_NO_PROFILE_IMAGE)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .clipped()
                    } else {
                        Image(base64String: user.image.encodedImage!)!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .clipped()
                    }
                }
                Text(user.userResponse.name)
                    .padding()
                Spacer()
                Button(action: {
                    sendMoneyPopUp()
                }, label: {
                    Text("Send Money")
                })
                
            }
            HStack{
                VStack{
                    Image(systemName: IMAGE_ID)
                    Text("ID")
                        .font(.footnote)
                }
                
                Text(user.userResponse.id)
                    .padding()
            }
        }
        
        .alert("Error", isPresented: $profileController.hasError, presenting: profileController.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
            }
        }
        .alert(SUCCESS_FUNDING, isPresented: $profileController.success) {
            Button("OK", role: .cancel) {
                profileController.success = false
            }
        }
        .alert(ERROR_MONEY, isPresented: $notEnoughMoney) {
            Button("OK", role: .cancel) {
                notEnoughMoney = false
            }
        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: UInt(COLOR_LIGHT_GRAY)))
            )
    }
    
    func sendMoneyPopUp() {
        let alert = UIAlertController(title: "Send Money", message: "Enter the amount to be sent", preferredStyle: .alert)
        
        alert.addTextField{ (amount) in
            amount.placeholder = "amount"
        }
        
        let change = UIAlertAction(title: "Send", style: .default) { (_) in
            amount = alert.textFields![0].text!
            if Double(amount) == nil {
                profileController.hasError = true
                profileController.error = ERROR_FORMAT
            } else {
                if shop.profile.balance - Double(amount)! >= 0.0 {
                    profileController.sendMoney(shop: shop, amount: Double(amount)!, recipientId: user.userResponse.id)
                } else {
                    notEnoughMoney = true
                }
            }
            
        }
        
        let abort = UIAlertAction(title: "Abort", style: .destructive) { (_) in
            notEnoughMoney = false
        }
        
        alert.addAction(change)
        
        alert.addAction(abort)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
}
