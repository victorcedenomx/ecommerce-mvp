//
//  APIKeySetupView.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import SwiftUI

struct APIKeySetupView: View {
    @State private var apiKey = ""
    
    let onSave: (String) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Configura tu API Key")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Ingresa tu RapidAPI Key para poder buscar productos")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            SecureField("RapidAPI Key", text: $apiKey)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            Button("Guardar") {
                onSave(apiKey.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            .buttonStyle(.borderedProminent)
            .disabled(apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
}
