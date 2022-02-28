//
//  MenuItemsRequest.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 23.02.22.
//

import Foundation

struct MenuItemsRequest: APIRequest {
    typealias Response = [MenuItem]

    let baseURL = URL(string: "http://localhost:8080/")
    let name: String

    var urlRequest: URLRequest {
        guard
            let initialMenuURL = baseURL?.appendingPathComponent("menu"),
            var urlComponents = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)
        else { fatalError() }
        urlComponents.queryItems = [URLQueryItem(name: "category", value: name)]
        guard let url = urlComponents.url else { fatalError() }
        let request = URLRequest(url: url)
        return request
    }

    func decodeResponse(data: Data) throws -> Response {
        let menuResponse = try JSONDecoder().decode(MenuResponse.self, from: data)
        return menuResponse.items
    }
}
