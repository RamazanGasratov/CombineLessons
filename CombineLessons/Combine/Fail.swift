//
//  Fail.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 13.05.2024.
//

import SwiftUI
import Combine

/* Издатель, который немедленно завершает работу с указанной ошибкой.

 Когда использовать FailPublisher:
 Когда вам нужно выдать одну ошибку.
 Когда вам нужно отобразить неудачное завершение операции.
 Когда вам нужно обрабатывать ошибки в конвейере издателя.
 */

class Validators {
    static func validAgePublisher(age: Int) -> AnyPublisher<Int, InvalidAgeError> {        
        if age < 0 {
            return Fail(error: InvalidAgeError.lessZero)                
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreHundred)
                .eraseToAnyPublisher()
        }
        return Just(age)
            .setFailureType(to: InvalidAgeError.self)
            .eraseToAnyPublisher()
    }
}

class Fail_IntroViewModel: ObservableObject {
    @Published var age = 0
    @Published var error: InvalidAgeError?
    func save(age: Int) {
        _ = Validators.validAgePublisher(age: age)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.error = error                }
            } receiveValue: { [unowned self] age in
                self.age = age
            }
    }
}

