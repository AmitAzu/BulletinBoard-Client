//
//  NetworkService.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import Foundation
import Combine

final class NetworkService: ObservableObject {
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func dataTaskPublisher<T: Codable>(from endPoint: EndPointRequest, ofType type: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: endPoint.url)
        request.httpMethod = endPoint.method.rawValue
        
        if let headers = endPoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postDataTaskPublisher<T: Codable, D: Codable>(to endPoint: EndPointRequest, ofType type: T.Type, withData data: D) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: endPoint.url)
        
        request.httpMethod = endPoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

fileprivate enum APIError: Error {
    case invalidURL
    case invalidResponse
}

enum ApiUrl {
    case deleteBulletin(id: Int)
    case getBulletins
    case addBulletin
    case updateBulletin(id: Int)
    
    private var host: String {
        NetworkUrl.baseURL.rawValue
    }
    
    private var port: Int {
        NetworkPort.basePort.rawValue
    }
    
    var url: URL {
        var component = URLComponents()
        component.scheme = "http"
        component.host = host
        component.port = port
        
        switch self {
        case .deleteBulletin(let id): component.path = "/deleteBulletin/\(id)"
        case .getBulletins: component.path = "/getBulletin"
        case .addBulletin: component.path = "/addBulletin"
        case .updateBulletin(let id): component.path = "/update/\(id)"
        }
        
        return component.url!
    }
}

//MARK: Change it to your local host - set your private IP, and don't forget to change it in the Info.plist as well
fileprivate enum NetworkUrl: String {
    case baseURL = "10.0.0.7"
}

fileprivate enum NetworkPort: Int {
    case basePort = 3000
}

enum APIHTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

class EndPoint {
    let url: URL
    let method: APIHTTPMethod
    let headers: [String: String]?
    
    init(
        url: URL,
        method: APIHTTPMethod,
        headers: [String: String]? = nil) {
            self.url = url
            self.method = method
            self.headers = headers
        }
}

class EndPointRequest: EndPoint {
    let parameters: [String: Any?]?
    
    init(url: URL,
         method: APIHTTPMethod,
         headers: [String: String]? = nil,
         parameters: [String: Any?]? = nil) {
        self.parameters = parameters
        super.init(url: url,
                   method: method,
                   headers: headers)
    }
    
    convenience init(
        apiUrl: ApiUrl,
        method: APIHTTPMethod,
        headers: [String: String] = [:]) {
            self.init(
                url: apiUrl.url,
                method: method,
                headers: headers)
        }
}
