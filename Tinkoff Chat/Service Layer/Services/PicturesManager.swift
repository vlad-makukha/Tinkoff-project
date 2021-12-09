//
//  PicturesManager.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 23.11.2021.
//

import Foundation
import UIKit

protocol PicturesService {
    func loadPicuresLinks(completionHandler: @escaping ([PictureLinkModel]?, String?) -> Void)
    func loadPicture(from url: URL, completionHandler: @escaping (UIImage?, String?) -> Void)
}

class PicturesManager: PicturesService {
    var requestSender: RequestSenderProtocol
    init(requestSender: RequestSenderProtocol) {
          self.requestSender = requestSender
      }
    
    func loadPicuresLinks(completionHandler: @escaping ([PictureLinkModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.PictureRequests.picturesLinksConfig()
        requestSender.send(requestConfig: requestConfig) { (result: Result<[PictureLinkModel]>) in
            switch result {
            case .success(let pictureLinkModels):
                completionHandler(pictureLinkModels, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadPicture(from url: URL, completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.PictureRequests.pictureConfig(from: url)
        requestSender.send(requestConfig: requestConfig) { (result: Result<PictureModel>) in
            
            switch result {
            case .success(let pictureModel):
                completionHandler(pictureModel.image, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
