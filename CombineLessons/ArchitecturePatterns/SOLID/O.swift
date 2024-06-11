//
//  O.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 11.06.2024.
//

import Foundation
import SwiftUI

/* Принцип OCP (Open/Closed Principle) из SOLID
 
Определение
 
Принцип открытости/закрытости (Open/Closed Principle) гласит, что программные сущности (например, классы, модули, функции) должны быть:

Открыты для расширения (можно добавлять новую функциональность).
Закрыты для модификации (не нужно изменять существующий код).
 
Цель
Цель принципа OCP — сделать систему гибкой для изменений и расширений, минимизируя вероятность внесения ошибок в уже работающий код.

Примеры
Пример на Swift: Фильтрация продуктов

Без соблюдения OCP
 */

enum ProductType {
    case electronics
    case clothing
    case groceries
}

struct Product {
    var name: String
    var type: ProductType
}

class ProductFilter {
    func filterByType(products: [Product], type: ProductType) -> [Product] {
        return products.filter { $0.type == type }
    }
}

// Если нужно добавить новый тип фильтрации, придется модифицировать класс ProductFilter, что нарушает OCP.

// С соблюдением OCP


protocol ProductSpecification {
    func isSatisfied(by product: Product) -> Bool
}

class ProductFilter2 {
    func filter(products: [Product], by specification: ProductSpecification) -> [Product] {
        return products.filter { specification.isSatisfied(by: $0) }
    }
}

class ProductTypeSpecification: ProductSpecification {
    private let type: ProductType
    
    init(type: ProductType) {
        self.type = type
    }
    
    func isSatisfied(by product: Product) -> Bool {
        return product.type == type
    }
}

class ProductNameSpecification: ProductSpecification {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func isSatisfied(by product: Product) -> Bool {
        return product.name == name
    }
}

// Использование

let products = [
    Product(name: "iPhone", type: .electronics),
    Product(name: "T-shirt", type: .clothing),
    Product(name: "Apple", type: .groceries)
]

let filter = ProductFilter2()

let electronicsSpec = ProductTypeSpecification(type: .electronics)
let electronics = filter.filter(products: products, by: electronicsSpec)

let nameSpec = ProductNameSpecification(name: "iPhone")
let iPhone = filter.filter(products: products, by: nameSpec)


//Пример на Swift: Уведомления

// Без соблюдения OCP

enum NotificationType {
    case email
    case sms
}

struct Notification {
    var type: NotificationType
    var message: String
}


//Заключение
//Принцип открытости/закрытости (OCP) позволяет проектировать системы, которые легко расширяются без изменения существующего кода. Это достигается за счет использования абстракций, таких как протоколы и интерфейсы, что способствует созданию гибких и масштабируемых приложений.
