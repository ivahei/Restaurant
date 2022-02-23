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

    // MARK: - Send Request

    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        guard
            let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
        else { throw fatalError() }
        return try request.decodeResponse(data: data)
    }
}
