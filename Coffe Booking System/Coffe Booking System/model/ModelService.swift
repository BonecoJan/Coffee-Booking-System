import Foundation
import UserNotifications

//fill and update the model

class ModelService: ObservableObject {
    
    @Published var shop: Shop
    @Published var webService: WebService
    
    init(shop: Shop, webService: WebService) {
        self.shop = shop
        self.webService = webService
        self.fillDataModel()
        //for user in self.shop.users{
        //    print("test")
        //    print(user.name)
        //}
    }
    
    func fillDataModel() {
        //TODO: WIP
        webService.getUsers { (users) in
            for user in users{
                self.shop.users.append(User(id: user.id, name: user.name))
            }
        }
        webService.getItems { (items) in
            for item in items{
                self.shop.items.append(Item(id: item.id, name: item.name, amount: item.amount, price: item.price))
            }
        }
    }
    
    func createCurrentUser(id: String, name: String) {
        self.shop.currentUser = User(id: id, name: name)
    }
    
    func addUser(id: String, name: String) {
        self.shop.users.append(User(id: id, name: name))
    }
}
