import Foundation

class ItemViewController: ObservableObject{
    
    @Published var items: [Item] = []
    
    func getAllItems() {
    
        WebService().requestAllItems() { (result) in
            switch result {
                case .success(let items):
                    DispatchQueue.main.async {
                        self.items = items
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
            
        }
    }
}
