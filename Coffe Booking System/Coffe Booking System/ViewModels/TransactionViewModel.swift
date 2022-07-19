import Foundation

class TransactionViewModel: ObservableObject {
    
    struct TransactionResponse: Codable {
        var type: String
        var value: Double
        var timestamp : Int
        var itemID: String
        var itemName: String
        var amount: Int
    }
    
    @Published var transactions : [TransactionResponse] = []
    
    func getTransactions(userID: String) {
        Task {
            do {
                let body: WebService.empty? = nil
                let transactions = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/transactions", reqMethod: "GET", authReq: false, body: body, responseType: [TransactionResponse].self)
                print(transactions)
                DispatchQueue.main.async {
                    self.transactions = transactions
                }
            } catch {
                print("failed to get transactions for current user")
            }
        }
    }
}
