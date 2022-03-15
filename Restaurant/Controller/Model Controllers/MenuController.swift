//
//  MenuController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 22.02.22.
//

import Foundation
import UIKit

final class MenuController {
    static let shared = MenuController()
    private init() {}

    var userActivity = NSUserActivity(activityType: "com.example.OrderApp.order")

    // MARK: - Order

    var order = Order() { didSet {
        NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        userActivity.order = order
    }}

    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")

    // MARK: - Send Request

    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode)
        else { fatalError() }
        return try request.decodeResponse(data: data)
    }

    // MARK: - Update User Activity
    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        case .order, .categories:
            break
        }

        userActivity.controllerIdentifier = controller.identifier
    }
}
