//
//  APIResponse.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import Foundation

struct APIResponse: Decodable, Sendable {
    
    // MARK: - Properties
    
    let item: SearchItemContainer?
    
    var products: [Product] {
        item?
            .props?
            .pageProps?
            .initialData?
            .searchResult?
            .itemStacks
            .flatMap { $0.items } ?? []
    }
}

struct SearchItemContainer: Decodable, Sendable {
    
    // MARK: - Properties
    
    let props: SearchProps?
}

struct SearchProps: Decodable, Sendable {
    
    // MARK: - Properties
    
    let pageProps: SearchPageProps?
}

struct SearchPageProps: Decodable, Sendable {
    
    
    // MARK: - Properties
    
    let initialData: SearchInitialData?
}

struct SearchInitialData: Decodable, Sendable {
    
    // MARK: - Properties
    
    let searchResult: SearchResult?
}

struct SearchResult: Decodable, Sendable {
    
    // MARK: - Properties
    
    let itemStacks: [ProductStack]
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case itemStacks
    }
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemStacks = try container.decodeIfPresent([ProductStack].self, forKey: .itemStacks) ?? []
    }
}

struct ProductStack: Decodable, Sendable {
    
    // MARK: - Properties
    
    let items: [Product]
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decodeIfPresent([Product].self, forKey: .items) ?? []
    }
}
