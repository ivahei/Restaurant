//
//  CategoryRequest.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 23.02.22.
//

import Foundation

struct CategoryRequest: APIRequest {
    typealias Response = [String]

    let baseURL = URL(string: "http://localhost:8080/")
    var urlRequest: URLRequest {
        guard let categoriesURL = baseURL?.appendingPathComponent("categories") else { fatalError() }
        return URLRequest(url: categoriesURL)
    }

    func decodeResponse(data: Data) throws -> [String] {
        let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
        return categoriesResponse.categories
    }
}
