//
//  LessonFour.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 27.12.2023.
//

import SwiftUI
import Combine

/// @Publisher                                                     CurrentValueSubject
///  1. Запускает pipeline                                   1. Устанавливает значение
///  2. Устанавливает значение                       2. Запускает pipeline
///  3. UI автомат                                               3. UI update через objectWillChange.send()

struct CurentValueSubjectView: View {
    @StateObject private var viewModel = CurentValueSubjectViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.selectionSame.value ? "Два раза выбрали" : "") \(viewModel.selection.value)")
                .foregroundColor(viewModel.selectionSame.value ? .red : .green)
            
            Button("Выбрать колу") {
                viewModel.selection.value = "Кола"
            }
            .padding()
            
            Button("Выбрать бургер") {
                viewModel.selection.send("Бургер")
            }
            .padding()
        }
    }
}

class CurentValueSubjectViewModel: ObservableObject {
     var selection = CurrentValueSubject<String, Never>("Корзина пуста")
     var selectionSame = CurrentValueSubject<Bool, Never>(false)
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                self.selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
}

#Preview {
    CurentValueSubjectView()
}
