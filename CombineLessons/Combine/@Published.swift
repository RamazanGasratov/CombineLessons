//
//  @Published.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 05.05.2024.
//

import SwiftUI
import Combine

class Published_IntroductionViewModel: ObservableObject {
    var characterLimit = 30
    @Published var data = ""
    @Published var characterCount = 0
    @Published var countColor = Color.gray
    
    init() {
        $data
            .map { data -> Int in
                return data.count
            }
            .assign(to: &$characterCount)
        
        $characterCount
            .map { [unowned self] count -> Color in
                let eightPercent = Int(Double(characterLimit) * 0.8)
                if (eightPercent...characterLimit).contains(count) {
                    return Color.yellow
                } else if count > characterLimit {
                    return Color.red
                }
                return Color.gray
            }
            .assign(to: &$countColor)
    }
}

struct _Published_Introduction: View {
    @StateObject private var vm = Published_IntroductionViewModel()
    
    var body: some View {
        VStack {
            TextEditor(text: $vm.data)
                .border(Color.gray, width: 1)
                .frame(height: 200)
                .padding()
            
            Text("\(vm.characterCount)/\(vm.characterLimit)")
                .foregroundColor(vm.countColor)
        }
        .font(.title)
    }
}

#Preview {
    _Published_Introduction()
}
