//
//  URLSession.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 31.05.2024.
//

import Foundation
import SwiftUI
import Combine
/*
 Если вам нужно получить данные с URL-адреса, то URLSession - это объект, который вы хотите использовать. У него есть DataTaskPublisher, который на самом деле является издателем, что означает, что вы можете отправить результаты вызова URL API в конвейере, обработать его и в конечном итоге назначить результаты свойству.
 
  URLSession - это объект, который вы используете для:
  • Загрузки данных с конечной точки URL
  • Обновление данных с конечной точки URL
  • Выполнение фоновых загрузок, когда ваше приложение не запущено
  • Координация нескольких задач
  
  
  URLSession.shared
  
  Отлично подходит для простых задач, таких как получение данных из URL в память.
  Нельзя получать данные поэтапно по мере их поступления с сервера.
  Нельзя настроить поведение подключения.
  Ваши возможности по выполнению аутентификации ограничены.
  Нельзя выполнять загрузки или выгрузки в фоновом режиме, когда ваше приложение не работает.
  Нельзя настраивать кэширование, хранение куки или учетных данных.
  
  let configuration = URLSessionConfiguration.default
  let session = URLSession(configuration: configuration)
  
  Вы можете изменить время ожидания по умолчанию для запроса и ответа.
  Вы можете заставить сессию ждать установления подключения.
  Вы можете запретить вашему приложению использовать сотовую сеть.
  Добавлять дополнительные HTTP-заголовки ко всем запросам.
  Настраивать политики куки, безопасности и кэширования.
  Поддерживать фоновую передачу данных.
  */

struct CatFact: Decodable {
    let _id: String
    let text: String
}

struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title: String
    let message: String
}


struct UrlDataTaskPublisher_Intro: View {
    
    @StateObject private var vm = UrlDataTaskPublisher_IntroViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            List(vm.dataToView, id: \._id) { catFact in
                
                Text(catFact.text)
            }
            .font(.title3)
        }        .font(.title)
            .onAppear {
                vm.fetch()
            }
            .alert(item: $vm.error) { error in
                Alert(title: Text(error.title),
                      message: Text(error.message))
            }
    }
}

#Preview {
    UrlDataTaskPublisher_Intro()
}

final class UrlDataTaskPublisher_IntroViewModel: ObservableObject {
    @Published var dataToView: [CatFact] = []
    @Published var error : ErrorForAlert?
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        let url = URL(string: "https://cat-fact.herokuapp.com/facts")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data: Data, response: URLResponse) in
                data
            }
            .decode(type: [CatFact].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    self.error = ErrorForAlert(title: "Ошибка", message: "что то пошло не так")
                }
                
                print(completion)
            }) { [ unowned self ] result  in
                dataToView = result
            }
            .store(in: &cancellables)
    }
}


