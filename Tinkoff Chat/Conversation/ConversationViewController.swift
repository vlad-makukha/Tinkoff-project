//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var hideKeyboardImageView: UIImageView!
    @IBOutlet weak var bottomBarTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!

    private let channel: Channel
    private let incomingCellIdentifier = String(describing: IncomingMessageTableViewCell.self)
    private let outgoingCellIdentifier = String(describing: OutgoingMessageTableViewCell.self)
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference = dataBase.collection("channels")
    private let storage = Storage.storage().reference()
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    var top: CGFloat = 0.0

    // MARK: - initialization

    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        title = channel.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        messageListener?.remove()
    }

    // MARK: - UIViewController lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        reference = dataBase.collection("channels").document(channel.identifier).collection("messages")
        setupTableView()
        addNotificationKeyboardObserver()

        let operationSystem = ProcessInfo().operatingSystemVersion
        if operationSystem.majorVersion == 12 {
            hideKeyboardImageView.image = UIImage(named: "Ios12Keyboard.chevron.compact.down")
            hideKeyboardImageView.contentMode = .scaleAspectFit
            sendButton.setImage(UIImage(named: "Ios12paperplane.fill"), for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomBarView.backgroundColor = Theme.current.backgroundColor
        bottomBarTextView.backgroundColor = Theme.current.textBackgroundColor

        messageListener = reference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }

            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bottomBarTextView.layer.cornerRadius = bottomBarTextView.frame.height / 5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        top = view.frame.origin.y
        //        top = bottomBarView.frame.origin.y
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Methods

    func setupTableView() {
        tableView.register(UINib(nibName: String(describing: IncomingMessageTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: incomingCellIdentifier)
        tableView.register(UINib(nibName: String(describing: OutgoingMessageTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: outgoingCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundColor = Theme.current.backgroundColor
        view.backgroundColor = Theme.current.backgroundColor
    }

    // MARK: Firebase interaction

    private func sendMessage(_ message: Message) {
        reference.addDocument(data: message.representation) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            if !self.messages.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: NSIndexPath(row: 0,
                                                               section: self.messages.count - 1) as IndexPath,
                                               at: .bottom, animated: true)
                }
            }
        }
    }

    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
        messages.sort()
        tableView.reloadData()
    }

    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }

        switch change.type {
        case .added:
            insertNewMessage(message)
            if !messages.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: NSIndexPath(row: 0,
                                                               section: self.messages.count - 1) as IndexPath,
                                               at: .bottom, animated: false)
                }
            }
        default:
            break
        }
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = bottomBarTextView.text, text != ""
        else { print("Sending error")
            return }

        let message = Message(content: text)
        sendMessage(message)
        bottomBarTextView.text = ""
    }

    // MARK: Work with keyboard

    func addNotificationKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                  as? NSValue)?.cgRectValue else {return}
        DispatchQueue.main.async {
            if self.keyboardConstraint.constant == 0 {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                self.tableView.contentInset.bottom = 0
                self.tableView.layoutIfNeeded()

                let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                                              as? NSNumber)?.doubleValue ?? 0
                UIView.animate(withDuration: duration, animations: {
                    self.keyboardConstraint.constant = -keyboardSize.height
                    self.view.layoutIfNeeded()
                })
            }
            if !self.messages.isEmpty {
                self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: self.messages.count - 1) as IndexPath,
                                           at: .bottom, animated: true)
            }
            self.hideKeyboardImageView.isHidden = false
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.keyboardConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.tableView.layoutIfNeeded()
            self.hideKeyboardImageView.isHidden = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.section]
        if message.senderId != message.myId {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: incomingCellIdentifier,
                                                           for: indexPath) as? IncomingMessageTableViewCell
            else { return UITableViewCell() }
            cell.configure(with: message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: outgoingCellIdentifier,
                                                           for: indexPath) as? OutgoingMessageTableViewCell
            else { return UITableViewCell() }
            cell.configure(with: message)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }

}
