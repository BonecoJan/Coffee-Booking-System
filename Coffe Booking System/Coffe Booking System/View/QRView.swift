import CodeScanner
import SwiftUI

struct QRView: View {
    
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    
    var body: some View {
        VStack{
            CodeScannerView(codeTypes: [.qr], simulatedData: "testing", completion: handleScan)
        }
        .alert("Error", isPresented: $orderVM.hasError, presenting: orderVM.error) { detail in
            Button("Ok", role: .cancel) { }
        } message: { detail in
            if case let error = detail {
                Text(error)
            }
        }
        .alert("Purchase processed successfully.", isPresented: $orderVM.success) {
            Button("OK", role: .cancel) {
                orderVM.success = false
            }
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
            print(id)
            confirmPurchase(itemID: id, orderVM: orderVM, profilVM: profilVM)
                
        case .failure(let error):
            orderVM.hasError = true
            orderVM.error = error.localizedDescription
        }
    }
    
    func confirmPurchase(itemID: String, orderVM: OrderViewModel, profilVM: ProfileViewModel) {
        print(itemID)
        let alert = UIAlertController(title: "Confirm your Purchase", message: "Are you sure you want to purchase the item with id \(itemID)?", preferredStyle: .alert)
        
        let purchase = UIAlertAction(title: "Yes", style: .default) { (_) in
            orderVM.purchaseRequest(purchase: OrderViewModel.PurchaseRequest(itemId: itemID, amount: 1), profilVM: profilVM)
        }
        
        let abort = UIAlertAction(title: "Abort", style: .destructive) { (_) in
            //Do nothing
        }
        
        alert.addAction(purchase)
        
        alert.addAction(abort)
        
        //present alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
