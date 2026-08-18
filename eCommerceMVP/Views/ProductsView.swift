//
//  ProductsView.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import SwiftUI

struct ProductsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                SearchBar
                    .padding(.horizontal)
                
                ContentView
            }
            .navigationTitle("Productos")
        }
    }
    
    private var SearchBar: some View {
        HStack {
            Button("Buscar") {
                
            }
        }
    }
    
    @ViewBuilder
    private var ContentView: some View {
        List(content: {
            
        })
        .listStyle(.plain)
    }
}
