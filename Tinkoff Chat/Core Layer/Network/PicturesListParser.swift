//
//  PicturesListParser.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 23.11.2021.
//

import Foundation

struct PictureLinkModel {
    let url: String
}

class PicturesListParser: ParserProtocol {
    
    func parse(data: Data) -> [PictureLinkModel]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return nil }
            guard let items = json["hits"] as? [[String: AnyObject]] else { return nil }
            var pictureLinks: [PictureLinkModel] = []
            for item in items {
                guard let url = item["webformatURL"] as? String else { continue }
                pictureLinks.append(PictureLinkModel(url: url))
            }
            return pictureLinks
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
