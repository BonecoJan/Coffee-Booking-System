import SwiftUI

struct OrderView: View {

    @EnvironmentObject var orderVM : OrderViewModel
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var transactionsVM: TransactionViewModel
    @EnvironmentObject var viewState: ViewState
    
    @State var showAchievementAlert: Bool = false
    @State var achievementType: Int = 0
    
    var body: some View {
        ZStack{
            VStack {
                ScrollView{
                    ForEach(orderVM.cart) { product in
                        CartProductView(product: product)
                            .environmentObject(orderVM)
                    }
                }.padding()
                VStack{
                    Text("Your Cart is empty... add some coffee to it first!")
                        .padding()
                        .multilineTextAlignment(.center)
                        .opacity(orderVM.total > 0.0 ? 0 : 1)
                }
                HStack {
                    Text(orderVM.total > 0.0 ? "Total:" : "")
                    Spacer()
                    Text(orderVM.total > 0.0 ? String(orderVM.total) + (String(orderVM.total).countDecimalPlaces() < 2 ? "0" : "") + " €" : "")
                }.padding()
                
                Button(action: {
                    if profilVM.balance - orderVM.total > 0.0 {
                        orderVM.purchase(profilVM: profilVM)
                    } else {
                        orderVM.hasError = true
                        orderVM.error = "Not enough money"
                    }
                }, label: {
                    Text("Pay")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: 0xC08267))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .opacity(orderVM.total > 0.0 ? 1 : 0)
                })
                .disabled(orderVM.total <= 0.0)
                .alert("Error", isPresented: $orderVM.hasError, presenting: orderVM.error) { detail in
                    Button("Ok", role: .cancel) { }
                } message: { detail in
                    if case let error = detail {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .alert("Purchase processed successfully.", isPresented: $orderVM.success) {
                    Button("OK", role: .cancel) {
                        orderVM.success = false
                        transactionsVM.getTransactions(userID: profilVM.id)
                        if transactionsVM.purchaseCount < 4 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  >= 5 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  < 20 {
                            achievementType = 5
                            showAchievementAlert = true
                        } else if transactionsVM.purchaseCount < 20 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  >= 20 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  < 50 {
                            achievementType = 20
                            showAchievementAlert = true
                        } else if transactionsVM.purchaseCount < 50 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  >= 50 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  < 100 {
                            achievementType = 50
                            showAchievementAlert = true
                        } else if transactionsVM.purchaseCount < 100 && transactionsVM.purchaseCount + orderVM.countProductsInCart()  >= 100 {
                            achievementType = 100
                            showAchievementAlert = true
                        }
                        orderVM.cart = []
                        orderVM.total = 0.0
                    }
                }
                Spacer()
            }
            .blur(radius: showAchievementAlert ? 30 : 0)
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                    .fill(Color(hex: 0xCCB9B1))
                )
            if showAchievementAlert{
                AchievementAlertView(showAchievementAlert: $showAchievementAlert, purchases: achievementType)
                    .environmentObject(viewState)
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}

