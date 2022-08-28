import Foundation
import Network

// Source: morioh.com/p/68816b37881c

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isNotConnected = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNotConnected = path.status == .satisfied ? false : true
            }
        }
        monitor.start(queue: queue)
    }
}
