//
//  Empty.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 06.05.2024.
//

import SwiftUI

struct Empty_Intro: View {
//    @StateObject private var vm = Empty_IntroViewModel()
    var body: some View {
        VStack(spacing: 20) {
            
//            List(vm.dataToView, id: \.self) { item in               
//                Text(item)
//            }
        }
        .font(.title)
        .onAppear {
//            vm.fetch()
        }
    }
}

//class Empty_IntroViewModel: ObservableObject {
//    
//    @Published var dataToView: [String] = []
//    
//    func fetch() {
//        
//        let dataIn = ["Value 1", "Value 2", "Value 3", "🧨", "Value 5", "Value 6"]
//        
//        _ = dataIn.publisher
//            .tryMap { item in
//                if item == "🧨" {                    throw BombDetectedError()                }
//                return item
//            }
//            .catch { (error) in
//                Empty()
//            }
//        .sink { [unowned self] (item) in                dataToView.append(item)
//        }
//    }
//}
