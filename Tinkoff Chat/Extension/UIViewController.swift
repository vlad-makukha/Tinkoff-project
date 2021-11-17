//
//  UIViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 17.11.2021.
//

import UIKit

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message: String?, options: String..., completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { (_) in
                completion(options[index])
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
