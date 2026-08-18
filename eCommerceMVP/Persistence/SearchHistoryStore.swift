//
//  SearchHistoryStore.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import Foundation

final class SearchHistoryStore {
    private let key = "searchHistory"

    func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func save(_ searches: [String]) {
        UserDefaults.standard.set(searches, forKey: key)
    }
}
