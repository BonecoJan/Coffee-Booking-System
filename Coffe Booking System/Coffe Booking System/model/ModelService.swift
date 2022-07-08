import Foundation
import UserNotifications

//fill and update the model

class ModelService: ObservableObject {
    
    @Published var webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fillDataModel(shop: Shop) {
        //TODO: WIP
        webService.getUsers { (users) in
            for user in users{
                DispatchQueue.main.async {
                    shop.users.append(User(id: user.id, name: user.name))
                }
            }
        }
        webService.getItems { (items) in
            for item in items{
                DispatchQueue.main.async {
                    shop.items.append(Item(id: item.id, name: item.name, amount: item.amount, price: item.price))
                }
            }
        }
    }
}
