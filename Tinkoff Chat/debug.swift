//
//  debug.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 22.09.2021.
//

import Foundation

class Log {

    func DLog(message: String, function: String = #function) {
    #if DEBUG
      print("\(message) : \(function)")
    #endif
  }
}
