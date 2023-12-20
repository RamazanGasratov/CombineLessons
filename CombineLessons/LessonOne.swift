//
//  LessonOne.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 20.12.2023.
//

import SwiftUI
import Combine

struct FirstPipelineView: View {
    
    @StateObject var viewModel = FirstPipelineViewModel()
    
    var body: some View {
        HStack {
            TextField("Ваше имя", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            Text(viewModel.validation)
        }
        .padding()
    }
}

final class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var validation = ""
    
    init() {
        $name
            .map { $0.isEmpty ? "Пустой" : "Заполнено" }
            .assign(to: &$validation)
    }
}

#Preview {
    FirstPipelineView()
}
