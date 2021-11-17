//
//  CoreDataStack.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 03.11.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            else {
                fatalError("document path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtention = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtention)
            else {
                fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            else {
                fatalError("managedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do { try performSave(in: context) } catch { assertionFailure(error.localizedDescription) }
            }
        }
    }
    
    func performSave(in context: NSManagedObjectContext) throws {
        context.performAndWait {
            do {
                try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { try performSave(in: parent) }
    }
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            print("Добавлено объектов:", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            print("Обновлено объектов:", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            print("Удалено объектов:", deletes.count)
        }
    }
    
    func printDatabaseStatistice() {
        mainContext.perform {
            do {
                let channelCount = try self.mainContext.count(for: ChannelCD.fetchRequest())
                let messageCount = try self.mainContext.count(for: MessageCD.fetchRequest())
                print("Сейчас в CoreData \(channelCount) каналов и \(messageCount) сообщений")
                
                // Вывод названий каналов
                if let channelArray = try self.mainContext.fetch(ChannelCD.fetchRequest()) as? [ChannelCD] {
                    print("Список каналов:")
                    channelArray.forEach {
                        print($0.name ?? "")
                    }
                }
                
                // Вывод сообщений
                if let messageArray = try self.mainContext.fetch(MessageCD.fetchRequest()) as? [MessageCD], messageCount != 0 {
                    print("Список сообщений:")
                    messageArray.forEach {
                        print("Канал: '\($0.channel?.name ?? "")', Пользователь: '\($0.senderName ?? "")', Сообщение: '\($0.content ?? "")'")
                    }
                }
                
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
