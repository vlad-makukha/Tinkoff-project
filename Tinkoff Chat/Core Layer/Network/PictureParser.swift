//
//  PictureParser.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 23.11.2021.
//

import Foundation
import UIKit

struct PictureModel {
    let image: UIImage
}

class PictureParser: ParserProtocol {
    
    func parse(data: Data) -> PictureModel? {
        guard let image = UIImage(data: data) else { return nil }
        return PictureModel(image: image)
    }
}
