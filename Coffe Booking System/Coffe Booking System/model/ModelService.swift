import Foundation
import UserNotifications

//fill the model

class ModelService {
    
    var shop: Shop
    
    init(shop: Shop) {
        self.shop = shop
    }
    
    //Build the shop and fill the model
    func buildShop() {
        fillItems()
    }
    
    func fillItems(itemData: [API.ItemResponse]) {
        return
    }
}
