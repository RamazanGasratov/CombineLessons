//
//  Contains.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 17.06.2024.
//

import SwiftUI
import Combine

/*
 Оператор содержит только одну цель - сообщить вам, соответствует ли элемент, проходящий через ваш конвейер, указанным вами критериям.
 Он опубликует true, когда будет найдено совпадение, а затем завершит конвейер, что означает, что он остановит поток любых оставшихся данных.
 Если никакие значения не соответствуют критериям, то публикуется false, и конвейер завершается/закрывается.
 */

struct Contains_Intro: View {
    @StateObject private var vm = Contains_IntroViewModel()
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("House Details")
                .fontWeight(.bold)
            Group {
                Text(vm.description)
                Toggle("Basement", isOn: $vm.basement)
                Toggle("Air Conditioning", isOn: $vm.airconditioning)
                Toggle("Heating", isOn: $vm.heating)
            }
            .padding(.horizontal)
        }
        .font(.title)
        .onAppear {
            vm.fetch()
        }
    }
}

#Preview {
    Contains_Intro()
}

class Contains_IntroViewModel: ObservableObject {
    @Published var description = ""
    @Published var airconditioning = false
    @Published var heating = false
    @Published var basement = false
    
    private var cancellables: [AnyCancellable] = []
    
    func fetch() {
        let incomingData = ["3 bedrooms", "2 bathrooms", "Heating", "Basement"]
        
        incomingData.publisher
            .prefix(2)
            .sink { [unowned self] item in
                description += item + "\n"
            }
            .store(in: &cancellables)
        
        incomingData.publisher
            .contains("Air conditioning")
            .assign(to: &$airconditioning)
        
        incomingData.publisher
            .contains("Heating")
            .assign(to: &$heating)
        
        incomingData.publisher
            .contains("Basement")
            .assign(to: &$basement)
    }
}
