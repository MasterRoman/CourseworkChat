//
//  ContactCellViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import Foundation
import UIKit

class ContactCellViewModel{
 
    var icon : UIImage?
    var name : String
    
    init(with login : String,icon : UIImage?) {
        self.icon = icon
        self.name = login
    }
}
