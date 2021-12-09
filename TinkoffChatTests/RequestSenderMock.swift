//
//  RequestSenderMock.swift
//  TinkoffChatTests
//
//  Created by Владислав Макуха on 09.12.2021.
//

import Foundation
@testable import Tinkoff_Chat

class RequestSenderMock: RequestSenderProtocol {
    
    var sendCount: Int = 0
    var urlRequests: [URLRequest] = []
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: ParserProtocol {
        sendCount += 1
        if let urlRequest = requestConfig.request.urlRequest {
            urlRequests.append(urlRequest)
        }
    }
}
