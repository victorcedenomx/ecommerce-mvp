//
//  ProductRowView.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            ProductImageView(url: product.thumbnailURL)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(product.displayPrice)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(product.price == nil ? .secondary : .primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
