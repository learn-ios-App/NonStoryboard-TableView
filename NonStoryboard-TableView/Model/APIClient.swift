//
//  APIClient.swift
//  NonStoryboard-TableView
//
//  Created by 渡邊魁優 on 2023/04/11.
//

import Foundation

class APIClient {
    func fetch() async throws -> [Article] {
        guard let url = URL(string: "https://qiita.com/api/v2/items") else {
            throw APIError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode([Article].self, from: data)
            return result
        } catch {
            throw APIError.networkError
        }
    }
}
