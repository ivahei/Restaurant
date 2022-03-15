//
//  StateRestorationController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 01.03.22.
//

import Foundation

enum StateRestorationController {
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }

    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order

    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }

    init?(userActivity: NSUserActivity) {
        guard let identifier = userActivity.controllerIdentifier else {
            return nil
        }

        switch identifier {
        case .categories:
            self = .categories
        case .menu:
            if let category = userActivity.menuCategory {
                self = .menu(category: category)
            } else {
                return nil
            }
        case .menuItemDetail:
            if let menuItem = userActivity.menuItem {
                self = .menuItemDetail(menuItem)
            } else {
                return nil
            }
        case .order:
            self = .order
        }
    }
}
