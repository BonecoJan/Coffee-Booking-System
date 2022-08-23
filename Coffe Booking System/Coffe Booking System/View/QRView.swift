import CodeScanner
import SwiftUI

struct QRView: View {
    
    @EnvironmentObject var profilVM: ProfileViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var viewState: ViewState
    
    @State var showAchievementAlert: Bool = false
    @State var achievementType: Int = 0
    
    var body: some View {
        ZStack{
            VStack{
                CodeScannerView(codeTypes: [.qr], simulatedData: "testing", completion: handleScan)
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
                            transactionVM.getTransactions(userID: profilVM.id)
                            if transactionVM.purchaseCount < 200  {
                                achievementType = 5
                                showAchievementAlert = true
                            } else if transactionVM.purchaseCount == 19  {
                                achievementType = 20
                                showAchievementAlert = true
                            } else if transactionVM.purchaseCount == 49  {
                                achievementType = 50
                                showAchievementAlert = true
                            } else if transactionVM.purchaseCount == 99 {
                                achievementType = 100
                                showAchievementAlert = true
                            }
                            orderVM.cart = []
                        }
                    }
            }
            .blur(radius: showAchievementAlert ? 30 : 0)
            
            if showAchievementAlert{
                AchievementAlertView(showAchievementAlert: $showAchievementAlert, purchases: achievementType)
                    .environmentObject(viewState)
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
            DispatchQueue.main.async {
                if id != "" {
                    confirmPurchase(itemID: id, orderVM: orderVM, profilVM: profilVM)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                orderVM.hasError = true
                orderVM.error = error.localizedDescription
            }
        }
    }
    
    func confirmPurchase(itemID: String, orderVM: OrderViewModel, profilVM: ProfileViewModel) {
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
