//
//  APIRequest.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 22.02.22.
//

import Foundation

protocol APIRequest {
    associatedtype Response

    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}
