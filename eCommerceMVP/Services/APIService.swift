//
//  APIService.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import Foundation

struct APIService: Sendable {
    private let baseURL = "https://axesso-walmart-data-service.p.rapidapi.com/wlm/walmart-search-by-keyword"
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func searchProducts(
        keyword: String,
        page: Int
    ) async throws -> [Product] {
        var components = URLComponents(string: baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sortBy", value: "best_match")
        ]
        
        guard let url = components?.url else {
            throw ProductAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        
        print("Request URL:", url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ProductAPIError.invalidResponse
        }
        
        let body = String(data: data, encoding: .utf8) ?? "Body vacío o no legible"
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw ProductAPIError.badStatusCode(httpResponse.statusCode, body)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            return decodedResponse.products
        } catch {
            throw ProductAPIError.invalidJSON(error.localizedDescription)
        }
    }
}

enum ProductAPIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int, String)
    case invalidJSON(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .badStatusCode(let statusCode, let body):
            return "Status code: \(statusCode). Body: \(body)"
        case .invalidJSON(let message):
            return "No se pudo decodificar el JSON: \(message)"
        }
    }
}
