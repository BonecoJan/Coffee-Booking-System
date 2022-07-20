import SwiftUI

struct TransactionView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    @ObservedObject var transactionVM = TransactionViewModel()
    
    var body: some View {
        HStack {
            Button(action: {
                viewState.state = 0
            }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .leading)
            })
            Spacer()
            Text("My Bookings")
        }
        VStack {
            //TODO: list all User Transactions
            Button(action:{
                //transactionVM.getTransactions(userID: profilVM.id)
            }, label: {
                Text("print transactions")
            })
            Spacer()
        }.background(
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(Color(hex: 0xCCB9B1))
            )
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}

