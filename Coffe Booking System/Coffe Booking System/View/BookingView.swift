import SwiftUI

struct BookingView: View {
    
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var transactionVM : TransactionViewModel
    
    @State var transactionType : Int = 0
    
    var body: some View {
        VStack{
            VStack{
                HStack {
                    Button(action: {
                        viewState.state = 4
                    }, label: {
                        Image(systemName: "arrow.left")
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
                            .background(Color(hex: 0xC08267))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                    })
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                    Button(action: {
                        transactionType = 1
                    }, label: {
                        Text("Transfers")
                            .frame(width: 100, height: 30)
                            .background(Color(hex: 0xC08267))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.black)
                    })
                    .padding()
                    Button(action: {
                        transactionType = 2
                    }, label: {
                        Text("Fundings")
                            .frame(width: 100, height: 30)
                            .background(Color(hex: 0xC08267))
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
                        ForEach(transactionVM.transactions.reversed()) { transaction in
                            if transactionType == 0 && transaction.type == "purchase" {
                                TransactionView(transaction: transaction)
                                    .environmentObject(transactionVM)
                            } else if transactionType == 1 && transaction.type == "funding" && transaction.value < 0.0 {
                                TransactionView(transaction: transaction)
                                    .environmentObject(transactionVM)
                            } else if transactionType == 2 && transaction.type == "funding" && transaction.value > 0.0 {
                                TransactionView(transaction: transaction)
                                    .environmentObject(transactionVM)
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

