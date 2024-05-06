//
//  SearchTest.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 05.05.2024.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack {
                    
                    VStack {
                        SearchBar(text: $viewModel.searchText, isEditing: .constant(true)) {
                            
                        }
                        
                        
                        ForEach(viewModel.suggestions) { suggestion in
                            Text(suggestion.title)
                        }
                        
                        .listStyle(.plain)
                    }
                    
                    if viewModel.falseView {
                        PopularCategoriesView()
                    }
                }
                .navigationBarTitle("Search")
            }
        }
    }
}


#Preview {
    SearchView()
}

struct SearchSuggestion: Identifiable {
    var id: UUID = UUID()
    var title: String
}

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var suggestions: [SearchSuggestion] = []
    @Published var falseView: Bool = false

    private var allSuggestions: [SearchSuggestion] = [
        SearchSuggestion(title: "Яблоко"),
        SearchSuggestion(title: "Банан"),
        SearchSuggestion(title: "Вишня")
    ]

    private var cancellables: Set<AnyCancellable> = []

    init() {
           $searchText
               .removeDuplicates()
               .debounce(for: 0.3, scheduler: RunLoop.main)
               .map { [weak self] searchText -> [SearchSuggestion] in
                   guard let self = self else { return [] }
                   // Обновляем значение falseView в зависимости от длины текста
                   self.falseView = searchText.count < 3

                   // Возвращаем результат фильтрации
                   return self.filterSuggestions(for: searchText)
               }
               .assign(to: \.suggestions, on: self)
               .store(in: &cancellables)
       }

    private func filterSuggestions(for query: String) -> [SearchSuggestion] {
           if query.isEmpty {
               // Если запрос пуст, устанавливаем falseView в false, так как список подсказок тоже будет пуст
               self.falseView = true
               return []
           }
           let filtered = allSuggestions.filter { $0.title.lowercased().contains(query.lowercased()) }
           // Устанавливаем falseView в false, если нет подходящих предложений, иначе в true
           self.falseView = filtered.isEmpty
           return filtered
       }
}


struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    var onCommit: () -> Void
    
    var body: some View {
        Group {
            HStack {
                TextField("Поиск...", text: $text, onCommit: {
                    onCommit()
                })
                .font(.title)
                    .accentColor(Color.red)
                    .padding(9)
                    .background(Color.gray)
                    .cornerRadius(10)
                
                    .overlay(HStack {
                        
                        Spacer()
                        
                        if isEditing == true {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    })
                    .padding(.horizontal, 10)
                
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing == true {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Отмена")
                            .font(.headline)
                            .foregroundColor(.red)
                    }.padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                }
            }
        }
    }
}



struct PopularCategoriesView: View {
    
    private let gridItemLayout: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    private var data: [PopularCategoriesModel] = [
        PopularCategoriesModel(text: "Одежда", imageName: "category1"),
        PopularCategoriesModel(text: "Обувь", imageName: "category2"),
        PopularCategoriesModel(text: "Аксессуары", imageName: "category3"),
        PopularCategoriesModel(text: "Техника", imageName: "category4"),
        PopularCategoriesModel(text: "Автотовары", imageName: "category5"),
        PopularCategoriesModel(text: "Косметика", imageName: "category6"),
        PopularCategoriesModel(text: "Зоотовары", imageName: "category7"),
        PopularCategoriesModel(text: "Спорт", imageName: "category8"),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Популярные категории")
                .foregroundColor(Color.black)
                .font(.subheadline)
    
            LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                
                ForEach(data, id: \.id) { categ in
                    Image(categ.imageName)
                        .resizable()
                        .frame(width: 170, height: 170)
                        .overlay(
                            Text(categ.text)
                                .padding(1)
                                .foregroundColor(Color.black)
                                .font(.headline)
                                .offset(x: 10, y: 15),
                            alignment: .topLeading
                        )
                        .background(Color.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct PopularCategoriesModel: Identifiable {
    let id = UUID()
    var text: String
    var imageName: String
}

