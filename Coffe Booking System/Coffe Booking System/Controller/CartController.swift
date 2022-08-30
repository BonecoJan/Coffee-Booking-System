import Foundation

class CartController: ObservableObject {
    
    @Published var cart: [Item]
    @Published var total: Double
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var success: Bool = false
    @Published var error: String = ""
    
    init() {
        cart = []
        total = 0.0
    }
    
    func countProductsInCart() -> Int {
        var counter: Int = 0
        for product in cart {
            counter += product.amount
        }
        return counter
    }
    
    func addProductToCart(product: Response.Item) {
        total = (total + product.price).rounded(toPlaces: 2)
        for item in cart {
            if item.id == product.id {
                item.amount = item.amount + 1
                return
            }
        }
        cart.append(Item(id: product.id, name: product.name, amount: 1, price: product.price))
    }
    
    func deleteProductFromCart(product: Response.Item) {
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
    
    //Send purchase request to all products in cart
    func purchase(shop: Shop, profileController: ProfileController) {
        for product in cart {
            purchaseRequest(shop: shop, purchase: Request.Purchase(itemId: product.id, amount: product.amount), profileController: profileController)
        }
    }
    
    func purchaseRequest(shop: Shop, purchase: Request.Purchase, profileController: ProfileController) {
        self.isLoading = true
        Task {
            do {
                let response = try await WebService(authManager: AuthManager()).request(reqUrl: "users/" + shop.profile.id + "/purchases", reqMethod: POST, authReq: true, body: purchase, responseType: NoJSON.self, unknownType: false)
                if response.response == SUCCESS_PURCHASE {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasError = false
                        self.success = true
                        profileController.loadUserData(shop: shop)
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
