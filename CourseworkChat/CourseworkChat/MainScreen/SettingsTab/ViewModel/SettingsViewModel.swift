//
//  SettingsViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 28.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel : ViewModelType {
    
    var input: Input
    var output: Output
    let sessionService : SessionService
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let sections : AnyObserver<[Section]>
        let selected : AnyObserver<SettingsOptions>
    }
    
    struct Output {
        let sections : Driver<[Section]>
        let nickName : String
    }
    
    private let sectionsSubject = PublishSubject<[Section]>()
    private let selectedSubject = PublishSubject<SettingsOptions>()
    
    init(with sessionService : SessionService) {
        self.sessionService = sessionService
        
        self.input = Input(sections: sectionsSubject.asObserver(), selected: selectedSubject.asObserver())
        
        let nickname = sessionService.userManager.getUserInfo()!["Login"] as! String
        self.output = Output(sections: sectionsSubject.asDriver(onErrorJustReturn: []), nickName: nickname)
        
        self.selectedSubject.asObservable().subscribe(onNext: { option in
            if  (option.handler != nil){
                option.handler!()
            }
        }).disposed(by: disposeBag)
    }
    
    
    func configure(){
        let sections = [Section(title: "",
                                items: [SettingsOptions(title: "Edit profile", icon: UIImage(systemName: "person"), type: .navigation, handler: nil)]),
                        Section(title: "", items: [SettingsOptions(title: "About app", icon: UIImage(systemName: "questionmark.circle"), type: .navigation, handler: nil)]),
                        Section(title: "", items: [SettingsOptions(title: "Log out", icon: nil, type: .button, handler: { [weak self] in
                            guard let self = self else {return}
                            self.sessionService.logOut()
                        })])
        ]
        
        sectionsSubject.onNext(sections)
        sectionsSubject.onCompleted()
    }
    
}
