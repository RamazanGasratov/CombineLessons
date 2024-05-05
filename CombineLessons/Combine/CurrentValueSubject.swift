//
//  CurrentValueSubject.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 05.05.2024.
//

import SwiftUI
import Combine

/* CurrentValueSubject
- Значение устанавливается.
- Выполняется пайплайн.
- UI уведомляется о изменениях (используя objectWillChange.send()).
 
 
@Published
- Выполняется пайплайн.
- Значение устанавливается.
- UI автоматически уведомляется о изменениях.
 
Эти две колонки показывают различие в порядке действий при изменении значения и механизме уведомления пользовательского интерфейса. CurrentValueSubject требует явной отправки уведомления об изменениях, в то время как @Published делает это автоматически.
 */

final class CurrentValueSubjectViewModel: ObservableObject {
//    var selection = CurrentValueSubject<String, Never>("No Name Selected")
    @Published var selection = "No Name Selected"
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    var cancellables: [AnyCancellable] = []
    
    init() {
        $selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection /*.value*/ {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

struct CurrentValueSubject_Intro: View {
    @StateObject private var vm = CurrentValueSubjectViewModel()
    
    var body: some View {
        VStack {
            Button("Select Lorenzo") {
                vm.selection = "Lorenzo"
            }
            
            Button("Select Ellen") {
                vm.selection = "Ellen"
            }
            
            Text(vm.selection)
                .foregroundColor(vm.selectionSame.value ? .red : .green)
        }
        .font(.title)
    }
}

#Preview {
    CurrentValueSubject_Intro()
}
