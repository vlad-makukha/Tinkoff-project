//
//  FirebaseManager.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 17.11.2021.
//

import Foundation
import Firebase
import CoreData

class FirebaseManager {
    private init() {}
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    private var messagesReference: CollectionReference?
    
    // MARK: Work with channels
    
    func getChannels() {
        channelListener = channelsReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
            // Сохранение в CoreData
            CoreDataManager.shared.saveChannels(channels: self.channels)
        }
    }
    
    func addChannel(name: String) {
        channelsReference.addDocument(data: ["name": name])
    }
    
    func deleteChannel(channel: ChannelCD) {
        if let channelIdentifier = channel.identifier {
            channelsReference.document(channelIdentifier).delete()
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            addChannelToList(channel)
            
        case .modified:
            updateChannelInList(channel)
            
        case .removed:
            removeChannelFromList(channel)
        }
    }
    
    private func addChannelToList(_ channel: Channel) {
        guard !channels.contains(channel) else {
            return
        }
        channels.append(channel)
        channels.sort()
    }
    
    private func updateChannelInList(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        channels[index] = channel
    }
    
    private func removeChannelFromList(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        channels.remove(at: index)
        let fetchRequest: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", channel.identifier)
        guard let channelCR = try? CoreDataStack.shared.mainContext.fetch(fetchRequest).first else { return }
        CoreDataManager.shared.deleteChannel(channel: channelCR)
    }
    
    // MARK: Work with messages
    
    func getMessages(channel: ChannelCD) {
        messagesReference = channelsReference.document(channel.identifier ?? "").collection("messages")
        messageListener = messagesReference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            snapshot.documentChanges.forEach { change in
                self.handleMessagesDocumentChange(change)
            }
            // Сохранение в CoreData
            CoreDataManager.shared.saveMessages(channel: channel, messages: self.messages)
        }
    }
    
    func sendMessage(_ message: Message) {
        messagesReference?.addDocument(data: message.representation) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
        messages.sort()
    }
    
    private func handleMessagesDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            insertNewMessage(message)
        default:
            break
        }
    }
    
}
