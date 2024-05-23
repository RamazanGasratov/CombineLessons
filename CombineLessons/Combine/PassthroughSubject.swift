//
//  PassthroughSubject.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 23.05.2024.
//

import Foundation
import SwiftUI
import Combine

struct PassthroughSubject_Intro: View {
    @StateObject private var vm = PassthroughSubjectViewModel()
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                TextField("credit card number", text: $vm.creditCard)
                Group {
                    switch (vm.status) {
                    case .ok:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    case .invalid:
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                    default:
                        EmptyView()
                    }
                }            }
            .padding()
            Button("Verify CC Number") {
                vm.verifyCreditCard.send(vm.creditCard)
            }
        }
        .font(.title)
    }
}
enum CreditCardStatus {
    case ok
    case invalid
    case notEvaluated
}

class PassthroughSubjectViewModel: ObservableObject {
    @Published var creditCard = ""
    @Published var status = CreditCardStatus.notEvaluated
    let verifyCreditCard = PassthroughSubject<String, Never>()
    init() {
        verifyCreditCard
            .map{ creditCard -> CreditCardStatus in
                if creditCard.count == 16 {
                    return CreditCardStatus.ok
                } else {
                    return CreditCardStatus.invalid
                }
            }            .assign(to: &$status)
    }
}
