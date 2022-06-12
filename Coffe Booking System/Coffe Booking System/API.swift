import Foundation

class API {
    //API-url
    let apiUrl = "http://141.51.114.20:8080/"

    // structs to be filled in with json data
    struct UserResponse: Codable {
        var id: String
        var name: String
    }
    
    struct ItemResponse: Codable {
        var id: String
        var name: String
        var amount: Int
        var price: Double
    }
    
    //parse the JSON data into the struct
    //single User parsing
    private func parseUser(jsonData: Data) -> UserResponse?{
        
        do {
            let decodedData = try JSONDecoder().decode(UserResponse.self, from: jsonData)
            return decodedData
        } catch {
            print("Error while parsing User data from json to struct")
            return nil
        }
    }
    
    //API GET-Request
    func apiGetRequest(path: String) -> Codable? {
        let url = URL(string: apiUrl)!
        var request = URLRequest(url: url)
        var parsedData: Codable?
        request.httpMethod = "GET"
        request.setValue("application/png", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    switch path {
                        case "users":
                            parsedData = try JSONDecoder().decode([UserResponse].self, from: data)
                            print(parsedData)
                        case "items":
                            parsedData = try JSONDecoder().decode([ItemResponse].self, from: data)
                        default:
                            print("false path")
                        parsedData = nil
                    }
                } catch {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP GET-Request failed with Error: \(error)")
                parsedData = nil
            }
        }
        task.resume()
        return parsedData
    }
}


