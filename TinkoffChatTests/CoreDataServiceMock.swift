//
//  CoreDataServiceMock.swift
//  TinkoffChatTests
//
//  Created by Владислав Макуха on 09.12.2021.
//

import Foundation
@testable import Tinkoff_Chat

final class CoreDataServiceMock: CoreDataService {
    
    var saveChannelsCount: Int = 0
    var saveChannels: [[Channel]] = []
    
    private init() {}
    static let shared = CoreDataServiceMock()
    
    func saveChannels(channels: [Channel]) {
        saveChannels.append(channels)
        saveChannelsCount += 1
    }
    
    func deleteChannel(channel: ChannelCD) {
    }
    
    func saveMessages(channel: ChannelCD, messages: [Message]) {
    }
    
}
