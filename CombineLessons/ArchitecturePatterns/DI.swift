//
//  DI.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 03.06.2024.
//

import SwiftUI
import Combine

// Problem with singletons
// 1. Singleton's are GLOBAL
// 2. Can't customize the init!
// 3. Can't swap out service

struct PostsModel: Identifiable ,Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class ProductionDataService {
    
    let url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class DependencyInjectionViewModel: ObservableObject {
    
    @Published var dataArray: [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService: ProductionDataService
    
    init(dataService: ProductionDataService) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnPosts in
                self?.dataArray = returnPosts
            }
            .store(in: &cancellables)
    }
}

struct DIInjectView: View {
    @StateObject private var vm: DependencyInjectionViewModel
    
    init(dataService: ProductionDataService) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}


struct DIInjectView_Prevews: PreviewProvider {
    
    static let dataService = ProductionDataService()
    
    static var previews: some View {
        DIInjectView(dataService: dataService)
    }
}
