//
//  RegistrationModel.swift
//  CourseworkChat
//
//  Created by Admin on 25.05.2021.
//

import Foundation
import RxSwift

struct RegistrationInput {
    let next : AnyObserver<Void>
    let text : AnyObserver<String>
}

struct RegistrationOutput {
    let nextShow : Observable<Void>
    let isSuccess : Observable<Bool>
}


protocol RegistrationViewModelType  {
    
    typealias Input = RegistrationInput
    typealias Output = RegistrationOutput
    
    var input: Input { get }
    var output : Output { get }
}
