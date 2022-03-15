//
//  SubmitOrder.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 23.02.22.
//

import Foundation

struct SubmitOrder: APIRequest {
    typealias Response = Int

    let baseURL = URL(string: "http://localhost:8080/")
    let menuIDs: [Int]
    var urlRequest: URLRequest {
        guard let orderURL = baseURL?.appendingPathComponent("order") else { fatalError() }
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
