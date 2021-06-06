//
//  ContactsService.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import Foundation

class ContactsService{
    private let userManager : UserManager
    private let networkManager : NetworkClient
    private let storageService : StorageService
    private var contactsSource : Dictionary<String,Contact>
    
    var getNewContact : ((_ contact : Contact) -> (Void))?
    
    init(with networkManager : NetworkClient,userManager : UserManager,storageService : StorageService) {
        self.networkManager = networkManager
        self.userManager = userManager
        self.storageService = storageService
        
        
        let contacts = storageService.getContacts()
        if let contacts = contacts{
            self.contactsSource = contacts
        }
        else
        {
            self.contactsSource = Dictionary<String,Contact>()
        }
        
        registerNotifications()
    }
    
    func getContacts() -> [Contact] {
        return Array(contactsSource.values)
    }
    
    func getContact(by login:String) -> Contact?{
        return contactsSource[login]
    }
    
    func addNewContact(login : String){
        do {
            let user = userManager.getUserInfo()
            let localLogin = user?["Login"] as! String
            let contact = Contact(with: localLogin, name: nil, surname: nil)
            try networkManager.send(message: .newContact(login: login, contact: contact))
            
        } catch (let error) {
            print(error)
        }
    }
    
    private func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewContactNotification), name: .newContact, object: nil)
    }
    
    private func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: .newContact, object: nil)
    }
    
    @objc private func handleNewContactNotification(notification: NSNotification){
        
        if let contact = notification.object as? Contact {
            DispatchQueue.global().async(flags: .barrier, execute: { [self] in
                let login = contact.login
                contactsSource[login] = contact
            })
            self.getNewContact?(contact)
    
            self.storageService.addContact(contact: contact)
        
        }
        
        
        
        
        
    }
    
    deinit {
        removeNotifications()
    }
}
