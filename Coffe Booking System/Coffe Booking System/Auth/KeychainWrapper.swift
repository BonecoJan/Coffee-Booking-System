import Foundation

final class KeychainWrapper {
    
    static let standard = KeychainWrapper()
    private init() {}
    
    func create(_ data: Data, service: String, account: String) {
        
        let body = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(body, nil)
        
        if status != errSecSuccess {
             print("Error: \(status)")
         }
        
        //update item if existing
        if status == errSecDuplicateItem {
            let body = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            SecItemUpdate(body, attributesToUpdate)
        }
    }
    
    func get(service: String, account: String) -> Data? {
        
        let body = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        //Read item from keychain
        SecItemCopyMatching(body, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        
        let body = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        //Delete item from keychain
        SecItemDelete(body)
    }
    
}
