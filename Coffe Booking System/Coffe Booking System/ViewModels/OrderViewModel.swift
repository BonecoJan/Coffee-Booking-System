import Foundation

class OrderViewModel: ObservableObject {
    
    struct PurchaseRequest: Codable {
        var itemId: String
        var amount: Int
    }
    
    class ProductInCart: ObservableObject, Identifiable {
        var id: String
        var name: String
        var amount: Int
        var price: Double
        
        init(id: String, name: String, amount: Int, price: Double) {
            self.id = id
            self.name = name
            self.amount = amount
            self.price = price
        }
    }
    
    @Published var cart: [ProductInCart]
    @Published var total: Double
    
    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var error: String = ""
    
    init() {
        cart = []
        total = 0.0
    }
    
    func addProductToCart(product: AdminViewModel.ItemResponse) {
        total = (total + product.price).rounded(toPlaces: 2)
        for item in cart {
            if item.id == product.id {
                item.amount = item.amount + 1
                return
            }
        }
        cart.append(ProductInCart(id: product.id, name: product.name, amount: 1, price: product.price))
    }
    
    func deleteProductFromCart(product: AdminViewModel.ItemResponse) {
        total = (total - product.price).rounded(toPlaces: 2)
        var deleteAt: Int = 0
        for (index, item) in cart.enumerated() {
            if item.id == product.id {
                if item.amount > 1 {
                    item.amount = item.amount - 1
                    return
                } else {
                    deleteAt = index
                }
            }
        }
        cart.remove(at: deleteAt)
    }
    
    //Send purchase request to all products in Cart
    func purchase(profilVM: ProfileViewModel) {
        for product in cart {
            purchaseRequest(purchase: PurchaseRequest(itemId: product.id, amount: product.amount), profilVM: profilVM)
        }
        total = 0.0
        cart = []
    }
    
    func purchaseRequest(purchase: PurchaseRequest, profilVM: ProfileViewModel) {
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + profilVM.id + "/purchases", reqMethod: "POST", authReq: true, body: purchase, responseType: WebService.ChangeResponse.self, unknownType: false)
                if response.response == "Purchase processed successfully." {
                    DispatchQueue.main.async {
                        self.hasError = false
                        self.success = true
                        profilVM.loadUserData()
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
