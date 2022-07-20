import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var products: [AdminViewModel.ItemResponse] = []
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        Task {
            do {
                let body: WebService.empty? = nil
                let products = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: "GET", authReq: false, body: body, responseType: [AdminViewModel.ItemResponse].self, unknownType: false)
                DispatchQueue.main.async {
                    self.products = products
                }
            } catch {
                print("failed to get items from server")
            }
        }
    }
}
