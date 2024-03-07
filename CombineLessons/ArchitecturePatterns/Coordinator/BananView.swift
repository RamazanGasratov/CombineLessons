//
//  BananView.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 23.01.2024.
//

import SwiftUI

struct BananView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            Button("Push 🥕") {
                coordinator.push(.carrot)
            }
            
            Button("Pop")  {
                coordinator.pop()
            }
        }
        .navigationTitle("🍌")
    }
}

#Preview {
    BananView()
}
