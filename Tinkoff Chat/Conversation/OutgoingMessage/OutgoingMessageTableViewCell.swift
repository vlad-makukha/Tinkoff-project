//
//  OutgoingMessageTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {

    struct ConversationCellModel {
            let text: String
        }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var outgoingBubbleView: UIView! {
        didSet {
            outgoingBubbleView.layer.cornerRadius = 10
            outgoingBubbleView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var outgoingTextLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = Theme.current.backgroundColor
        outgoingBubbleView.backgroundColor = Theme.current.outgoingMessageCellBackgroundColor
        outgoingTextLabel.textColor = Theme.current.outgoingMessageCellTextColor
    }

    func configure(with model: Message) {
        outgoingTextLabel.text = model.content
        selectionStyle = .none

        let dateFormatter = DateFormatter()
        let date = model.created
        if Calendar.current.isDateInToday(date) {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
        }
        dateLabel.text = dateFormatter.string(from: date)
    }
}
