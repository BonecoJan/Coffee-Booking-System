import Foundation
import UserNotifications

//fill and update the model

class ModelService: ObservableObject {
    
    @Published var webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fillDataModel(shop: Shop) {
    }
}
