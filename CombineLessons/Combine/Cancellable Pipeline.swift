//
//  Cancellable Pipeline.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 16.04.2024.
//

import SwiftUI
import Combine

class FirstPipelineUsingSinkViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var validation: String = ""
    var cancellable: AnyCancellable?
    
    init() {
        _ = $name
            .map { $0.isEmpty ? "крест" : "green" }
            .sink { [unowned self] value in
                self.validation = value
            }
    }
}

struct Cancellable_Pipeline: View {
    @StateObject private var vm = FirstPipelineUsingSinkViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("name", text: $vm.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(vm.validation)
            }
            .padding()
            
            Button("Cance Subscription") {
                vm.validation = ""
                vm.cancellable?.cancel()
            }
        }
        .font(.title)
    }

}

#Preview {
    Cancellable_Pipeline()
}

