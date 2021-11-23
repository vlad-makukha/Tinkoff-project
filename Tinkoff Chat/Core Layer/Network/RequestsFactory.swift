//
//  RequestsFactory.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 23.11.2021.
//

import Foundation

struct RequestsFactory {
    
    struct PictureRequests {
        
        static func picturesLinksConfig() -> RequestConfig<PicturesListParser> {
            let request = PicturesListRequest(apiKey: "12818092-07a391b912d5dad3805e53a87", limit: 102)
            return RequestConfig<PicturesListParser>(request: request, parser: PicturesListParser())
        }
        
        static func pictureConfig(from url: URL) -> RequestConfig<PictureParser> {
            let request = PictureRequest(url: url)
            return RequestConfig<PictureParser>(request: request, parser: PictureParser())
        }
    }
}
