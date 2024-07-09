//
//  DeepLinkTestView.swift
//  CombineLessons
//
//  Created by Ramazan Gasratov on 20.06.2024.
//

import SwiftUI

struct DeepLinkTestView: View {
//    @StateObject private var routerManager = NavigationRouter()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: ProductCardViewResult()) {
                    Text("Перейти на другой экран")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                Spacer()
            }
            .navigationTitle("Главный экран")
        }
    }
}

#Preview {
    DeepLinkTestView()
}

struct ProductTest {
    let image: String
    let title: String
    let description: String
    let price: String
    let size: String
}

struct ProductCardView: View {
    let product: ProductTest

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .infinity, height: 200)
                .cornerRadius(10)
                .clipped()

            // Title
            Text(product.title)
                .font(.headline)
                .lineLimit(2)

            // Description
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)

            HStack {
                // Price
                Text(product.price)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()

                // Size
                Text("Size: \(product.size)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.horizontal, .top])
    }
}

struct ProductCardViewResult: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Example product
                ProductCardView(product: ProductTest(
                    image: "product_image", // replace with your image name
                    title: "Product Title",
                    description: "This is a brief description of the product. It highlights the key features and benefits.",
                    price: "$99.99",
                    size: "M"
                ))
            }
        }
    }
}

//MARK: Rout

enum Route {
    case promo
}

extension Route: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.promo, .promo):
            return true
        }
    }
}

extension Route: View {
    
    var body: some View {
        switch self {
        case .promo:
            DeepLinkTestView()
        }
    }
}
