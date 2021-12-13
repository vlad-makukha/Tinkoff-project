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
    
    private let baseUrl = Bundle.main.object(forInfoDictionaryKey: "PIXABAY_API") as? String
    private let token = Bundle.main.object(forInfoDictionaryKey: "PIXABAY_TOKEN") as? String
    private var resultsLimit: Int
    
    private func getUrlString(baseUrl: String, key: String) -> String {
            let parametrs: [String: String] = ["key": key,
            "per_page": "\(resultsLimit)"]
            let query = parametrs.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
            return baseUrl + "?" + query
    }
    
    // MARK: - Request
    var urlRequest: URLRequest? {
        guard let baseUrl = baseUrl, let token = token else { return nil}
        let urlString = getUrlString(baseUrl: baseUrl, key: token)
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    init(limit: Int = 100) {
        self.resultsLimit = limit
    }
}

class PictureRequest: RequestProtocol {
    
    var urlRequest: URLRequest?
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
}
