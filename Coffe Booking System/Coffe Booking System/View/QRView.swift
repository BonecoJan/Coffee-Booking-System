import CodeScanner
import SwiftUI

struct QRView: View {
    
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var cartController: CartController
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var homeController : HomeController
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var shop: Shop
    
    @State var showAchievementAlert: Bool = false
    @State var achievementType: Int = 0
    
    var body: some View {
        ZStack{
            VStack{
                //Use CodeScanner Package for Scanning with the camera or picking a code in the simulator
                    CodeScannerView(codeTypes: [.qr], simulatedData: "max.mustermann@gmail.com", completion: handleScan)
                    .alert("Error", isPresented: $cartController.hasError, presenting: cartController.error) { detail in
                        Button("Ok", role: .cancel) { }
                    } message: { detail in
                        if case let error = detail {
                            Text(error)
                        }
                    }
                    .alert(SUCCESS_PURCHASE, isPresented: $cartController.success) {
                        Button("OK", role: .cancel) {
                            cartController.success = false
                            transactionController.getTransactions(shop: shop, userID: shop.profile.id)
                            if transactionController.purchaseCount == 4  {
                                achievementType = 5
                                showAchievementAlert = true
                            } else if transactionController.purchaseCount == 19  {
                                achievementType = 20
                                showAchievementAlert = true
                            } else if transactionController.purchaseCount == 49  {
                                achievementType = 50
                                showAchievementAlert = true
                            } else if transactionController.purchaseCount == 99 {
                                achievementType = 100
                                showAchievementAlert = true
                            }
                            cartController.cart = []
                            cartController.total = 0.0
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
    
    //Handle the result of the scanned code
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            
            //parse id out of the result
            var id: String = ""
            for (i,str) in result.string.enumerated() {
                if i >= 9 && i <= 11 {
                    id.append(str)
                }
            }
            DispatchQueue.main.async {
                if id != "" {
                    //only buy item if the amount is not 0
                    let item = homeController.getItem(shop: shop, itemID: id)
                    if item.amount < 1 {
                        cartController.hasError = true
                        cartController.error = ERROR_ITEM_NOT_AVAILABLE
                    } else {
                        if shop.profile.balance - cartController.total > 0.0 || shop.profile.isAdmin {
                            confirmPurchase(itemID: id, cartController: cartController, profileController: profileController)
                        } else {
                            cartController.hasError = true
                            cartController.error = ERROR_MONEY
                        }
                    }
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                cartController.hasError = true
                cartController.error = error.localizedDescription
            }
        }
        
    }
    
    func confirmPurchase(itemID: String, cartController: CartController, profileController: ProfileController) {
        let alert = UIAlertController(title: "Confirm your Purchase", message: "Are you sure you want to purchase the item with id \(itemID)?", preferredStyle: .alert)
        
        let purchase = UIAlertAction(title: "Yes", style: .default) { (_) in
            cartController.purchaseRequest(shop: shop, purchase: Request.Purchase(itemId: itemID, amount: 1), profileController: profileController)
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
