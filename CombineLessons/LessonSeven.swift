//
//  LessonSeven.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 09.01.2024.
//

import SwiftUI
import Combine

struct FeaturePublisherView: View {
    @StateObject var viewModel = FuturePublisherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.firstResult)
            
            Button("Запуск") {
                viewModel.fetch()
            }
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

class FuturePublisherViewModel: ObservableObject {
    @Published var firstResult = ""

    var cancellable: AnyCancellable?
    
    func createFeatch(url: URL) -> AnyPublisher<String?, Error> {
        
        Future { promise in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                promise(.success(response?.url?.absoluteString ?? ""))
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
    
    func fetch() {
        guard let url = URL(string: "https://google.com") else { return }
       cancellable = createFeatch(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] value in
                firstResult = value ?? ""
            }
    }
}


#Preview {
    FeaturePublisherView()
}
