import SwiftUI

struct OrderView: View {

    @EnvironmentObject var cartController : CartController
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var homeController : HomeController
    @EnvironmentObject var viewState: ViewState
    
    @State var showAchievementAlert: Bool = false
    @State var achievementType: Int = 0
    
    var body: some View {
        ZStack{
            VStack {
                ScrollView{
                    ForEach(cartController.cart) { product in
                        CartProductView(product: product)
                            .environmentObject(cartController)
                    }
                }.padding()
                VStack{
                    Text("Your Cart is empty... add some coffee to it first!")
                        .padding()
                        .multilineTextAlignment(.center)
                        .opacity(cartController.total > 0.0 ? 0 : 1)
                }
                HStack {
                    Text(cartController.total > 0.0 ? "Total:" : "")
                    Spacer()
                    Text(cartController.total > 0.0 ? String(cartController.total) + (String(cartController.total).countDecimalPlaces() < 2 ? "0" : "") + " €" : "")
                }.padding()
                
                Button(action: {
                    if profileController.profile.balance - cartController.total > 0.0 || profileController.profile.isAdmin{
                        cartController.purchase(profileController: profileController)
                    } else {
                        cartController.hasError = true
                        cartController.error = "Not enough money"
                    }
                }, label: {
                    Text("Pay")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: UInt(COLOR_RED_BROWN)))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .opacity(cartController.total > 0.0 ? 1 : 0)
                })
                .disabled(cartController.total <= 0.0)
                .alert("Error", isPresented: $cartController.hasError, presenting: cartController.error) { detail in
                    Button("Ok", role: .cancel) { }
                } message: { detail in
                    if case let error = detail {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .alert(SUCCESS_PURCHASE, isPresented: $cartController.success) {
                    Button("OK", role: .cancel) {
                        cartController.success = false
                        transactionController.getTransactions(userID: profileController.profile.id)
                        if transactionController.purchaseCount < 4 && transactionController.purchaseCount + cartController.countProductsInCart()  >= 5 && transactionController.purchaseCount + cartController.countProductsInCart()  < 20 {
                            achievementType = 5
                            showAchievementAlert = true
                        } else if transactionController.purchaseCount < 20 && transactionController.purchaseCount + cartController.countProductsInCart()  >= 20 && transactionController.purchaseCount + cartController.countProductsInCart()  < 50 {
                            achievementType = 20
                            showAchievementAlert = true
                        } else if transactionController.purchaseCount < 50 && transactionController.purchaseCount + cartController.countProductsInCart()  >= 50 && transactionController.purchaseCount + cartController.countProductsInCart()  < 100 {
                            achievementType = 50
                            showAchievementAlert = true
                        } else if transactionController.purchaseCount < 100 && transactionController.purchaseCount + cartController.countProductsInCart()  >= 100 {
                            achievementType = 100
                            showAchievementAlert = true
                        }
                        cartController.cart = []
                        cartController.total = 0.0
                    }
                }
                Spacer()
            }
            .blur(radius: showAchievementAlert ? 30 : 0)
            .background(
                RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                    .fill(Color(hex: UInt(COLOR_BACKGROUND)))
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

