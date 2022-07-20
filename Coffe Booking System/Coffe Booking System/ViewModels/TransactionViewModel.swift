import Foundation

class TransactionViewModel: ObservableObject {
    
    struct PurchaseResponse: Codable {
        var value: Double
        var timestamp : Int
        var itemID: String
        var itemName: String
        var amount: Int
    }
    
    struct FundingResponse: Codable {
        var value: Double
        var timestamp: Int
    }

    @Published var purchases : [PurchaseResponse] = []
    @Published var fundings : [FundingResponse] = []
    
    //func getTransactions(userID: String) {
    //    Task {
    //        do {
    //            let body: WebService.empty? = nil
    //            let users = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + userID + "/transactions", reqMethod: "GET", authReq: false, body: body, responseType: NSObject.self, unknownType: true)
     //       } catch {
     //           print("failed to get users from server")
     //       }
     //   }
     //}
}
