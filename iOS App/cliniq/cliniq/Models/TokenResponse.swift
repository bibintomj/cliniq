//
//  TokenResponse.swift
//  cliniq
//
//  Created by Bibin Joseph on 2025-03-07.
//

import Foundation

// MARK: - LoginResponse
struct TokenResponse: Codable {
    let token: Int?
    let error: String?
}
