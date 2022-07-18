import SwiftUI

struct ProfilView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    @State var userName: String = ""
    @State var userID: String = ""
    
    var body: some View {
        VStack {
            Text(profileVM.isAdmin ? "Your Profile(Admin)" : "Your Profile")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            Text("Name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person")
                    .padding()
                Text(profileVM.name)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {/*TODO: Username Change*/}, label: {
                    Image(systemName: "square.and.pencil")
                        .padding()
                })
            }.offset(y: -20)
            Text("ID")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack{
                Image(systemName: "person.text.rectangle")
                    .padding()
                Text(profileVM.id)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -20)
            Text("Balance: " + String(profileVM.balance) + " €")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            //this Button is hidden if the user is not an admin
            if self.$profileVM.isAdmin.wrappedValue {
                Button (action: {
                    //go to Admin Menue
                    viewState.state = 1
                }, label: {
                    Text("Admin Menue")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: 0xD9D9D9))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                })
            }
            Button(action: {
                //TODO: Password Change
            }, label: {
                Text("Change password")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            Button(action: {
                loginVM.logout()
            }, label: {
                Text("Logout")
                    .frame(width: 244, height: 39)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            Spacer()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
