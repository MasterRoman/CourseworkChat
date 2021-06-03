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
    let back : AnyObserver<Void>
}

struct RegistrationOutput {
    let nextShow : Observable<Void>
    let isSuccess : Observable<Bool>
    let back : Observable<Void>
}


protocol RegistrationViewModelType  {
    
    typealias Input = RegistrationInput
    typealias Output = RegistrationOutput
    
    var input: Input { get }
    var output : Output { get }
}
