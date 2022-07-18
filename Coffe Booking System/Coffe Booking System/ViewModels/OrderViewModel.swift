import Foundation

class OrderViewModel: ObservableObject {
    
    struct PurchaseRequest: Codable {
        var id: String
        var amount: Int
    }
    
    struct ProductInCart: Codable, Identifiable {
        var id: String
        var name: String
        var amount: Int
        var price: Double
    }
    
    @Published var cart: [ProductInCart]
    @Published var total: Double
    
    init() {
        cart = []
        total = 0.0
    }
    
    func addProductToCart(product: AdminViewModel.ItemResponse) {
        //TODO: Check if user has enough credits for product
        total = total + product.price
        for var item in cart {
            if item.id == product.id {
                item.amount = item.amount + 1
                return
            }
        }
        cart.append(ProductInCart(id: product.id, name: product.name, amount: 1, price: product.price))
    }
    
    //Send purchase request to all products in Cart
    func purchase(profilVM: ProfileViewModel) {
        for product in cart {
            purchaseRequest(purchase: PurchaseRequest(id: product.id, amount: product.amount), profilVM: profilVM)
        }
        total = 0.0
        cart = []
    }
    
    func purchaseRequest(purchase: PurchaseRequest, profilVM: ProfileViewModel) {
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + purchase.id + "/purchases", reqMethod: "POST", authReq: true, body: purchase, responseType: WebService.ChangeResponse.self)
                if response.response == "Purchase processed successfully." {
                    DispatchQueue.main.async {
                        profilVM.loadUserData()
                    }
                }
            } catch {
                print("failed to purchase item with id " + purchase.id)
            }
        }
    }
}
