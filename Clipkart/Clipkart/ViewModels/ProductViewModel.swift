//
//  ProductViewModel.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import Foundation
import UserNotifications

@Observable class ProductViewModel: ObservableObject {
    
    var products: [Product] = []
    private let manager = APIManager()
    var displayedProducts: [Product] = []
    var currentPage: Int = 0
    var isLoading = true // Add loading state
    var isNetClosed: Bool = false
    private let itemsPerPage = 6
    private var isFetchingMore = false
    
    func fetchProducts() async {
        do {
            products = try await manager.request(url: "https://fakestoreapi.com/products")
            // Once the data is loaded, hide the progress view
            isLoading = false
            loadNextPage()
            print(products)
        }catch {
            isNetClosed = true
            isLoading = false
            //  print("Fetch Product error:", error)
        }
    }
    
    func loadNextPage() {
        guard !isFetchingMore else { return } // Prevent rapid multiple calls
        guard currentPage * itemsPerPage < products.count else { return }
        
        isFetchingMore = true
        
        let start = currentPage * itemsPerPage
        let end = min(start + itemsPerPage, products.count)
        
        let nextItems = products[start..<end]
        displayedProducts.append(contentsOf: nextItems)
        
        currentPage += 1
        isFetchingMore = false
    }
}


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

final class APIManager {
    
    /*
     Error: throw
     response: return
     */
    func request<T: Decodable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
