//
//  Just.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 20.05.2024.
//

import SwiftUI


/*
 Использование Just publisher может превратить любую переменную в издателя. Он возьмет любое значение, которое у вас есть, и отправит его через трубопровод, который вы прикрепите к нему один раз, а затем закончите (остановите) трубопровод. («Просто» в данном случае означает «просто, только или не более одного
 
 В Combine, оператор Just используется для создания публикации (publisher), которая немедленно отправляет одно значение и завершает работу. Это полезно для тестирования или простых сценариев, когда вам нужно отправить одно фиксированное значение.

 Основные моменты о Just
 
 Тип: Just является типом структуры (struct), которая соответствует протоколу Publisher.
 Значение: Just отправляет одно значение, которое вы передаете при создании.
 Завершение: После отправки значения, Just завершает поток данных, отправляя событие завершения (completion).
 Ошибки: Just никогда не отправляет ошибки; он всегда завершает поток с успешным завершением.
 */


//struct Just: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    Just()
//}
import Combine

class Just_IntroductionViewModel: ObservableObject {
    @Published var data = ""
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["Julian", "Meredith", "Luan", "Daniel", "Marina"]
        
        _ = dataIn.publisher
            .sink { [unowned self] (item) in
                dataToView.append(item)
            }
        
        if dataIn.count > 0 {
            Just(dataIn[0])
                .map {
                        $0.uppercased()
                }
                .assign(to: &$data)
        }
    }
}
