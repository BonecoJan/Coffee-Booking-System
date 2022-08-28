import Foundation

class HomeController: ObservableObject {
    
    @Published var products: [Response.Item] = []
    
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var error: String = ""
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        self.isLoading = true
        Task {
            do {
                let body: Request.Empty? = nil
                let products = try await WebService(authManager: AuthManager()).request(reqUrl: "items", reqMethod: GET, authReq: false, body: body, responseType: [Response.Item].self, unknownType: false)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasError = false
                    self.products = products
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
