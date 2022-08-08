import SwiftUI

struct OrderView: View {

    @EnvironmentObject var shop: Shop
    @EnvironmentObject var orderVM : OrderViewModel
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var transactionsVM: TransactionViewModel
    
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
                    Text(orderVM.total > 0.0 ? String(orderVM.total) + " €" : "")
                }.padding()
                Text((profilVM.balance - orderVM.total < 0.0) ? "not enough money" : "")
                    .foregroundColor(.red)
                    .opacity(orderVM.total > 0.0 ? 1 : 0)
                Button(action: {
                    if profilVM.balance - orderVM.total > 0.0 {
                        orderVM.purchase(profilVM: profilVM)
                    }
                }, label: {
                    Text("Pay")
                        .frame(width: 244, height: 39)
                        .background(Color(hex: 0xC08267))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.black)
                        .opacity(orderVM.total > 0.0 ? 1 : 0)
                }).disabled(orderVM.total <= 0.0)
                Spacer()
            }.background(
                RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20)
                    .fill(Color(hex: 0xCCB9B1))
                )
            if transactionsVM.countPurchases(userID: profilVM.id) == 5 {
                AchievementAlertView(purchases: 5)
            } else if transactionsVM.countPurchases(userID: profilVM.id) == 20 {
                AchievementAlertView(purchases: 20)
            } else if transactionsVM.countPurchases(userID: profilVM.id) == 50 {
                AchievementAlertView(purchases: 50)
            } else if transactionsVM.countPurchases(userID: profilVM.id) == 100 {
                AchievementAlertView(purchases: 100)
            }
        }
    }
}

//Achievement alert
struct AchievementAlertView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var purchases: Int
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack(spacing: 25){
                switch purchases {
                case 5:
                    Image("bronze")
                case 20:
                    Image("silver")
                case 50:
                    Image("gold")
                case 100:
                    Image("trophy")
                default:
                    Image("")
                }
                Text("Congratulations")
                    .font(.title)
                Text("You've bought \(purchases) drinks in our shop!")
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Back")
                })
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 30)
            .background(Color(hex: 0xCCB9B1))
            .cornerRadius(25)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.35))
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}

