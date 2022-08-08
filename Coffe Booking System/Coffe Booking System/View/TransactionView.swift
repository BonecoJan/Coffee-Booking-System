import SwiftUI

struct TransactionView: View {
    
    var transaction: TransactionViewModel.TransactionResponse
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Transaction on: ")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(String(timestampToString(timestamp: transaction.timestamp)))
            }
            if transaction.type == "purchase" {
                Text("Item ID: " + transaction.itemId!)
                Text("Item Name: " + transaction.itemName!)
                Text("Amount: " + String(transaction.amount!))
            }
            Text(transaction.value < 0.0 ? "Value: " + String(-transaction.value) : String(transaction.value))
        }
        .padding()
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                .fill(Color(hex: 0xD9D9D9))
            )
    }
    
    func timestampToString(timestamp: Int) -> String {
        let date = transactionVM.getDataFromTimestamp(timestamp: timestamp)
        let str = TransactionViewModel.months[date.month! - 1] + " " + String(date.day!) + ", " + String(date.year!)
        return str
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: TransactionViewModel.TransactionResponse(type: "", value: 0.0, timestamp: 0))
    }
}
