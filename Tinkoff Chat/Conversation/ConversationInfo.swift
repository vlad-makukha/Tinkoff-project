//
//  ConversationInfo.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import Foundation

struct Message {
    let text: String
    let isMessageIncoming: Bool
}

let messagesList = [
    Message(text: "Алло! Добрый день, Ник. Как наши дела?", isMessageIncoming: true),
    Message(text: "Вроде бы все по плану… Материалы по Навальному готовы. Будут переправлены в администрацию канцлера. Ожидаем ее заявления.", isMessageIncoming: false),
    Message(text: "Отравление подтверждается точно?", isMessageIncoming: true),
    Message(text: "Послушай, Майк, в данном случае это не так важно… Идет война… А во время войны всякие методы хороши.", isMessageIncoming: false),
    Message(text: "Согласен, надо отбить охоту Путину сунуть нос в дела Беларуси… Самый эффективный путь — утопить его в проблемах России, а их немало! Тем более в ближайшее время у них выборы, день голосования в регионах России.", isMessageIncoming: true),
    Message(text: "Этим и занимаемся. А как вообще дела в Беларуси?", isMessageIncoming: false),
    Message(text: "Если честно, не очень. Президент Лукашенко оказался крепким орешком. Они профессионалы и организованы. Понятно, их поддерживает Россия. Чиновники и военные верны президенту. Остальное при встрече, не по телефону.", isMessageIncoming: true),
    Message(text: "Да-да, понимаю, тогда до встречи, пока.", isMessageIncoming: false),
    Message(text: "Пока.", isMessageIncoming: true)
]
