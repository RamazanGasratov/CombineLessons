//
//  OliveView.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 23.01.2024.
//

import SwiftUI

struct OliveView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            Button("Dismiss") {
                coordinator.dismissFullScreenCover()
            }
        }
        .navigationTitle("🫒")
    }
}

#Preview {
    OliveView()
}
