import SwiftUI

struct BookingView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var transactionController : TransactionController
    
    @State var transactionType : Int = 0
    
    var body: some View {
        VStack{
            VStack{
                HStack {
                    Button(action: {
                        viewState.state = 4
                    }, label: {
                        Image(systemName: IMAGE_ARROW_LEFT)
                            .resizable()
                            .frame(width: 30, height: 25, alignment: .leading)
                    })
                    Text("My Transactions")
                        .font(.title)
                        .padding()
                    Spacer()
                }.padding()
                HStack(alignment: .center){
                    Button(action: {
                        transactionType = 0
                    }, label: {
                        Text("Purchases")
                            .frame(width: 100, height: 30)
                            .background(Color(hex: UInt(COLOR_RED_BROWN)))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                    })
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                    Button(action: {
                        transactionType = 1
                    }, label: {
                        Text("Money Sent")
                            .frame(width: 100, height: 30)
                            .background(Color(hex: UInt(COLOR_RED_BROWN)))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                    })
                    .padding()
                    Button(action: {
                        transactionType = 2
                    }, label: {
                        Text("Charges")
                            .frame(width: 100, height: 30)
                            .background(Color(hex: UInt(COLOR_RED_BROWN)))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                    })
                    .padding(.top)
                    .padding(.bottom)
                    .padding(.trailing)
                }
            }
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack{
                        ForEach(transactionController.transactions.reversed()) { transaction in
                            if transactionType == 0 && transaction.type == TRANSACTION_PURCHASE {
                                TransactionView(transaction: transaction)
                                    .environmentObject(transactionController)
                            } else if transactionType == 1 && transaction.type == TRANSACTION_FUNDING && transaction.value < 0.0 {
                                TransactionView(transaction: transaction)
                                    .environmentObject(transactionController)
                            } else if transactionType == 2 && (transaction.type == TRANSACTION_FUNDING || transaction.type == TRANSACTION_REFUND) && transaction.value > 0.0 {
                                TransactionView(transaction: transaction)
                                    .environmentObject(transactionController)
                            }
                        }
                    }
                })
                .padding()
                Spacer()
            }
        }
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView()
    }
}

