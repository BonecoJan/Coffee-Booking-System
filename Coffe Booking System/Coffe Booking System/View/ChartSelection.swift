//import SwiftUI
//import Charts
//
//struct ChartSelection: View {
//    @EnvironmentObject var transactionController: TransactionController
//    @EnvironmentObject var viewState: ViewState
//
//    @State private var selectedYear: Int = 2022
//    @State private var lineEntries: [ChartDataEntry] = []
//    @State private var selectedItem = ""
//    @State private var selectedGraph: Int = 0
//    
//    @State var leftIndex = 0
//    @State var rightIndex = 0
//    
//    let leftSource = (2000...2030).map { "\($0)" }
//    let rightSource = (1...12).map { "\($0)" }
//    
//    var body: some View {
//        VStack {
//            HStack() {
//                HStack {
//                    Button(action: {
//                        viewState.state = 4
//                    }, label: {
//                        Image(systemName: IMAGE_ARROW_LEFT)
//                            .resizable()
//                            .frame(width: 30, height: 25, alignment: .leading)
//            
//                    })
//                    Text("Statistics")
//                        .multilineTextAlignment(.center)
//                    Spacer()
//                }.padding()
//                Menu("Options") {
//                    Menu("Coffees bought") {
//                        Button("Monthly", action: {
//                            self.transactionController.getMonthlyCoffees(transactionType: TRANSACTION_PURCHASE, year: 2022)
//                            selectedGraph = 21
//                        })
//                        Button("Daily", action: {
//                            self.transactionController.getDailyCoffees(transactionType: TRANSACTION_PURCHASE, year: 2022, month: 7)
//                            selectedGraph = 22
//                        })
//                    }
//                    Menu("Money spent") {
//                        Button("Monthly", action: {
//                            self.transactionController.getMonthlySums(transactionType: TRANSACTION_PURCHASE, year: 2022)
//                            selectedGraph = 11
//                        })
//                        Button("Daily", action: {
//                            self.transactionController.getDailySums(transactionType: TRANSACTION_PURCHASE, year: 2022, month: 7)
//                            selectedGraph = 12
//                        })
//                    }
//                    if selectedGraph != 0 {
//                        Button("Cancel", action: {
//                            selectedGraph = 0
//                        })
//                    }
//
//                }
//            }
//            
//            //TODO: here
//            HStack {
//                VStack{
//                    Text("Year:")
//                    Text("\(self.leftSource[self.leftIndex])")
//                    Picker(selection: $leftIndex, label: Text("Year")) {
//                        ForEach(0..<leftSource.count) {
//                            Text(self.leftSource[$0])
//                        }
//                    }.frame(width: UIScreen.main.bounds.width/2)
//                    
//                    
//                }
//                VStack{
//                    Text("Month:")
//                    Text("\(self.rightSource[self.rightIndex])")
//                    Picker(selection: $rightIndex, label: Text("Month")) {
//                        ForEach(0..<rightSource.count) {
//                            Text(self.rightSource[$0])
//                        }
//                    }.frame(width: UIScreen.main.bounds.width/2)
//                }
//            }
//            
//
//
//            
//            if selectedGraph == 0 {
//                Spacer()
//            } else if selectedGraph == 11 {
//                Chart(entries: transactionController.dataEntriesForYear(TRANSACTION_PURCHASE, Int(self.leftSource[self.leftIndex])!, transactions: transactionController.monthlySums), selectedYear: $selectedYear, selectedItem: $selectedItem)
//                    .frame(height: 500)
//                Text(selectedItem)
//                
//                Text("Test")
//            } else if selectedGraph == 12 {
//                
//                Chart(entries: transactionController.dataEntriesForMonth(TRANSACTION_PURCHASE, 2022, 7, transactions: transactionController.dailySums), selectedYear: $selectedYear, selectedItem: $selectedItem)
//                    .frame(height: 500)
//                Text(selectedItem)
//            } else if selectedGraph == 21 {
//                
//                Chart(entries: transactionController.dataCoffeesForYear(TRANSACTION_PURCHASE, 2022, transactions: transactionController.monthlyCoffees), selectedYear: $selectedYear, selectedItem: $selectedItem)
//                    .frame(height: 500)
//                Text(selectedItem)
//            } else if selectedGraph == 22 {
//                
//                Chart(entries: transactionController.dataCoffeesForMonth(TRANSACTION_PURCHASE, 2022, 7, transactions: transactionController.dailyCoffees), selectedYear: $selectedYear, selectedItem: $selectedItem)
//                    .frame(height: 500)
//                Text(selectedItem)
//            }
//            }
//        }
//    }
//
////struct ChartSelection_Previews: PreviewProvider {
////    static var previews: some View {
////        ChartSelection()
////    }
////}
