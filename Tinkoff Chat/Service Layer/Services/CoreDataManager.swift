//
//  CoreDataManager.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 17.11.2021.
//

import Foundation
import CoreData

protocol CoreDataService {
    func saveChannels(channels: [Channel])
    func deleteChannel(channel: ChannelCD)
    func saveMessages(channel: ChannelCD, messages: [Message])
}

class CoreDataManager: CoreDataService {
    
    private init() {}
    static let shared = CoreDataManager()
    
    func saveChannels(channels: [Channel]) {
        CoreDataStack.shared.performSave { context in
            let fetchRequest: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
            let channelsInCD = try? CoreDataStack.shared.mainContext.fetch(fetchRequest)
            for channel in channels {
                if let savedChannel = channelsInCD?.first(where: { $0.identifier == channel.identifier }) {
                    if savedChannel.name != channel.name {
                        savedChannel.name = channel.name
                    }
                    if savedChannel.lastMessage != channel.lastMessage {
                        savedChannel.lastMessage = channel.lastMessage
                    }
                    if savedChannel.lastActivity != channel.lastActivity {
                        savedChannel.lastActivity = channel.lastActivity
                    }
                } else {
                    let channelEntity = ChannelCD(context: context)
                    channelEntity.identifier = channel.identifier
                    channelEntity.name = channel.name
                    channelEntity.lastMessage = channel.lastMessage
                    channelEntity.lastActivity = channel.lastActivity
                }
            }
        }
    }
    
    func deleteChannel(channel: ChannelCD) {
        CoreDataStack.shared.mainContext.delete(channel)
        try? CoreDataStack.shared.performSave(in: CoreDataStack.shared.mainContext)
    }
    
    func saveMessages(channel: ChannelCD, messages: [Message]) {
        CoreDataStack.shared.performSave { context in
            guard let identifier = channel.identifier else { return }
            let fetchRequest: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            guard let channelCR = try? context.fetch(fetchRequest).first else { return }
            
            for message in messages {
                if (channelCR.messages?.first(where: { ($0 as? MessageCD)?.identifier == message.identifier })) == nil {
                    let messageEntity = MessageCD(context: context)
                    messageEntity.content = message.content
                    messageEntity.created = message.created
                    messageEntity.senderId = message.senderId
                    messageEntity.senderName = message.senderName
                    messageEntity.identifier = message.identifier
                    channelCR.addToMessages(messageEntity)
                }
            }
        }
    }
    
}
