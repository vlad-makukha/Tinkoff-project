//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var hideKeyboardImageView: UIImageView!
    @IBOutlet weak var bottomBarTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!

    private let channel: ChannelCD
    private let incomingCellIdentifier = String(describing: IncomingMessageTableViewCell.self)
    private let outgoingCellIdentifier = String(describing: OutgoingMessageTableViewCell.self)
    private lazy var dataBase = Firestore.firestore()
    private lazy var reference = dataBase.collection("channels")
    private let storage = Storage.storage().reference()
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    private var top: CGFloat = 0.0
    private var lastIndexPath: IndexPath? {
        let section = numberOfSections(in: tableView) - 1
        if section >= 0 {
            let row = tableView(tableView, numberOfRowsInSection: section) - 1
            if row >= 0 {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    lazy var fetchedResultsController: NSFetchedResultsController<MessageCD> = {
        let fetchRequest: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "channel == %@", channel)
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataStack.shared.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        try? fetchedResultsController.performFetch()
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    // MARK: - initialization

    init(channel: ChannelCD) {
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
        reference = dataBase.collection("channels").document(channel.identifier ?? "").collection("messages")
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
            // Сохранение в CoreData
            CoreDataStack.shared.performSave { [weak self] context in
                guard let channel = self?.channel,
                    let identifier = channel.identifier,
                    let messages = self?.messages else { return }
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bottomBarTextView.layer.cornerRadius = bottomBarTextView.frame.height / 5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        top = view.frame.origin.y
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
            if let lastIndexPath = self.lastIndexPath {
                self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: true)
            }
        }
    }

    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
        messages.sort()
//        tableView.reloadData()
    }

    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }

        switch change.type {
        case .added:
            insertNewMessage(message)
            DispatchQueue.main.async {
                if let lastIndexPath = self.lastIndexPath {
                    self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: false)
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
            if let lastIndexPath = self.lastIndexPath {
                self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: true)
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

extension ConversationViewController: UITableViewDataSource,
                                      UITableViewDelegate,
                                      NSFetchedResultsControllerDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        if message.senderId != Message.myId {
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let newIndexPath = newIndexPath, let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
