//
//  ChatsViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 17.05.2021.
//

import Foundation
import RxSwift

class ChatsViewModel {
    
    let selected : AnyObserver<IndexPath>
    let selectedhShow : Observable<IndexPath>
    
    private let selectedCell = PublishSubject<IndexPath>()
    
    init() {
        selected = selectedCell.asObserver()
        selectedhShow = selectedCell.asObservable()
    }
}
