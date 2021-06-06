//
//  StorageService.swift
//  CourseworkChat
//
//  Created by Admin on 06.06.2021.
//

import Foundation
import CoreData

class StorageService{
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CourseworkChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var backgroundContext : NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    func addChat(chat : Chat){
        let context = backgroundContext
        
        
        do{
            let _chat = Chats(context: context)
            _chat.id = chat.chatBody.chatId
            _chat.body = try encoder.encode(chat.chatBody)
            _chat.senders = try encoder.encode(chat.senders)
            
            try context.save()
            
        }catch (let error){
            print(error)
            return
        }
      
        
    }
    
    func getChats() -> [UUID:Chat]?{
        let context = backgroundContext
        
        
        let fetchRequest = NSFetchRequest<Chats>(entityName: "Chats")
        
        var chats = [Chats]()
        do {
            chats = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
        var realChats = [UUID:Chat]()
        
        for chat in chats {
            do{
                let body = try decoder.decode(ChatBody.self, from: chat.body!)
                let senders = try decoder.decode([Sender].self, from: chat.senders!)
                let realChat = Chat(senders: senders, chatBody: body)
                realChats[body.chatId] = realChat
            }
            catch (let error)
            {
                print(error)
                return nil
                
            }
        }
        
        return realChats
    }
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
