//
//  MessageModel.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 26.10.2021.
//

import Foundation
import Firebase

struct Message {

    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    static let myId = UIDevice.current.identifierForVendor?.uuidString
    let identifier: String?

    init(content: String) {
        self.content = content
        created = Date()
        senderId = Message.myId ?? "senderId"
        senderName = "My Name" // Здесь будет браться имя из профайла. Пока не реализовано, тк в ТЗ нет
        identifier = nil
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard let content = data["content"] as? String else {
            print("content reading error")
            return nil
        }
        guard let created = data["created"] as? Timestamp else {
            print("created reading error")
            return nil
        }
        guard let senderId = data["senderId"] as? String else {
            print("senderId reading error")
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            print("senderName reading error")
            return nil
        }

        self.content = content
        self.created = created.dateValue()
        self.senderId = senderId
        self.senderName = senderName
        identifier = document.documentID

    }
}

extension Message {

    var representation: [String: Any] {
        let rep: [String: Any] = [
            "content": content,
            "created": created,
            "senderId": senderId,
            "senderName": senderName
        ]
        return rep
    }
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.created < rhs.created
    }
}
