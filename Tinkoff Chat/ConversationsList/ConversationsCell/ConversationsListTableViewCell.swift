//
//  ConversationsListTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell, ConfigurableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        messageLabel?.font = .systemFont(ofSize: 13)
        dateLabel?.isHidden = true
    }

    func configure(with model: Channel) {
        selectionStyle = .none
        nameLabel.text = model.name
        messageLabel.font.withSize(13)
        backgroundColor = Theme.current.backgroundColor

        if let lastMessage = model.lastMessage {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 13)
        }

        let dateFormatter = DateFormatter()
        if let date = model.lastActivity {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            }
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.isHidden = false
        }
    }
}
