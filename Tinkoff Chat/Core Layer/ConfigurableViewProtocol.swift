//
//  ConfigurableViewProtocol.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import Foundation

protocol ConfigurableView {
    associatedtype ConfigurationModel

    func configure(with model: ConfigurationModel)
}
