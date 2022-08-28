import SwiftUI

struct AchievementAlertView: View {
    
    @Binding var showAchievementAlert: Bool
    @EnvironmentObject var viewState: ViewState
    var purchases: Int
    
    var body: some View {
            VStack {
                switch purchases {
                case 5:
                    Image("bronze")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top)
                case 20:
                    Image("silver")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top)
                case 50:
                    Image("gold")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top)
                case 100:
                    Image("trophy")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top)
                default:
                    Image("")
                }
                Spacer()
                Text("Congratulations")
                    .font(.title)
                    .padding(.top)
                Text("You've bought \(purchases) drinks in our shop!")
                Spacer()
                Divider()
                HStack {
                    Button(action: {
                        showAchievementAlert = false
                        viewState.state = 7
                    }, label: {
                        Text("Achievements")
                            .padding()
                    }).frame(width: UIScreen.main.bounds.width/2 - 25, height: 40)
                    Button(action: {
                        showAchievementAlert = false
                    }, label: {
                        Text("Back")
                            .padding()
                    }).frame(width: UIScreen.main.bounds.width/2 - 25, height: 40)
                }
            }.frame(width: UIScreen.main.bounds.width-50, height: 300)
            .background(Color(hex: UInt(COLOR_LIGHT_GRAY)).opacity(0.7))
            .cornerRadius(20)
            .clipped()
    }

}
