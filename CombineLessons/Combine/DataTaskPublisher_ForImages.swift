//
//  DataTaskPublisher_ForImages.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 03.06.2024.
//

import SwiftUI
import Combine

struct DataTaskPublisher_ForImages: View {
    @StateObject private var vm = DataTaskPublisher_ForImagesViewModel()
    var body: some View {
        VStack(spacing: 20) {
            
            vm.imageView
        }
        .font(.title)
        .onAppear {
            vm.fetch()
        }
        .alert(item: $vm.errorForAlert) { errorForAlert in
            Alert(title:
                    Text(errorForAlert.title),
                  message: Text(errorForAlert.message))
        }
    }
}

#Preview {
    DataTaskPublisher_ForImages()
}

class DataTaskPublisher_ForImagesViewModel: ObservableObject {
    
    @Published var imageView: Image?
    @Published var errorForAlert: ErrorForAlert?
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        
        let url = URL(string: "https://www.bigmountainstudio.com/image1")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw ErrorForAlert(title: "", message: "Did not receive a valid image.")
                }
                return Image(uiImage: uiImage)
            }
            .replaceError(with: Image("category8"))
            .receive(on: RunLoop.main)
            .sink { [unowned self] image in
                imageView = image
            }
            .store(in: &cancellables)
    }
}


