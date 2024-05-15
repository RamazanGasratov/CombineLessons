//
//  Future.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 15.05.2024.
//

import SwiftUI
import Combine

/*
 var futurePublisher: Future<String, Never>
 
 String - тип который перелается по pipeline будушему подписчику
 
 Never - Это ошибка, которая может быть отправлена абоненту, если что-то пойдет не так. Никогда не означает, что абонент не должен ожидать ошибки/сбоя. В противном случае вы можете создать свою собственную пользовательскую ошибку и установить этот тип.
 
 let futurePublisher = Future<String, Never> { promise in
 
 promise(Result.success("hello"))
 }
 
 - Параметр обещания, переданный в замыкание, на самом деле является определением функции. Функция выглядит следующим образом:promise(Result<String, Never>) -> Void Вы хотите вызвать эту функцию в какой-то момент закрытия будущего.
 
 - Что такое результат? Результатом является печисление с двумя случаями: успехом и неудачей. Вы можете присвоить значение каждому из них. Значение является общим, поэтому вы можете назначить им String, Bool, Int или любой другой тип. В этом примере строка назначается успешному делу
 */


#Preview {
    Future_Intro()
}

struct Future_Intro: View {
    @StateObject private var vm = Future_IntroViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
//            Button("Say Hello") {
//                vm.sayHello().sink {  in
//                    <#code#>
//                }
//            }
            Text(vm.title)
                .padding(.bottom)
            Button("Say Goodbye") {
//                vm.sayGoodbye()
            }
//            Text(vm.goodbye)
            Spacer()
        }
        .font(.title)
    }
}

/*
 В этом примере функция sayHello немедленно вернет значение. Функция sayGoodbye будет отложена перед возвратом значения
 */

class Future_IntroViewModel: ObservableObject {
    @Published var title: String = "Starting title"
    let url = URL(string: "https://www.google.com")!
    
    var cancellable = Set<AnyCancellable>() // ??
    
    init() {
        download()
    }
    
    func download() {
//        getCombinePublisher()
        getFuturePublisher()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellable)

        
//        getEscapingClosure { [weak self] returedValue, error in
//            self?.title = returedValue
//        }
    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError>{
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(5, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHendler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHendler("New value2", nil)
        }
        .resume()
    }
    
    func sayHello() -> Future<String, Never> {
      return Future { promise in
        promise(Result.success("Hello world"))
      }
    }
    
    func getFuturePublisher() -> Future<String, Error> {
         Future { promise in
            self.getEscapingClosure { retrunedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(retrunedValue))
                }
            }
        }
    }
    
    func doSimething(completion: @escaping(_ value: String)-> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion("new string")
        }
    }
    
    func doSomethingInTheFeature() -> Future<String, Never> {
        return Future { promise in
            self.doSimething { value in
                promise(.success(value))
            }
        }
    }
}



