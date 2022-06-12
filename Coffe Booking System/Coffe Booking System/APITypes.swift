//
//  APITypes.swift
//  Coffe Booking System
//
//  Created by Tobias Stuhldreier on 10.06.22.
//

import Foundation

extension API {
    
    enum Types {
    
        // Struct has to be encodable for casting converting from json
        enum Response {
            
        }
        
        // Struct has to be decodable
        enum Request {
            
        }
        
        enum Error: LocalizedError {
            case generic(reason: String)
            case `internal`(reason: String)
            
            var errorDescription: String? {
                switch self {
                    case .generic(let reason):
                        return reason
                    case .internal(let reason):
                        return "Internal Error: \(reason)"
                }
            }
        }
        
        enum Endpoint {
            case search(query: String)
        
            var url: URL {
                var components = URLComponents()
                components.host = "141.51.114.20:8080"
                components.scheme = "http"
                components.path = "path"
                components.queryItems =
                [
                        
                ]
                return components.url!
            }
        }
        
        enum Method: String {
            case get
            case post
            case put
        }
    }
}
