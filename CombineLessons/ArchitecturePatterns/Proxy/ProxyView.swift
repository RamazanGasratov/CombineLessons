//
//  ProxyView.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 18.06.2024.
//

import SwiftUI
import Foundation

protocol LoadServiceProtocol {
    func loadImage(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

class LoadImageService: LoadServiceProtocol {
    func loadImage(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        session.dataTask(with: url, completionHandler: completion).resume()
    }
}

var cacheData: Data?

class Proxy: LoadServiceProtocol {
    private var service: LoadServiceProtocol
    
    init(service: LoadServiceProtocol) {
        self.service = service
    }
    
    func loadImage(url: URL, completion: @escaping (Data?, URLResponse?, Error? ) -> ()) {
        if cacheData == nil {
            service.loadImage(url: url) { (data, response, error) in
                cacheData = data
                completion(data, response, error)
            }
        } else {
            completion(cacheData, nil, nil)
        }
    }
}

struct LinkInProxyView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    ProxyView()
                } label: {
                    Text("Переход на другой экран")
                }
            }
        }
    }
}

class ProxyViewModel: ObservableObject {
    @Published var image: UIImage?
    
    let url = URL(string: "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
    
    func loadImage() {
        let imageService = LoadImageService()
        let proxy = Proxy(service: imageService)
        
        proxy.loadImage(url: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
 
struct ProxyView: View {
    
    @StateObject var vm = ProxyViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .background(Color.blue)
            }
            Button {
                
            } label: {
                Text("Обновить")
            }
        }
        .onAppear {
            vm.loadImage()
        }
    }
}

#Preview {
    LinkInProxyView()
}
