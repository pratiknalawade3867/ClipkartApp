//
//  CartView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 31/10/24.
//

import SwiftUI
import CoreData

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.managedObjectContext) private var viewContext
    @State private var emptycart: Bool = false
    
    var body: some View {
        VStack{
            // Check if the cart is empty and show the alert
            if cartManager.cartItems.isEmpty {
                VStack{
                    Spacer()
                    Text("Your cart is empty")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            }
            
            List {
                ForEach(cartManager.cartItems, id: \.id) { product in
                    NavigationLink(destination: ProductDetailsView(products: cartManager.cartItems, index: 0)) {
                        ProductRowView(product: product)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // If the cart is empty, show the alert
            if cartManager.cartItems.isEmpty {
                emptycart = true
            }
        }
    }
    private func deleteItems(at offsets: IndexSet) {
        // Removing products from the cart manager
        cartManager.cartItems.remove(atOffsets: offsets)
        
        // Check if the cart is empty after the deletion
        if cartManager.cartItems.isEmpty {
            emptycart = true
        }
    }
}

class CartManager: ObservableObject {
    @Published var cartItems: [Product] = []
    
    func addToCart(product: Product) {
        if !cartItems.contains(where: { $0.id == product.id }) {
            cartItems.append(product)
        }
    }
    
    func removeFromCart(product: Product) {
        cartItems.removeAll { $0.id == product.id }
    }  
    
    
    func isProductInCart(_ product: Product) -> Bool {
        return cartItems.contains { $0.id == product.id }
    }
    
    func productImage(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300, height: 300)
    }
}

