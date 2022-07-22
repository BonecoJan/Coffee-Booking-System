import Foundation
import Charts

class TransactionViewModel: ObservableObject {
    
    struct TransactionResponse: Codable, Identifiable {
        var id: Int { timestamp }
        
        var type: String
        var value: Double
        var timestamp : Int
        var itemId: String?
        var itemName: String?
        var amount: Int?
    }

    @Published var transactions : [TransactionResponse] = []
    
    @Published var monthlySums : [TransactionSum] = []
    @Published var dailySums : [TransactionSum] = []
    
    @Published var monthlyCoffees : [CoffeeSum] = []
    @Published var dailyCoffees : [CoffeeSum] = []
    
    struct Transaction {
        var year: Int
        var month: Double
        var quantity: Double
    }
    
    struct CoffeeSum {
        var type: String
        var year: Int
        var month: Double
        var day: Double
        var amount: Double
    }
    
    struct TransactionSum {
        var type: String
        var year: Int
        var month: Double
        var day: Double
        var value: Double
    }
    
//    static func dataEntriesForYear(_ year: Int, transactions:[Transaction]) -> [ChartDataEntry] {
//        let yearTransactions = transactions.filter{$0.year == year}
//        return yearTransactions.map{
//            ChartDataEntry(x: $0.month, y: $0.quantity)
//        }
//    }
    func dataCoffeesForMonth(_ type: String, _ year: Int, _ month: Double, transactions:[CoffeeSum]) -> [BarChartDataEntry] {
        let yearValues = self.dailyCoffees.filter{
            $0.year == year
            && $0.month == month
            && $0.type == type}
                return yearValues.map{
                    BarChartDataEntry(x: $0.day, y: $0.amount)
                }
    }

    func dataCoffeesForYear(_ type: String, _ year: Int, transactions:[CoffeeSum]) -> [BarChartDataEntry] {
        let yearValues = self.monthlyCoffees.filter{$0.year == year && $0.type == type}
                return yearValues.map{
                    BarChartDataEntry(x: $0.month, y: $0.amount)
                }
    }
    
    func dataEntriesForMonth(_ type: String, _ year: Int, _ month: Double, transactions:[TransactionSum]) -> [BarChartDataEntry] {
        let yearValues = self.dailySums.filter{
            $0.year == year
            && $0.month == month
            && $0.type == type}
                return yearValues.map{
                    BarChartDataEntry(x: $0.day, y: $0.value)
                }
    }

    func dataEntriesForYear(_ type: String, _ year: Int, transactions:[TransactionSum]) -> [BarChartDataEntry] {
        let yearValues = self.monthlySums.filter{$0.year == year && $0.type == type}
                return yearValues.map{
                    BarChartDataEntry(x: $0.month, y: $0.value)
                }
    }
    
    func getMonthlyCoffees(transactionType: String, year: Int) {
        for month in 1...12 {
            let monthTransactions = self.transactions.filter{getDataFromTimestamp(timestamp: $0.timestamp).month == month
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == transactionType
            }
            
            print(monthTransactions)

            let values = monthTransactions.map( {abs($0.amount!) })
            
            print(values)

            let sum = values.reduce(0, +)
            
            print(sum)
            
            self.monthlyCoffees.append(CoffeeSum(type: transactionType, year: year, month: Double(month), day: 0, amount: Double(sum)))
        }
        print(self.monthlyCoffees)
    }
    
    func getDailyCoffees(transactionType: String, year: Int, month: Int) {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print(numDays)

        for day in 1 ... numDays {
            let dailyTransactions = self.transactions.filter{
                getDataFromTimestamp(timestamp: $0.timestamp).day == day
                && getDataFromTimestamp(timestamp: $0.timestamp).month == month
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == transactionType
            }

            print(dailyTransactions)

            let values = dailyTransactions.map( {abs($0.amount!) })

            print(values)

            let sum = values.reduce(0, +)

            print(sum)

            self.dailyCoffees.append(CoffeeSum(type: transactionType, year: year, month: Double(month), day: Double(day), amount: Double(sum)))
        }
        print(self.dailyCoffees)
    }

    //TODO: alle in aus einem year lesen, dann
    func getMonthlySums(transactionType: String, year: Int) {
        for month in 1...12 {
            let monthTransactions = self.transactions.filter{getDataFromTimestamp(timestamp: $0.timestamp).month == month
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == transactionType
            }
            
            print(monthTransactions)

            let values = monthTransactions.map( {abs($0.value) })
            
            print(values)

            let sum = values.reduce(0, +)
            
            print(sum)
            
            self.monthlySums.append(TransactionSum(type: transactionType, year: year, month: Double(month), day: 0, value: sum))
        }
        print(self.monthlySums)
    }
    
    func getDailySums(transactionType: String, year: Int, month: Int) {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print(numDays)

        for day in 1 ... numDays {
            let dailyTransactions = self.transactions.filter{
                getDataFromTimestamp(timestamp: $0.timestamp).day == day
                && getDataFromTimestamp(timestamp: $0.timestamp).month == month
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == transactionType
            }

            print(dailyTransactions)

            let values = dailyTransactions.map( {abs($0.value) })

            print(values)

            let sum = values.reduce(0, +)

            print(sum)

            self.dailySums.append(TransactionSum(type: transactionType, year: year, month: Double(month), day: Double(day), value: sum))
        }
        print(self.dailySums)
    }

    func getDataFromTimestamp(timestamp: Int) -> DateComponents {
        let date = Date(timeIntervalSince1970: Double(timestamp)/1000)
        let calendarDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        return calendarDate
    }
    
    static var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    static var allTransactions:[Transaction] {
        [
        Transaction(year: 2019, month: 0, quantity: 23),
        Transaction(year: 2019, month: 1, quantity: 56),
        Transaction(year: 2019, month: 2, quantity: 87),
        Transaction(year: 2019, month: 3, quantity: 15),
        Transaction(year: 2019, month: 4, quantity: 20),
        Transaction(year: 2019, month: 5, quantity: 15),
        Transaction(year: 2019, month: 6, quantity: 56),
        Transaction(year: 2019, month: 7, quantity: 40),
        Transaction(year: 2019, month: 8, quantity: 54),
        Transaction(year: 2019, month: 9, quantity: 81),
        Transaction(year: 2019, month: 10, quantity: 56),
        Transaction(year: 2019, month: 11, quantity: 25),
        Transaction(year: 2019, month: 12, quantity: 35)
        ]
    }
    
    
    
    func getTransactions(userID: String) {
        Task {
            do {
                let body: WebService.empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/transactions", reqMethod: "GET", authReq: true, body: body, responseType: [TransactionResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.transactions = response
                }
            } catch {
                print("failed to get transactions from server")
            }
        }
     }
}
