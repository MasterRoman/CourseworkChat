//
//  UserManager.swift
//  CourseworkChat
//
//  Created by Admin on 24.05.2021.
//

import Foundation

class UserManager {
    
    init() {
        
    }
    
    func checkUserRegistration(login : String,password : String) ->Bool{
        if ((UserDefaults.standard.object(forKey: "Users")) != nil){
            var users : Array<Dictionary> = UserDefaults.standard.object(forKey: "Users") as! Array<Dictionary<String, Any>>
            for i in 0..<users.count {
                let user : Dictionary = users[i] as Dictionary<String, Any>
                if ((user["Login"] as! String == login) && (user["Password"] as! String == password)){
                    users[i]["IsActive"] = true
                    UserDefaults.standard.set(users, forKey: "Users")
                    return true
                }
            }
        }
        return false
    }
    
    func registerUser(login : String,password : String,isActive : Bool){
        if ((UserDefaults.standard.object(forKey: "Users")) != nil){
            var users : Array = UserDefaults.standard.object(forKey: "Users") as! Array<Any>
            let user = ["Login": login, "Password":password, "IsActive": isActive] as [String : Any]
            users.append(user)
            UserDefaults.standard.set(users, forKey: "Users")
        }
        else {
            let user = ["Login": login, "Password":password,"IsActive": isActive] as [String : Any]
            let users = Array(arrayLiteral: user)
            UserDefaults.standard.set(users, forKey: "Users")
            
        }
        
    }
    
    func checkUserStatus()->Bool{
        if ((UserDefaults.standard.object(forKey: "Users")) != nil){
            let users : Array<Dictionary> = UserDefaults.standard.object(forKey: "Users") as! Array<Dictionary<String, Any>>
            for user in users{
                let localStatus : Bool = user["IsActive"] as! Bool
                if (localStatus){
                    return true
                }
            }
        }
        return false
    }
    
    func getUserInfo()->Dictionary<String,Any>?{
        if ((UserDefaults.standard.object(forKey: "Users")) != nil){
            let users : Array<Dictionary> = UserDefaults.standard.object(forKey: "Users") as! Array<Dictionary<String, Any>>
            for user in users{
                let localStatus : Bool = user["IsActive"] as! Bool
                if (localStatus){
                    return user
                }
            }
        }
        return nil
    }
    
    func getLogin() -> String{
        if ((UserDefaults.standard.object(forKey: "Users")) != nil){
            let users : Array<Dictionary> = UserDefaults.standard.object(forKey: "Users") as! Array<Dictionary<String, Any>>
            for user in users{
                let localStatus : Bool = user["IsActive"] as! Bool
                if (localStatus){
                    return user["Login"] as! String
                }
            }
        }
        return ""
    }
    
    
    func logOut(){
        if ((UserDefaults.standard.object(forKey: "Users")) != nil){
            var users : Array<Dictionary> = UserDefaults.standard.object(forKey: "Users") as! Array<Dictionary<String, Any>>
            for i in 0..<users.count {
                if (users[i]["IsActive"] as! Bool){
                    users[i]["IsActive"] = false
                    UserDefaults.standard.set(users, forKey: "Users")
                }
            }
        }
    }
    
    
}

