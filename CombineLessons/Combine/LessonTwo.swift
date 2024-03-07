//
//  LessonTwo.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 21.12.2023.
//

import SwiftUI
import Combine

struct FirstCancellblePipelineView: View {
    
    @StateObject var viewModel = FirstCancellblePipelineViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(viewModel.data)
                .font(.title)
                .foregroundColor(.green)
            
            Text(viewModel.status)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button {
                viewModel.cancel()
            } label: {
                Text("Отменить подписку")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.red)
            .cornerRadius(8)
            .opacity(viewModel.status == "Запрос в банк..." ? 1.0 : 0.0)
            
            Button {
                viewModel.refresh()
            } label: {
                Text("Запрос данных")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
    }
}

final class FirstCancellblePipelineViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    private var cancallable: AnyCancellable?
    
    init() {
        cancallable = $data
            .map { [unowned self] value -> String in
                status = "Запрос в банк..."
                return value
            }
            .delay(for: 5, scheduler: DispatchQueue.main)
            .sink { [unowned self] value in
                data = "Сумма всех счетов 1 млн."
                self.status = "Данные получены"
            }
    }
    
    func refresh() {
        data = "Перезапрос данных"
    }
    
    func cancel() {
        status = "Операция отменена"
        cancallable?.cancel()
        cancallable = nil
    }
}

#Preview {
    FirstCancellblePipelineView()
}
