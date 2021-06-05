//
//  ViewControllerExtensions.swift
//  CourseworkChat
//
//  Created by Admin on 06.06.2021.
//

import Foundation
import UIKit

extension UIViewController{
    func makeAlert(with message : String) -> UIAlertController{
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okAction)
        return alert
    }
}
