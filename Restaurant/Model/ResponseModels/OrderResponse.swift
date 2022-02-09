//
//  OrderResponse.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import Foundation

struct OrderResponse: Codable {
    let prepTime: Int

    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
