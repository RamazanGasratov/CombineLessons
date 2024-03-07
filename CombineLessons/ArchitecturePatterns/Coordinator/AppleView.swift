//
//  CordinatorSwfitUI.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 23.01.2024.
//

import SwiftUI

struct AppleView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            Button("Push 🍌") {
                coordinator.push(.banan)
            }
            Button("Present 🍋") {
                coordinator.present(sheet: .lemon)
            }
            Button("Present 🫒") {
                coordinator.present(fullScreenCover: .olive)
            }
        }
        .navigationTitle("🍎")
    }
}

#Preview {
    AppleView()
}
