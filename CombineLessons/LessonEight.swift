//
//  LessonEight.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 10.01.2024.
//

import SwiftUI
import Combine

struct JustSequensView: View {
    @StateObject var viewModel = JustSequensViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.title)
                .bold()
            
            Form {
                Section(header: Text("Учатсники конкурса").padding()) {
                    List(viewModel.dataToView, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

class JustSequensViewModel: ObservableObject {
    @Published var title = ""
    @Published var dataToView: [String] = []
    
    var names = ["Julia", "Jack", "Marina"] // - источник данных может приходить из интернета
    
    func fetch() {
        _ = names.publisher
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [unowned self] value in
                dataToView.append(value)
                print(value)
            })
       
        if names.count > 0 {
            Just(names[1])
                .map { item in
                    item.uppercased()
                }
                .assign(to: &$title)
        }
    }
}

#Preview {
    JustSequensView()
}
