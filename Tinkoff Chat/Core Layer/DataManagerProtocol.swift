//
//  DataManagerProtocol.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 19.10.2021.
//

import Foundation
import UIKit

protocol DataManager {
    
    static func saveTextDataToFiles(name: String, description: String, isNameChanged: Bool, isDescriptionChanged: Bool)
    static func savePictureToFile(picture: UIImage)
    static func loadTextDataFromFiles() -> (name: String?, description: String?)
    static func loadPictureFromFile() -> UIImage?
}
