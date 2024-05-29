//
//  Timer.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 29.05.2024.
//

import SwiftUI
import Combine

/*
 Издатель Timer неоднократно публикует текущую дату и время с указанным вами интервалом. Таким образом, вы можете настроить публикацию текущей даты и времени каждые 5 секунд или каждую минуту и т. д.
 
 Вы не обязательно можете использовать опубликованную дату и время, но вы можете прикрепить операторов для запуска некоторого кода с интервалом, который вы указываете с помощью этого издателя.
 */

struct Timer_Intro: View {
    @StateObject var vm = TimerIntroViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Slider(value: $vm.interval, in: 0.1...1,                  
                   minimumValueLabel: Image(systemName: "hare"),
                   maximumValueLabel:
                    Image(systemName: "tortoise"),                   
                   label: { Text("Interval") })
            .padding(.horizontal)
            List(vm.data, id: \.self) { datum in               
                Text(datum)
                .font(.system(.title, design: .monospaced))
            }
        }
        .font(.title)
        .onAppear {
            vm.start()
        }
    }
}


//#Preview {
//    Timer_Intro()
//}


class TimerIntroViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var interval: Double = 1
    private var timerCancellable: AnyCancellable?
    private var intervalCancellable: AnyCancellable?
    
    let timerFormatter = DateFormatter()
    
    init() {
        timerFormatter.dateFormat = "HH:mm:ss.SSS"
        
        intervalCancellable = $interval
            .dropFirst()
            .sink { [unowned self] interval in
                timerCancellable?.cancel()
                data.removeAll()
                start()
            }
        
    }
    
    func start() {
        timerCancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [unowned self] (datum) in
                data.append(timerFormatter.string(from: datum))
            }
    }
}

/*
 Форматер для таймера:

 swift
 Копировать код
 let timerFormatter = DateFormatter()
 Этот форматер будет использоваться для форматирования текущего времени в строку.

 Инициализация
 Инициализатор:
 swift
 Копировать код
 init() {
     timerFormatter.dateFormat = "HH:mm:ss.SSS"
     
     intervalCancellable = $interval
         .dropFirst()
         .sink { [unowned self] interval in
             timerCancellable?.cancel()
             data.removeAll()
             start()
         }
 }
 Устанавливаем формат для timerFormatter.
 Создаем подписку на изменения свойства interval. Используем dropFirst(), чтобы пропустить первое значение (так как нам не нужно действовать на начальное значение).
 Внутри подписки мы:
 Отменяем предыдущую подписку на таймер (если она существует).
 Очищаем массив data.
 Вызываем метод start() для запуска нового таймера.
 Метод Start
 Метод start:
 swift
 Копировать код
 func start() {
     timerCancellable = Timer
         .publish(every: interval, on: .main, in: .common)
         .autoconnect()
         .sink { [unowned self] (datum) in
             data.append(timerFormatter.string(from: datum))
         }
 }
 Создаем и запускаем таймер, который публикует текущее время с заданным интервалом (interval).
 autoconnect() автоматически подключает таймер к текущему RunLoop.
 sink создает подписку, которая добавляет отформатированное текущее время в массив data.
 Пояснение по поводу unowned self
 Использование [unowned self] в замыканиях предотвращает создание сильных циклических ссылок, которые могут привести к утечкам памяти. Это говорит о том, что внутри замыкания мы используем self как слабую ссылку, чтобы избежать удержания экземпляра класса ViewModel.

 Итог
 Публикуемые свойства (data и interval) используются для уведомления подписанных представлений об изменениях.
 Подписка на изменения interval позволяет динамически изменять интервал таймера.
 Метод start запускает таймер, который обновляет data с заданным интервалом.
 Форматирование времени осуществляется с помощью DateFormatter.
 Этот ViewModel позволяет обновлять массив строк (data) с текущим временем через заданные интервалы, и автоматически адаптируется при изменении интервала таймера.
 */

struct Timer_Connect: View {
    @StateObject private var vm = Timer_ConnectViewModel()
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Button("Connect") {
                    vm.start()
                }
                .frame(maxWidth: .infinity)
                Button("Stop") { vm.stop()
                }
                .frame(maxWidth: .infinity)
            }
            List(vm.data, id: \.self) { datum in
                Text(datum)
                    .font(.system(.title, design: .monospaced))
            }
        }
        .font(.title)
    }
}

class Timer_ConnectViewModel: ObservableObject {
    @Published var data: [String] = []
    private var timerPublisher = Timer.publish(every: 0.2, on: .main, in: .common)
    private var timerCancellable: Cancellable?
    private var cancellables: Set<AnyCancellable> = []
    let timeFormatter = DateFormatter()
    
    init() {
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        timerPublisher
            .sink { [unowned self] (datum) in
                data.append(timeFormatter.string(from: datum))
            }
            .store(in: &cancellables)
    }       
    func start() {
        timerCancellable = timerPublisher.connect()
    }        
    func stop() {
        timerCancellable?.cancel()
        data.removeAll()
    }
}

#Preview {
    Timer_Connect()
}
