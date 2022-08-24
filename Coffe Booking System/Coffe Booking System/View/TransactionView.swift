import SwiftUI

struct TransactionView: View {
    
    var transaction: TransactionViewModel.TransactionResponse
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                switch transaction.type {
                case "purchase":
                    Text("Purchase: ")
                        .multilineTextAlignment(.leading)
                case "funding":
                    if transaction.value < 0.0 {
                        Text("Money sent: ")
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Funding: ")
                            .multilineTextAlignment(.leading)
                    }
                case "refund":
                    Text("Pruchase refund: ")
                        .multilineTextAlignment(.leading)
                default:
                    Text("")
                }
                Spacer()
                Text(String(timestampToString(timestamp: transaction.timestamp)))
            }
            if transaction.type == "purchase" || transaction.type == "refund" {
                Text("Item ID: " + transaction.itemId!)
                Text("Item Name: " + transaction.itemName!)
                Text("Amount: " + String(transaction.amount!))
            }
            Text((transaction.value < 0.0 ?  String(-transaction.value) : String(transaction.value)) + (String(transaction.value).countDecimalPlaces() < 2 ? "0" : "") + " €")
                .foregroundColor(transaction.value < 0.0 ? .red : .green)
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
