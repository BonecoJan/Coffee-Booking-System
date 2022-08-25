import SwiftUI

struct UserViewObj: View {

    var user: UserViewModel.User
    @State var amount: String = ""
    @State var showPopUp: Bool = false
    @State var notEnoughMoney: Bool = false
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                VStack(alignment: .leading){
                    if user.image.encodedImage == "empty" {
                        Image("noProfilPicture")
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
                    Image(systemName: "person.text.rectangle")
                    Text("ID")
                        .font(.footnote)
                }
                
                Text(user.userResponse.id)
                    .padding()
            }
        }
        
        .alert("Error", isPresented: $profilVM.hasError, presenting: profilVM.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
            }
        }
        .alert("Funding processed successfully.", isPresented: $profilVM.success) {
            Button("OK", role: .cancel) {
                profilVM.success = false
            }
        }
        .alert("Not enough money.", isPresented: $notEnoughMoney) {
            Button("OK", role: .cancel) {
                notEnoughMoney = false
            }
        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
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
                profilVM.hasError = true
                profilVM.error = "invalid format given"
            } else {
                if profilVM.balance - Double(amount)! >= 0.0 {
                    profilVM.sendMoney(amount: Double(amount)!, recipientId: user.userResponse.id)
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
