import Foundation
import SwiftUICharts

class TransactionController: ObservableObject {

    //This Integer is only used for recognizing if an achievement is earned
    @Published var purchaseCount: Int = 0
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    func countPurchases(shop: Shop) -> Int {
        var count : Int = 0
        for transaction in shop.transactions {
            if transaction.type == "purchase" {
                count += transaction.amount!
            }
        }
        return count
    }
    
    //get datapoints for total bought items
    func dataBoughtItems(shop: Shop) -> [BarChartDataPoint] {
        var dataEntries: [BarChartDataPoint] = []
        
            let transactions = shop.transactions.filter{
                $0.type == "purchase"
            }

        
        // Count amount of purchased items
        let mappedItems = transactions.map { ($0.itemName, $0.amount ?? 0) }
        
        // Add counts
        let counts = Dictionary(mappedItems, uniquingKeysWith: +)
        
        let sortedByValueDictionary = counts.sorted { $0.1 > $1.1 }

        
        for (itemKey, itemCount) in sortedByValueDictionary {
            dataEntries.append(BarChartDataPoint(value: Double(itemCount), xAxisLabel: itemKey))
        }
        
        return dataEntries
    }
    
    //get datapoints for monthl
    func dataForMonth(shop: Shop, _ type: String, _ year: Int, _ month: Int) -> [BarChartDataPoint] {
        var dataEntries: [BarChartDataPoint] = []
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        for day in 1 ... numDays {
            let transactions = shop.transactions.filter{
                getDataFromTimestamp(timestamp: $0.timestamp).day == day
                && getDataFromTimestamp(timestamp: $0.timestamp).month == month
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == "purchase"
            }
            
            switch type {
            case "value":
                let values = transactions.map( {abs($0.value) })
                let sum = values.reduce(0, +)
                
                dataEntries.append(BarChartDataPoint(value: Double(sum), xAxisLabel: String(day)))
                break
            case "amount":
                let values = transactions.map( {abs($0.amount ?? 0) })
                let sum = values.reduce(0, +)
                
                dataEntries.append(BarChartDataPoint(value: Double(sum), xAxisLabel: String(day)))
                break
            default:
                break
            }

        }
        
        return dataEntries
    }
    
    //get data
    func dataForYear(shop: Shop, _ type: String, _ year: Int) -> [BarChartDataPoint] {
        var dataEntries: [BarChartDataPoint] = []
        
        for month in 1...12 {
            let transactions = shop.transactions.filter{getDataFromTimestamp(timestamp: $0.timestamp).month == month
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == "purchase"
            }

            switch type {
            case "value":
                let values = transactions.map( {abs($0.value) })
                let sum = values.reduce(0, +)
                
                dataEntries.append(BarChartDataPoint(value: Double(sum), xAxisLabel: DateFormatter().monthSymbols[month - 1]))
                break
            case "amount":
                let values = transactions.map( {abs($0.amount ?? 0) })
                let sum = values.reduce(0, +)
                
                dataEntries.append(BarChartDataPoint(value: Double(sum), xAxisLabel: DateFormatter().monthSymbols[month - 1]))
                break
            default:
                break
            }

        }
        
        return dataEntries
    }
    
    func dataForWeek(shop: Shop, _ type: String, _ year: Int, _ week: Int) -> [BarChartDataPoint] {
        var dataEntries: [BarChartDataPoint] = []

        for day in 1 ... 7 {
            let transactions = shop.transactions.filter{
                getDataFromTimestamp(timestamp: $0.timestamp).weekday == day
                && getDataFromTimestamp(timestamp: $0.timestamp).weekOfYear == week
                && getDataFromTimestamp(timestamp: $0.timestamp).year == year
                && $0.type == "purchase"
            }
            
            switch type {
            case "value":
                let values = transactions.map( {abs($0.value) })
                let sum = values.reduce(0, +)
                
                dataEntries.append(BarChartDataPoint(value: Double(sum), xAxisLabel: DateFormatter().weekdaySymbols[day - 1]))
                break
            case "amount":
                let values = transactions.map( {abs($0.amount ?? 0) })
                let sum = values.reduce(0, +)
                
                dataEntries.append(BarChartDataPoint(value: Double(sum), xAxisLabel: DateFormatter().weekdaySymbols[day - 1]))
                break
            default:
                break
            }

        }

        return dataEntries
    }

    //decode the Integer timestamp that is returned by the server into a CalenderDate
    func getDataFromTimestamp(timestamp: Int) -> DateComponents {
        let date = Date(timeIntervalSince1970: Double(timestamp)/1000)

        let calendarDate = Calendar(identifier: .iso8601).dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: date)

        return calendarDate
    }
    
    static var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    func getTransactions(shop: Shop, userID: String) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/transactions", reqMethod: GET, authReq: true, body: body, responseType: [Response.Transaction].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    shop.transactions = []
                    for transaction in response {
                        shop.transactions.append(Transaction(transaction: transaction))
                    }
                    self.purchaseCount = self.countPurchases(shop: shop)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
                print("failed to get transactions from server")
            }
        }
     }
}
