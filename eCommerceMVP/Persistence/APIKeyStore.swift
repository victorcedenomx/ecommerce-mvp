//
//  APIKeyStore.swift
//  eCommerceMVP
//
//  Created by Víctor Cedeño on 18/08/26.
//

import Foundation

final class APIKeyStore {
    private let key = "rapidAPIKey"
    
    var rapidAPIKey: String? {
        let value = UserDefaults.standard.string(forKey: key)
        return value?.isEmpty == false ? value : nil
    }
    
    func save(_ value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
