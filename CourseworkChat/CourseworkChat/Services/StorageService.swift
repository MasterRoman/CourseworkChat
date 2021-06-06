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
    private let backQueue = DispatchQueue.init(label: "store", qos: .background, attributes: .concurrent)
    
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
    
    var login : String?
    
    func addUser(){
        
        // queue.async {  [weak self] in
        //   guard let self = self else {return}
        
        let context =  self.backgroundContext
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do{
            var users = try context.fetch(fetchRequest)
            guard (users.firstIndex(where: {$0.loginUser == self.login}) != nil) else
            {
                let user = User(context: context)
                user.loginUser = self.login!
                
                users.append(user)
                
                print("USER")
                
                do{
                    try context.save()
                }
                catch (let error)
                {
                    print(error)
                    
                }
                
                
                return
            }
            
            
            
        }catch (let error){
            print(error)
            
            return
        }
        
        //   }
    }
    
    func addChat(chat : Chat){
        self.backQueue.async(flags: .barrier, execute: { [weak self] in
            
            guard let self = self else {return}
            let context = self.backgroundContext
            
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate =  NSPredicate(format: "loginUser = %@", self.login!)
            
            do{
                let _chat = Chats(context: context)
                let id  = chat.chatBody.chatId
                _chat.id = id
                let body = ChatBody(chatId: id, messages: [Message]())
                _chat.body = try self.encoder.encode(body)
                _chat.senders = try self.encoder.encode(chat.senders)
                
                let users = try context.fetch(fetchRequest)
                for user in users {
                    if user.loginUser == self.login{
                        _chat.addToUser(user)
                    }
                }
                
                
                do{
                    
                    try context.save()
                }
                catch (let error)
                {
                    print(error)
                    
                }
                
                
            }catch (let error){
                print(error)
                
                return
            }
            
        })
        
    }
    
    func getChats() -> [UUID:Chat]?{
        
        let context =  self.backgroundContext
        
        
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate =  NSPredicate(format: "loginUser = %@", login!)
        
        var realChats = [UUID:Chat]()
        var users = [User]()
        do {
            users = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
        for user in users {
            if user.loginUser == self.login{
                let _chats = user.chats?.allObjects as? [Chats]
                guard let chats = _chats else {
                    return nil
                }
                
                
                for chat in chats {
                    do{
                        let body = try self.decoder.decode(ChatBody.self, from: chat.body!)
                        let senders = try self.decoder.decode([Sender].self, from: chat.senders!)
                        let realChat = Chat(senders: senders, chatBody: body)
                        realChats[body.chatId] = realChat
                    }
                    catch (let error)
                    {
                        print(error)
                        
                    }
                    
                }
                
                
                return realChats
            }
            
            
            
        }
        
        return nil
    }
    
    
    func getContacts() -> [String:Contact]?{
        let context =  self.backgroundContext
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate =  NSPredicate(format: "loginUser = %@", login!)
        
        do{
            let _contact = Contacts(context: context)
            _contact.login = login
            
            
            let user = try context.fetch(fetchRequest).first
            
            guard let curUser = user else {
                return nil
            }
            
            let _contacts = curUser.contacts?.allObjects as? [Contacts]
            guard let contacts = _contacts else {
                return nil
            }
            
            var curContacts = [String:Contact]()
            
            
            for contact in contacts {
                let newContact = Contact(with: contact.login!, name: contact.login!, surname: nil)
                curContacts[contact.login!] = newContact
            }
            
            
            return curContacts
            
            
        }catch (let error){
            print(error)
            
            return nil
        }
        
    }
    
    func addContact(contact : Contact){
        self.backQueue.async(flags: .barrier, execute: {  [weak self] in
            guard let self = self else {return}
            
            let context =  self.backgroundContext
            
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate =  NSPredicate(format: "loginUser = %@", self.login!)
            
            
            do{
                let _contact = Contacts(context: context)
                _contact.login = contact.login
                
                let users = try context.fetch(fetchRequest)
                if let user = users.first(where: {$0.loginUser == self.login})
                {
                    
                    _contact.addToUser(user)
                    
                    do{
                        
                        try context.save()
                    }
                    catch (let error)
                    {
                        print(error)
                        
                    }
                    
                }
                
                
                
            }catch (let error){
                print(error)
                
                return
            }
        })
    }
    
    func addMessages(messages : ChatBody){
        
        self.backQueue.async(flags: .barrier, execute: {  [weak self] in
            guard let self = self else {return}
            let context = self.backgroundContext
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate =  NSPredicate(format: "loginUser = %@", self.login!)
            
            
            do{
                let users = try context.fetch(fetchRequest)
                if let user = users.first(where: {$0.loginUser == self.login})
                {
                    let _chats = user.chats?.allObjects as? [Chats]
                    guard let chats = _chats else {
                        return
                    }
                    
                    guard let chat = chats.first(where: {$0.id! == messages.chatId}) else {
                        return
                    }
                    
                    var chatMessages = try self.decoder.decode(ChatBody.self, from: chat.body!)
                    chatMessages.messages.append(contentsOf: messages.messages)
                    
                    let data = try self.encoder.encode(chatMessages)
                    
                    chat.body = data
                    
                    
                    do{
                        
                        try context.save()
                    }
                    catch (let error)
                    {
                        print(error)
                        
                    }
                    
                    
                }
                
                
                
            }catch (let error){
                print(error)
                
                return
            }
            
        })
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
