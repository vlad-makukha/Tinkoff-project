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
    
    @IBOutlet weak var outgoingBubbleView: UIView!{
        didSet{
            outgoingBubbleView.layer.cornerRadius = 10
            outgoingBubbleView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var outgoingTextLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }
    
    func configure(with model: ConversationCellModel) {
        outgoingTextLabel.text = model.text
        selectionStyle = .none
    }
}

