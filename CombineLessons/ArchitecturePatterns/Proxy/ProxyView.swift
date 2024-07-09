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

//Сценарий
//Предположим, что у нас есть приложение, которое взаимодействует с API для получения данных о пользователях. Каждый раз, когда приложение запрашивает данные о пользователе, это может быть дорогостоящая операция (по времени и по трафику). Мы хотим улучшить производительность приложения за счет кэширования данных.
//
//Реализация Proxy для кэширования сетевых запросов
//Создаем протокол UserService, который будет определять метод для получения данных о пользователях.
//Создаем класс RealUserService, который реализует этот протокол и делает реальные сетевые запросы.
//Создаем класс UserServiceProxy, который также реализует протокол UserService и кэширует данные, чтобы уменьшить количество сетевых запросов.
//Протокол UserService
//swift

protocol UserService {
    func fetchUserData(userId: String, completion: @escaping (UserData?) -> Void)
}
//Класс RealUserService
//swift

import Foundation

class RealUserService: UserService {
    func fetchUserData(userId: String, completion: @escaping (UserData?) -> Void) {
        let url = URL(string: "https://api.example.com/users/\(userId)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let userData = try? JSONDecoder().decode(UserData.self, from: data)
            completion(userData)
        }
        
        task.resume()
    }
}
//Класс UserServiceProxy
//swift

class UserServiceProxy: UserService {
    private let realUserService: RealUserService
    private var cache: [String: UserData] = [:]
    
    init(realUserService: RealUserService) {
        self.realUserService = realUserService
    }
    
    func fetchUserData(userId: String, completion: @escaping (UserData?) -> Void) {
        if let cachedData = cache[userId] {
            print("Returning cached data for user \(userId)")
            completion(cachedData)
            return
        }
        
        print("Fetching data from network for user \(userId)")
        realUserService.fetchUserData(userId: userId) { [weak self] userData in
            if let userData = userData {
                self?.cache[userId] = userData
            }
            completion(userData)
        }
    }
}
//Модель UserData
struct UserData: Codable {
    let id: String
    let name: String
    let email: String
}
//Объяснение кода
//Протокол UserService: Определяет метод fetchUserData, который будет реализован и в реальном сервисе, и в прокси.
//Класс RealUserService: Реализует протокол UserService и выполняет сетевой запрос для получения данных о пользователях. В методе fetchUserData используется URLSession для выполнения запроса и обработки ответа.
//Класс UserServiceProxy: Реализует протокол UserService и содержит логику кэширования. Если данные для запрашиваемого пользователя уже находятся в кэше, прокси возвращает их немедленно. Если данных нет, прокси выполняет запрос через реальный сервис и затем сохраняет данные в кэше.
//Модель UserData: Представляет данные пользователя, которые будут получены от API.
//Использование прокси в клиентском коде

let realService = RealUserService()
let proxyService = UserServiceProxy(realUserService: realService)

//proxyService.fetchUserData(userId: "12345") { userData in
//    if let userData = userData {
//        print("User name: \(userData.name), email: \(userData.email)")
//    } else {
//        print("Failed to fetch user data")
//    }
//}

// Повторный вызов с тем же userId, данные будут взяты из кэша
//proxyService.fetchUserData(userId: "12345") { userData in
//    if let userData = userData {
//        print("User name: \(userData.name), email: \(userData.email)")
//    } else {
//        print("Failed to fetch user data")
//    }
//}
//Объяснение клиентского кода
//Создаем экземпляр реального сервиса RealUserService.
//Создаем экземпляр прокси UserServiceProxy, передавая ему реальный сервис.
//Вызываем метод fetchUserData через прокси, который сначала проверяет кэш и возвращает данные из кэша, если они доступны, или делает реальный сетевой запрос в противном случае.
//Этот пример демонстрирует, как паттерн Proxy может быть использован для улучшения производительности приложения за счет кэширования данных, полученных от сетевых запросов.
