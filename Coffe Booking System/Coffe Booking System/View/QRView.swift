import CodeScanner
import SwiftUI

struct QRView: View {
    
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    
    var body: some View {
        VStack{
            CodeScannerView(codeTypes: [.qr], simulatedData: "testing@gmx.de", completion: handleScan)
        }
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
            orderVM.purchaseRequest(purchase: OrderViewModel.PurchaseRequest(itemId: id, amount: 1), profilVM: profilVM)
                
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
