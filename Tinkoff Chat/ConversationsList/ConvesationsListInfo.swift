//
//  ConvesationsListInfo.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import Foundation

let yesterday = Date(timeIntervalSinceNow: -24.0 * 3600.0)
let beforeYesterday = Date(timeIntervalSinceNow: -48.0 * 3600.0)

var chats = [
    
    [
        ConversationsListTableViewCell.ConversationCellModel(name: "Владимир Путин", message: "Как дела? Лол", date: Date(), isOnline: true, hasUnreadMessages: true, picture: "human0"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Дмитрий Медведев", message: "Привет! Нам нужно обсудить детали по проекту.", date: Date(), isOnline: true, hasUnreadMessages: true, picture: "human1"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Сергей Шойгу", message: "Давно не виделись!", date: Date(), isOnline: true, hasUnreadMessages: false, picture: "human2"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Андрей Турчак", message: "Слышал новости?", date: yesterday, isOnline: true, hasUnreadMessages: false, picture: "human3"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Рамзан Кадыров", message: "Извинись!", date: yesterday, isOnline: true, hasUnreadMessages: false, picture: "human4"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Герман Греф", message: "$$$", date: beforeYesterday, isOnline: true, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Вячеслав Макаров", message: nil, date: nil, isOnline: true, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Сергей Соловьев", message: nil, date: nil, isOnline: true, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Николай Цед", message: nil, date: nil, isOnline: true, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Оксана Дмитриева", message: nil, date: nil, isOnline: true, hasUnreadMessages: false, picture: nil)
    ],
    [
        ConversationsListTableViewCell.ConversationCellModel(name: "Борис Вишевский", message: "Голосуй за меня!", date: yesterday, isOnline: false, hasUnreadMessages: true, picture: "human5"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Борис Вишевский", message: "Все клоны, я настоящий Вишневский", date: yesterday, isOnline: false, hasUnreadMessages: false, picture: "human6"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Борис Вишневский", message: "Я/МЫ Борисы Вишневские", date: yesterday, isOnline: false, hasUnreadMessages: false, picture: "human7"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Алексей Навальный", message: "Увидимся в 2034", date: yesterday, isOnline: false, hasUnreadMessages: false, picture: "human8"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Сергей Шнуров", message: "Ладно", date: yesterday, isOnline: false, hasUnreadMessages: false, picture: "human9"),
        ConversationsListTableViewCell.ConversationCellModel(name: "Любовь Соболь", message: "Сижу дома", date: yesterday, isOnline: false, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Елена Драпеко", message: "Поняла", date: beforeYesterday, isOnline: false, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Дмитрий Рогозин", message: "Elthon Jon - Rocket man", date: beforeYesterday, isOnline: false, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Геннадий Зюганов", message: "Ленин ЖИВ!", date: beforeYesterday, isOnline: false, hasUnreadMessages: false, picture: nil),
        ConversationsListTableViewCell.ConversationCellModel(name: "Алишер Усманов", message: "Да", date: beforeYesterday, isOnline: false, hasUnreadMessages: false, picture: nil)
    ]
    
]

let sectionNames = ["Online", "History"]
