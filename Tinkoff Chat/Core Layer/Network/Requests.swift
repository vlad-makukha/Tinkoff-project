//
//  Requests.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 23.11.2021.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

class PicturesListRequest: RequestProtocol {
    
    private var baseUrl: String = "https://pixabay.com/api/"
    private var apiKey: String
    private var resultsLimit: Int
    private var getParameters: [String: String] {
        return ["key": apiKey,
                "per_page": "\(resultsLimit)"]
    }
    
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    // MARK: - Request
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    init(apiKey: String, limit: Int = 100) {
        self.apiKey = apiKey
        self.resultsLimit = limit
    }
}

class PictureRequest: RequestProtocol {
    
    var urlRequest: URLRequest?
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
}
