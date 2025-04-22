//
//  Product.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import Foundation

struct Product: Decodable, Identifiable{
    let id: Int
    let title: String
    let description: String
    let category: String
    let image: String
    let price: Double
    let rating: Rate
}

struct Rate: Codable {
    let rate: Double
    let count: Int
}

struct Employee : Equatable, Hashable {
    var id: Int
    var name:String
}


extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
    
    func currencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
