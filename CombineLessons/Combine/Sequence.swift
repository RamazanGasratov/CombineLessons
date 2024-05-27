//
//  Sequence.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 27.05.2024.
//

import SwiftUI
import Combine

/*
 Есть типы в Swift,
 у них есть встроенные издатели.

Sequence - отправляет элементы коллекции по конвейеру по одному.
 
 Как только все товары будут отправлены через трубопровод, он
 заканчивается.
 Больше никаких предметов не будет, даже если вы добавите больше
 предметов в коллекцию позже.
 */

#Preview {
    Sequence_Intro()
}

struct Sequence_Intro: View {
    
    @StateObject private var vm = SequenceIntroViewModel()
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            List(vm.dataToView, id: \.self) { datum in                Text(datum)
            }
        }
        .font(.title)
        .onAppear {
            vm.fetch()
        }
    }
}

class SequenceIntroViewModel: ObservableObject {
    
    @Published var dataToView: [String] = []
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        var dataIn = ["Paul", "Lem", "Scott", "Chris", "Kaya",
        "Mark", "Adam", "Jared"
        ]
        
        //Process values
        dataIn.publisher
            .sink { (completion) in
                print(completion)
            } receiveValue: { [unowned self] datum in
                self.dataToView.append(datum)
                print(datum)
            }
            .store(in: &cancellables)
        
        // These values will Not go through the pipeline
        // The pipeline finishes after publishing the initial set
        dataIn.append(contentsOf: ["Rod", "Sean", "Karin"])
    }
}

/*
 1. import Combine
 Этот импорт необходим для использования Combine framework, который предоставляет функциональность реактивного программирования.

 2. class SequenceIntroViewModel: ObservableObject
 Объявление класса SequenceIntroViewModel, который наследуется от ObservableObject. Это позволяет использовать этот класс с SwiftUI для автоматического отслеживания изменений в его свойствах.

 3. @Published var dataToView: [String] = []
 Аннотация @Published делает свойство dataToView наблюдаемым. Это означает, что любые изменения этого свойства будут автоматически отслеживаться подписчиками.

 4. var cancellables: Set<AnyCancellable> = []
 Переменная cancellables хранит набор подписок (cancellables), которые будут автоматически отменены, когда SequenceIntroViewModel будет деинициализирован. Это помогает управлять жизненным циклом подписок и предотвращать утечки памяти.

 5. func fetch()
 Метод fetch используется для получения данных и обработки их с помощью Combine.

 6. var dataIn = ["Paul", "Lem", "Scott", "Chris", "Kaya", "Mark", "Adam", "Jared"]
 Создание массива dataIn, содержащего строки с именами.

 7. dataIn.publisher
 Создание издателя (publisher) из массива dataIn. Это позволяет использовать Combine для обработки значений массива как потока событий.

 8. .sink { (completion) in print(completion) } receiveValue: { [unowned self] datum in self.dataToView.append(datum) print(datum) }
 Подписка на издателя с помощью оператора sink. sink имеет два замыкания:

 Первое замыкание (completion) вызывается при завершении потока данных и просто выводит состояние завершения.
 Второе замыкание (receiveValue) вызывается каждый раз, когда издатель отправляет новое значение. Здесь значение добавляется в dataToView, а затем выводится в консоль. Использование [unowned self] предотвращает создание сильной ссылки на self внутри замыкания, что помогает избежать циклов удержания (retain cycles).
 9. .store(in: &cancellables)
 Сохранение подписки в cancellables, чтобы обеспечить её автоматическое отмену при деинициализации SequenceIntroViewModel.

 10. dataIn.append(contentsOf: ["Rod", "Sean", "Karin"])
 Добавление дополнительных значений в массив dataIn после создания издателя. Эти значения не будут обработаны через Combine pipeline, так как они добавлены после того, как издатель уже выполнил публикацию первоначального набора данных.

 Итог
 */
