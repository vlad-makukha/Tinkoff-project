//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 06.10.2021.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelCD> = {
        let fetchRequest: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataStack.shared.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        try? fetchedResultsController.performFetch()
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)

    // MARK: - UIViewController lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseManager.shared.getChannels()
    }

    // MARK: - Methods

    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let themesVC = ThemesViewController()
        themesVC.title = "Settings"

        // MARK: - Delegate
        // themesVC.delegate = self

        // MARK: - Closure
        themesVC.themeApplied = { [weak self] in
            self?.tableView.backgroundColor = Theme.current.backgroundColor
            self?.view.backgroundColor = Theme.current.backgroundColor
            self?.navigationController?.navigationBar.barStyle = Theme.current.barStyle
            self?.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Theme.current.textColor]
            self?.navigationController?.navigationBar.isTranslucent = false
        }

        navigationController?.pushViewController(themesVC, animated: false)
    }

    func setupTableView() {
        tableView.register(UINib(nibName: String(describing: ConversationsListTableViewCell.self),
                                 bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.backgroundColor = Theme.current.backgroundColor
    }

    @IBAction func addChannelTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Создание нового канала",
                                                message: "Введите имя нового канала", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.textColor = .black
        }
        let save = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != ""
            else { self?.showErrorAlertController(withText: "Название канала не должно быть пустым!")
                return }
            if let channelName = textField.text {
                FirebaseManager.shared.addChannel(name: channelName)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "showProfile", sender: sender)
        }

    // MARK: Alert

    func showErrorAlertController(withText message: String) {
        let errorAlertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(errorAlertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate,
                                           UITableViewDataSource,
                                           NSFetchedResultsControllerDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = Theme.current.textBackgroundColor
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
        //        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsListTableViewCell else { return UITableViewCell() }
        let channel = fetchedResultsController.object(at: indexPath)
        //        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsController.object(at: indexPath)
        //        let channel = channels[indexPath.row]
        let conversationVC = ConversationViewController(channel: channel)
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let channel = self.fetchedResultsController.object(at: indexPath)
            FirebaseManager.shared.deleteChannel(channel: channel)
            CoreDataManager.shared.deleteChannel(channel: channel)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
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

// делегат
// extension ConversationsListViewController: ThemePickerDelegate {
//    func ThemeApplied() {
//        self.tableView.backgroundColor = Theme.current.backgroundColor
//        self.view.backgroundColor = Theme.current.backgroundColor
//        self.navigationController?.navigationBar.barStyle = Theme.current.barStyle
//        self.navigationController?.navigationBar.titleTextAttributes =
//        [NSAttributedString.Key.foregroundColor: Theme.current.textColor]
//        self.navigationController?.navigationBar.isTranslucent = false
//    }
// }

// MARK: - Prepare for Segue

extension ConversationsListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileViewController = segue.destination as? ProfileViewController else { return }
        profileViewController.transitioningDelegate = self
        profileViewController.modalPresentationStyle = .overCurrentContext
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let imageSuperview = profileImageButton.superview else { return nil }
        let transition = AnimationManager(duration: 0.8)
        transition.originFrame = imageSuperview.convert(profileImageButton.frame, to: nil)
        transition.originFrame = CGRect(
            x: transition.originFrame.origin.x,
            y: transition.originFrame.origin.y,
            width: transition.originFrame.size.width - 40,
            height: transition.originFrame.size.height - 40
        )
        return transition
    }
    
}
