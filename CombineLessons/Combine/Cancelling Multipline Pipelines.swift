//
//  Cancelling Multipline Pipelines.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 22.04.2024.
//

import SwiftUI
import Combine

class CancellingMultiplePipelinesViewModel2: ObservableObject {    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancellable: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map { $0.isEmpty ? "крест" : "галка"}
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellable)
        
        $lastName
            .map { $0.isEmpty ? "крест" : "галка"}
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellable)
    }
    
    func cancelAllValidations() {
        validationCancellable.removeAll()
    }
}
struct Cancelling_Multipline_Pipelines: View {
    @StateObject var vm = CancellingMultiplePipelinesViewModel2()
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    TextField("first name", text: $vm.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(vm.firstNameValidation)
                }
                
                HStack {
                    TextField("last name", text: $vm.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(vm.lastNameValidation)
                }
            }
            .padding()
            
            Button("Cancel All Validation") {
                vm.cancelAllValidations()
            }
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Cancelling_Multipline_Pipelines()
}
