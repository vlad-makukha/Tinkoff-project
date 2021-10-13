//
//  Theme.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 13.10.2021.
//

import UIKit

enum Theme: Int {
    case classic, night, day
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .classic
    }
    
    var mainColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 19.0/255.0, green: 118.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        case .day:
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .classic, .day:
            return .default
        case .night:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor.white
        case .night:
            return UIColor.black
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor.black
        case .night:
            return UIColor.white
        }
    }
    
    var textBackgroundColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor(white: 0.9, alpha: 1.0)
        case .night:
            return UIColor(white: 0.1, alpha: 1.0)
        }
    }
    
    var onlineUserCellBackgroundColor: UIColor {
        switch self {
        case .classic, .day:
            return #colorLiteral(red: 1, green: 1, blue: 0.7451882991, alpha: 0.7470569349)
        case .night:
            return #colorLiteral(red: 0.2375557125, green: 0.225965023, blue: 0.05639447272, alpha: 1)
        }
    }
    
    var incomingMessageCellBackgroundColor: UIColor {
        switch self {
        case .classic:
            return #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8392156863, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.889503181, green: 0.8977108598, blue: 0.9182967544, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        }
    }
    
    var outgoingMessageCellBackgroundColor: UIColor {
        switch self {
        case .classic:
            return #colorLiteral(red: 0.8862745098, green: 0.9725490196, blue: 0.8156862745, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.262745098, green: 0.537254902, blue: 0.9764705882, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        }
    }
    
    var outgoingMessageCellTextColor: UIColor {
        switch self {
        case .classic:
            return UIColor.black
        case .night, .day:
            return UIColor.white
        }
    }
    
    var themesVCBackgroundColor: UIColor {
        switch self {
        case .classic:
            return .white
        case .day:
            return .yellow
        case .night:
            return .black
        }
    }
    
    
    func apply() {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        }
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        UILabel.appearance().textColor = textColor
        UITextField.appearance().textColor = textColor
        UITextView.appearance().textColor = textColor
        UITextView.appearance().backgroundColor = backgroundColor
        UIActivityIndicatorView.appearance().color = mainColor
        
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().isTranslucent = false
        
        UITableView.appearance().backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
    }
    
}
