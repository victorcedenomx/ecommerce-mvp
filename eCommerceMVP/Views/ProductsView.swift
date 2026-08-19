//
//  ProductsView.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel: ProductSearchViewModel

    init(apiKey: String) {
        _viewModel = StateObject(
            wrappedValue: ProductSearchViewModel(
                apiService: APIService(apiKey: apiKey)
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                searchBar
                    .padding(.horizontal)
                
                if !viewModel.searchHistory.isEmpty {
                    historySection
                        .padding(.horizontal)
                }
                
                contentView
            }
            .navigationTitle("Productos")
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Buscar producto", text: $viewModel.searchText)
                .submitLabel(.search)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onSubmit {
                    viewModel.searchFromSubmit()
                }
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.scheduleSearch()
                }
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Búsquedas recientes")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.searchHistory, id: \.self) { query in
                        Button(query) {
                            viewModel.searchAgain(query)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView("Buscando productos...")
            Spacer()
        } else if let errorMessage = viewModel.errorMessage {
            Spacer()
            Text(errorMessage)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
            Spacer()
        } else if viewModel.products.isEmpty {
            Spacer()
            Text("Ingresa un producto para comenzar.")
                .foregroundStyle(.secondary)
            Spacer()
        } else {
            List {
                ForEach(viewModel.products) { product in
                    ProductRowView(product: product)
                        .padding(.horizontal)
                        .listRowInsets(EdgeInsets())
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentProduct: product)
                        }
                }
                
                if viewModel.isLoadingNextPage {
                    paginationLoadingRow
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    private var paginationLoadingRow: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
            
            Text("Cargando más productos...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}
