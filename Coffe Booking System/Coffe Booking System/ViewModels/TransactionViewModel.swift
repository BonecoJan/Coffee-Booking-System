import Foundation

class TransactionViewModel: ObservableObject {
    
    struct TransactionResponse: Codable {
        var type: String
        var value: Double
        var timestamp : Int
        var itemID: String?
        var itemName: String?
        var amount: Int?
    }
    
    @Published var transactions : [TransactionResponse] = []
    
    func getTransactions() {
        Task {
            do {
                let body: WebService.empty? = nil
                let transactions = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "GET", authReq: false, body: body, responseType: [TransactionResponse].self)
                DispatchQueue.main.async {
                    self.transactions = transactions
                }
            } catch {
                print("failed to get transactions for current user")
            }
        }
    }
}
