//
//  SettingCellModel.swift
//  CourseworkChat
//
//  Created by Admin on 13.05.2021.
//

import Foundation
import UIKit

enum CellType {
    case navigation
    case button
}

struct SettingsOptions {
    let title : String?
    let icon : UIImage?
    let type : CellType
    let handler : (() -> ())?
}

