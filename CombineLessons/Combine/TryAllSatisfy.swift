//
//  TryAllSatisfy.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 12.06.2024.
//

import SwiftUI
import Combine

// Оператор tryAllSatisfy работает так же, как allSatisfy, за исключением того, что он также может опубликовать ошибку.

// Таким образом, если все элементы, поступающие через конвейер, соответствуют указанным вами критериям, то будет опубликована истина. Но как только первый элемент не соответствует критериям, публикуется ложь, и конвейер завершается, даже если в конвейере все еще больше элементов. В конечном счете, подписчик получит true, false или ошибку и завершит.

struct TryAllSatisfy_Intro: View {
    
    @State private var number = ""
    @State private var resultVisible = false
    @StateObject private var vm = TryAllSatisfy_IntroViewModel()
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                TextField("add a number < 145", text: $number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Button(action: {
                    vm.add(number: number)
                    number = ""
                },label: { Image(systemName: "plus")
                }
                )
            }
            .padding()
            
            List(vm.numbers, id: \.self) { number in
                
                Text("\(number)")
            }
            Spacer(minLength: 0)
            Button("Fibonacci Numbers?") {
                vm.allFibonacciCheck()
                resultVisible = true
            }
            Text(vm.allFibonacciNumbers ? "Yes" : "No")
                .opacity(resultVisible ? 1 : 0)
        }
        .padding(.bottom)
        .font(.title)
        .alert(item: $vm.invalidNumberError) { error in
            Alert(title: Text("A number is greater than 144"),
                  primaryButton: .default(Text("Start Over"),
                                          action: {
                vm.numbers.removeAll()
            }),
                  secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    TryAllSatisfy_Intro()
}

final class TryAllSatisfy_IntroViewModel: ObservableObject {
    @Published var numbers: [Int] = []
    @Published var allFibonacciNumbers = false
    @Published var invalidNumberError: InvalidNumberError?
    
    func allFibonacciCheck() {
        let fibonacciNumbersTo144 = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]

        _ = numbers.publisher
            .tryAllSatisfy { number in
                if number > 144 { throw InvalidNumberError()}
                return fibonacciNumbersTo144.contains(number)
            }
            .sink(receiveCompletion: { [unowned self] (completion) in
                switch completion {
                case .failure(let error):
                    self.invalidNumberError = error as? InvalidNumberError
                default:
                    break
                }
            }, receiveValue: { [unowned self] (result) in
                allFibonacciNumbers = result
            })
    }
    
    func add(number: String) {
        if number.isEmpty {
            return
        }
        numbers.append(Int(number) ?? 0)
    }
}

struct InvalidNumberError: Error, Identifiable {
    var id = UUID()
}
