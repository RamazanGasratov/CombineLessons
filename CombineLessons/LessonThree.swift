//
//  LessonThree.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 25.12.2023.
//

import SwiftUI
import Combine

struct CancellingMultiplePipelinesView: View {
    
    @StateObject private var viewModel = CancellingMultiplePipelinesViewModel()
    
    var body: some View {
        Group {
            HStack {
                TextField("Name", text: $viewModel.firstName)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.firstNameValidation)
            }
            
            HStack {
                TextField("LastName", text: $viewModel.lastName)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.lastNameValidation)
            }
        }
        .padding()
        
        Button("Отменить все проверки") {
            viewModel.cancellAllValidations()
        }
    }
}

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancellables: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map { $0.isEmpty ? "Пусто" : "Заполненно" }
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $lastName
            .map { $0.isEmpty ? "Пусто" : "Заполненно" }
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func cancellAllValidations() {
        firstNameValidation = ""
        lastNameValidation = ""
        validationCancellables.removeAll()
    }
}

#Preview {
    CancellingMultiplePipelinesView()
}
