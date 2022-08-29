import Foundation

class HomeController: ObservableObject {
    
    @Published var products: [Item] = []
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    init() {
        getProducts()
    }
    
    func getItem(itemID: String) -> Item {
        for product in products {
            if product.id == itemID {
                return product
            }
        }
        return Item(id: ERROR_NO_ITEM, name: ERROR_NO_ITEM, amount: 0, price: 0.0)
    }
    
    func getProducts() {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let itemResponse = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: GET, authReq: false, body: body, responseType: [Response.Item].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    self.products = []
                    for item in itemResponse {
                        self.products.append(Item(item: item))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = true
                    self.error = error.localizedDescription
                }
                print("failed to get items from server")
            }
        }
    }
}
