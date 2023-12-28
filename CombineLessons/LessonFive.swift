//
//  LessonFive.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 28.12.2023.
//

import SwiftUI
import Combine

struct EmptyPublishersView: View {
    
    @StateObject private var viewModel = EmptyPublishersViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            .font(.title)
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

class EmptyPublishersViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    
    let datas = ["value1", "value2", nil ,"value4","value5", "value6"]
    
    func fetch() {
        _ = datas.publisher
            .flatMap { item -> AnyPublisher<String, Never> in
                if let item = item {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            }
            .sink { [unowned self] item in
                dataToView.append(item)
            }
    }
}

#Preview {
    EmptyPublishersView()
}
