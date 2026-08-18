//
//  ProductImageView.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import SwiftUI

struct ProductImageView: View {
    let url: URL?
    
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var didFail = false
    
    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if isLoading {
                ProgressView()
            } else {
                placeholder
            }
        }
        .frame(width: 72, height: 72)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task(id: url) {
            await loadImage()
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "photo")
            .font(.title3)
            .foregroundStyle(.secondary)
    }
    
    @MainActor
    private func loadImage() async {
        image = nil
        didFail = false
        
        guard let url else {
            isLoading = false
            didFail = true
            return
        }
        
        isLoading = true
        
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 5
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let loadedImage = UIImage(data: data) else {
                didFail = true
                isLoading = false
                return
            }
            
            image = loadedImage
            isLoading = false
        } catch {
            didFail = true
            isLoading = false
        }
    }
}
