//
//  ProductRowView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 8) {
            if let url = URL(string: product.image) {
                productImage(url: url)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(product.title)
                    .font(.headline)
                    .lineLimit(nil) // Remove line limit to allow full text
                
                // Category and Rating
                HStack {
                    Text(product.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    HStack {
                        Image(systemName: "star.fill")
                        Text(product.rating.rate.toString())
                    }
                    .fontWeight(.medium)
                    .foregroundStyle(.yellow)
                }
                
                // Description
                Text(product.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                // Price and Buy Button
                HStack {
                    Text(product.price, format: .currency(code: "USD"))
                        .font(.title3)
                        .foregroundStyle(.indigo)
                    Spacer()
                    mrpDiscountTag(mrp: product.price)
                }
            }
        }
        .padding()
    }
    
    func productImage(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 135)
    }
    
    func mrpDiscountTag(mrp: Double) -> some View {
        let priceWithAdditional10Percent = mrp * 1.10 // MRP with 10% more
        let roundedPrice = round(priceWithAdditional10Percent)  // Round off the price

        return VStack {
            HStack {
                Text("₹\(Int(roundedPrice))")  // Convert rounded price to Int to remove decimals
                    .strikethrough()  // Crosses the original price
                    .foregroundColor(.red)  // Red color for the crossed-out price
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    ProductRowView(product: Product(id: 0, title: "", description: "", category: "", image: "", price: 0.0, rating: Rate(rate: 0.0, count: 0)))
}

