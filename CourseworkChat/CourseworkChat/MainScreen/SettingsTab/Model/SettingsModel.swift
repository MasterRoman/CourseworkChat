//
//  SettingsModel.swift
//  CourseworkChat
//
//  Created by Admin on 13.05.2021.
//

import Foundation
import RxDataSources

struct Section  {
    let title : String?
    var items : [SettingsOptions]
}

extension Section : SectionModelType{
 
    init(original: Section, items: [SettingsOptions]) {
        self = original
        self.items = items
    }
    
    typealias Item = SettingsOptions
    

}
