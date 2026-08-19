//
//  ProductSearchViewModel.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import Foundation

@MainActor
final class ProductSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var products: [Product] = []
    @Published var searchHistory: [String] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String?
    
    private let apiService: APIService
    private let historyStore: SearchHistoryStore
    
    private var currentPage = 1
    private var canLoadMorePages = true
    private var currentKeyword = ""
    private var searchTask: Task<Void, Never>?
    
    init(
        apiService: APIService,
        historyStore: SearchHistoryStore = SearchHistoryStore()
    ) {
        self.apiService = apiService
        self.historyStore = historyStore
        self.searchHistory = historyStore.load()
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        products = []
        errorMessage = nil
        currentKeyword = ""
        currentPage = 1
        canLoadMorePages = true
        isLoading = false
        isLoadingNextPage = false
    }
    
    func scheduleSearch() {
        searchTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            products = []
            errorMessage = nil
            currentKeyword = ""
            currentPage = 1
            canLoadMorePages = true
            return
        }
        
        searchTask = Task {
            guard (try? await Task.sleep(for: .seconds(1))) != nil else {
                return
            }
            
            await search(resetPagination: true)
        }
    }
    
    func searchFromSubmit() {
        searchTask?.cancel()
        
        Task {
            await search(resetPagination: true)
        }
    }
    
    func searchAgain(_ query: String) {
        searchText = query
        searchFromSubmit()
    }
    
    func loadNextPageIfNeeded(currentProduct: Product) {
        guard !isLoading, !isLoadingNextPage, canLoadMorePages else {
            return
        }
        
        guard let currentIndex = products.firstIndex(where: { $0.id == currentProduct.id }) else {
            return
        }
        
        let thresholdIndex = products.index(products.endIndex, offsetBy: -5)
        
        guard currentIndex >= thresholdIndex else {
            return
        }
        
        Task {
            await loadNextPage()
        }
    }
    
    private func search(resetPagination: Bool) async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            return
        }
        
        if resetPagination {
            currentPage = 1
            currentKeyword = query
            canLoadMorePages = true
            products = []
            isLoading = true
        }
        
        errorMessage = nil
        
        do {
            let newProducts = try await apiService.searchProducts(
                keyword: query,
                page: currentPage
            )
            
            products = newProducts
            canLoadMorePages = !newProducts.isEmpty
            saveSearch(query)
        } catch {
            print("Search error:", error.localizedDescription)
            errorMessage = "No pudimos obtener productos\nIntenta nuevamente por favor"
        }
        
        isLoading = false
    }
    
    private func loadNextPage() async {
        guard !currentKeyword.isEmpty else {
            return
        }
        
        isLoadingNextPage = true
        currentPage += 1
        
        do {
            let newProducts = try await apiService.searchProducts(
                keyword: currentKeyword,
                page: currentPage
            )
            
            if newProducts.isEmpty {
                canLoadMorePages = false
            } else {
                products.append(contentsOf: newProducts)
            }
        } catch {
            currentPage -= 1
            errorMessage = "No pudimos cargar más productos"
        }
        
        isLoadingNextPage = false
    }
    
    private func saveSearch(_ query: String) {
        searchHistory.removeAll { $0.caseInsensitiveCompare(query) == .orderedSame }
        searchHistory.insert(query, at: 0)
        searchHistory = Array(searchHistory.prefix(10))
        historyStore.save(searchHistory)
    }
}
