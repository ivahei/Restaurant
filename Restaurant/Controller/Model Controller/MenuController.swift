//
//  MenuController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 22.02.22.
//

import Foundation

final class MenuController {
    static let shared = MenuController()
    private init() {}

    static let baseURL = URL(string: "http://localhost:8080/")!
    typealias MinutesToPrepare = Int

    enum NetworkError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
        case imageDataMissing
    }

    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        guard
            let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
        else { throw fatalError() }
        return try request.decodeResponse(data: data)
    }

    struct CategoryRequest: APIRequest {
        var urlRequest: URLRequest
        typealias Response = [String]
        let categoriesURL = baseURL.appendingPathComponent("categories")

        func decodeResponse(data: Data) throws -> [String] {
            let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
            return categoriesResponse.categories
        }
    }

    struct MenuItemsRequest: APIRequest {
        typealias Response = [MenuItem]
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        let name: String

        var urlRequest: URLRequest {
            guard var urlComponents = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)
            else { fatalError() }
            urlComponents.queryItems = [URLQueryItem(name: "category", value: name)]
            let request = URLRequest(url: urlComponents.url!)
            return request
        }

        func decodeResponse(data: Data) throws -> Response {
            let menuResponse = try JSONDecoder().decode(MenuResponse.self, from: data)
            return menuResponse.items
        }
    }

    struct SubmitOrder: APIRequest {
        typealias Response = Int
        let menuIDs: [Int]
        let orderURL = baseURL.appendingPathComponent("order")
        var urlRequest: URLRequest {
            var request = URLRequest(url: orderURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField:
                                "Content-Type")

            let menuIdsDict = ["menuIds": menuIDs]
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(menuIdsDict)
            request.httpBody = jsonData
            return request
        }

        func decodeResponse(data: Data) throws -> Response {
            let orderResponse = try JSONDecoder().decode(OrderResponse.self, from: data)
            return orderResponse.prepTime
        }
    }
}
