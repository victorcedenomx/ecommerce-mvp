//
//  RootView.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import SwiftUI

struct RootView: View {
    @State private var apiKey: String?
    
    private let apiKeyStore = APIKeyStore()
    
    var body: some View {
        Group {
            if let apiKey {
                ProductsView(apiKey: apiKey)
            } else {
                APIKeySetupView { newKey in
                    apiKeyStore.save(newKey)
                    apiKey = newKey
                }
            }
        }
        .onAppear {
            apiKey = apiKeyStore.rapidAPIKey
        }
    }
}
