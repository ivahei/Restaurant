//
//  SceneDelegate.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var orderTabBarItem: UITabBarItem!
    let menuController = MenuController.shared

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        if scene as? UIWindowScene == nil { return }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOrderBadge),
            name: MenuController.orderUpdatedNotification,
            object: nil)

        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    @objc func updateOrderBadge() {
        switch menuController.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }
}
