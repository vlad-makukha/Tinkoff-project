//
//  Logger.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 22.09.2021.
//

import Foundation

class Logger {
    func log(message: String, function: String = #function) {
        let isDebugEnabled = CommandLine.arguments.contains("--debug")
        if isDebugEnabled {
            print("\(message) : \(function)")
        }
    }
}
