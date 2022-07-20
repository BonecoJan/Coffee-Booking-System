import Foundation

class TransactionViewModel: ObservableObject {
    
    struct TransactionResponse: Codable {
        var type: String
        var value: Double
        var timestamp : Int
        var itemId: String?
        var itemName: String?
        var amount: Int?
    }

    @Published var transactions : [TransactionResponse] = []
    
    func getTransactions(userID: String) {
        Task {
            do {
                let body: WebService.empty? = nil
                let purchases = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/transactions", reqMethod: "GET", authReq: true, body: body, responseType: [TransactionResponse].self, unknownType: false)
            } catch {
                print("failed to get transactions from server")
            }
        }
     }
}
