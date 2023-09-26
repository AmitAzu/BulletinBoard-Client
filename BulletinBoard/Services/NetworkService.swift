//
//  NetworkService.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import Foundation
import Combine

class NetworkService: ObservableObject {
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func dataTaskPublisher<T: Codable>(from endPoint: EndPointRequest) -> AnyPublisher<T, Error> {
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
}

fileprivate enum APIError: Error {
    case invalidURL
    case invalidResponse
}

enum ApiUrl {
    case deleteBulletin(id: String)
    case getBulletins
    case uploadBulletin
    case updateBulletin(id: String)
    
    private var host: String {
        NetworkUrl.baseURL.rawValue
    }
    
    var url: URL {
        var component = URLComponents()
        component.scheme = "https"
        component.host = host
        
        switch self {
        case .deleteBulletin(let id): component.path = "/delete/\(id)"
        case .getBulletins: component.path = "/posts"
        case .uploadBulletin: component.path = "/upload"
        case .updateBulletin(let id): component.path = "/update/\(id)"
        }
        
        return component.url!
    }
}

fileprivate enum NetworkUrl: String {
    case baseURL = "jsonplaceholder.typicode.com"
}

enum APIHTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

class EndPointBasic {
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

class EndPointRequest: EndPointBasic {
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
