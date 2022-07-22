import CodeScanner
import Foundation

class QRViewModel: ObservableObject {
    
    struct ScanningResponse: Codable {
        let id: String
        let name: String
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            var id: String = ""
            for (i,str) in result.string.enumerated() {
                if i >= 9 && i <= 11 {
                    id.append(str)
                }
            }
            print(id)
            //orderVM.purchaseRequest(purchase: OrderViewModel.PurchaseRequest(itemId: response.id, amount: 1), profilVM: profilVM)
                
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
}
