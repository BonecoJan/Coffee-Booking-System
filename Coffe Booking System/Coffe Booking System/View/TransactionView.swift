import SwiftUI

struct TransactionView: View {
    
    var transaction: TransactionViewModel.TransactionResponse
    @EnvironmentObject var transactionVM: TransactionViewModel
    let formatter = DateComponentsFormatter()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Transaction timestamp: ")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(String(transaction.timestamp))
            }
            Text(transaction.type == "purchase" ? ("Item ID: " + transaction.itemId!) : "")
            Text(transaction.type == "purchase" ? ("Item Name: " + transaction.itemName!) : "")
            Text(transaction.type == "purchase" ? ("Amount: " + String(transaction.amount!)) : "")
            Text(transaction.value < 0.0 ? "Value: " + String(-transaction.value) : String(transaction.value))

        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
            )
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: TransactionViewModel.TransactionResponse(type: "", value: 0.0, timestamp: 0))
    }
}
