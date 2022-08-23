import SwiftUI

struct AchievementView: View {
    
    @EnvironmentObject var viewState : ViewState
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var profilVM: ProfileViewModel
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    viewState.state = 4
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 25, height: 20, alignment: .leading)
                }).padding()
                Text("Your Achievements")
                    .padding()
                    .font(.title.weight(.bold))
                Spacer()
            }
            ScrollView(){
                
                VStack{
                    Text("Coffee bought: ")
                        .font(.title)
                        .padding()
                        .multilineTextAlignment(.leading)
                    HStack{
                        Image(transactionVM.purchaseCount < 5 ? "grayMedal" : "bronze")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipped()
                        Spacer()
                        Text(transactionVM.purchaseCount < 5 ? "Buy 5 coffees" : "Bought 5 coffees")
                            .padding()
                    }.padding()
                    .background(
                            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                                .fill(transactionVM.purchaseCount < 5 ? Color(hex: 0xD9D9D9) : Color(hex: 0xC08267))
                            )
                    HStack{
                        Image(transactionVM.purchaseCount < 20 ? "grayMedal" : "silver")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipped()
                        Spacer()
                        Text(transactionVM.purchaseCount < 5 ? "Buy 20 coffees" : "Bought 20 coffees")
                            .padding()
                    }.padding()
                    .background(
                            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                                .fill(transactionVM.purchaseCount < 20 ? Color(hex: 0xD9D9D9) : Color(hex: 0xC08267))
                            )
                    HStack{
                        Image(transactionVM.purchaseCount < 50 ? "grayMedal" : "gold")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipped()
                        Spacer()
                        Text(transactionVM.purchaseCount < 50 ? "Buy 50 coffees" : "Bought 50 coffees")
                            .padding()
                    }.padding()
                    .background(
                            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                                .fill(transactionVM.purchaseCount < 50 ? Color(hex: 0xD9D9D9) : Color(hex: 0xC08267))
                            )
                    HStack{
                        Image(transactionVM.purchaseCount < 100 ? "grayTrophy" : "trophy")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipped()
                        Spacer()
                        Text(transactionVM.purchaseCount < 100 ? "Buy 100 coffees" : "Bought 100 coffees")
                            .padding()
                    }.padding()
                    .background(
                        RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
                            .fill(Color(hex: 0xD9D9D9))
                        )
                }
            }.padding()
        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
    }
}
