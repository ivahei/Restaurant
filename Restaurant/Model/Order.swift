//
//  Order.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]

    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
