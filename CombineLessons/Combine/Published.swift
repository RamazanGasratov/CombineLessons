//
//  Published.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 15.04.2024.
//

import SwiftUI
import Combine

class YourFirstPipelineViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var validation: String = ""
    
    init() {
        $name
            .map {
                print("name  property is now: \(self.name)")
                print("Value recevied is \($0)")
                
                return $0.isEmpty ? "крест" : "green"
            }
            .assign(to: &$validation)
        // Create pipeline here
 }
}

struct PublishedView: View {
    @StateObject private var vm = YourFirstPipelineViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("name", text: $vm.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(vm.validation)
            }
            .padding()
        }
        .font(.title)
    }
}

#Preview {
    PublishedView()
}
