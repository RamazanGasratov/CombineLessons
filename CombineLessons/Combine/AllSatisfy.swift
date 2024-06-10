//
//  AllSatisfy.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 10.06.2024.
//

import SwiftUI

/*
 Используйте оператора allSatisfy, чтобы проверить, что все
 элементы, проходут через конвейер, соответствуют указанным
 критериям.
 
 Как только один элемент НЕ соответствует вашим критериям,
 публикуется ложь, и конвейер завершается/закрывается.
 В противном случае, если все элементы соответствовали
 вашим критериям, то публикуется true.
 */

struct AllSatisfy_Intro: View {
    @State private var number = ""
    @State private var resultVisible = false
    @StateObject private var vm = AllSatisfy_IntroViewModel()
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                TextField("add a number", text: $number)           .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Button(action: {                 
                    vm.add(number: number)
                    number = ""
                }, label: { Image(systemName: "plus")
                })
            }.padding()
            List(vm.numbers, id: \.self) {
                number in
                
                Text("\(number)")
            }
            Spacer(minLength: 0)
            Button("Fibonacci Numbers?") {
                vm.allFibonacciCheck()     
                resultVisible = true
            }                        
            Text(vm.allFibonacciNumbers ? "Yes" : "No")                .opacity(resultVisible ? 1 : 0)
        }
        .padding(.bottom)
        .font(.title)
    }
}

#Preview {
    AllSatisfy_Intro()
}

class AllSatisfy_IntroViewModel: ObservableObject {
    
    @Published var numbers: [Int] = []
    @Published var allFibonacciNumbers = false
    
    func allFibonacciCheck() {
         let fibonacciNumbersTo144 = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
        
        numbers.publisher
            .allSatisfy { number in
                fibonacciNumbersTo144.contains(number)
            }
            .assign(to: &$allFibonacciNumbers)
    }
    
    func add(number: String) {
        if number.isEmpty { return }
        numbers.append(Int(number) ?? 0)
    }
}
