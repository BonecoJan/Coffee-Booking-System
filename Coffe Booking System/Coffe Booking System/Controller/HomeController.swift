import Foundation

class HomeController: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    //this function is only used during a qrcode purchase to find the amount of an item where we only know the ID
    func getItem(shop: Shop, itemID: String) -> Item {
        for item in shop.items {
            if item.id == itemID {
                return item
            }
        }
        return Item(id: ERROR_NO_ITEM, name: ERROR_NO_ITEM, amount: 0, price: 0.0)
    }
    
    func getProducts(shop: Shop) {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let itemResponse = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: GET, authReq: false, body: body, responseType: [Response.Item].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    shop.items = []
                    for item in itemResponse {
                        shop.items.append(Item(item: item))
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
