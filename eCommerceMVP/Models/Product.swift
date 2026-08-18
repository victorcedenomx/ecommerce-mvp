//
//  Product.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import Foundation

struct Product: Identifiable, Decodable, Sendable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let price: Double?
    let image: String?
    let imageInfo: ProductImageInfo?
    
    var title: String {
        name
    }
    
    var thumbnailURL: URL? {
        if let thumbnailUrl = imageInfo?.thumbnailUrl {
            return URL(string: thumbnailUrl)
        }
        
        if let image {
            return URL(string: image)
        }
        
        return nil
    }
    
    var displayPrice: String {
        guard let price else {
            return "Precio no disponible"
        }
        
        return price.formatted(.currency(code: "USD"))
    }
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case id
        case usItemId
        case name
        case price
        case image
        case imageInfo
    }
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Título no disponible"
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        imageInfo = try container.decodeIfPresent(ProductImageInfo.self, forKey: .imageInfo)
    }
}

struct ProductImageInfo: Decodable, Sendable {
    let thumbnailUrl: String?
}
