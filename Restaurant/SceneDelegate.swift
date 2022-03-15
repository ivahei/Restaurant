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

    // MARK: - Restore Interaction State Scene

    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        if let restoredOrder = stateRestorationActivity.order {
            menuController.order = restoredOrder
        }

        guard
            let restorationController = StateRestorationController(userActivity: stateRestorationActivity),
            let tabBarController = window?.rootViewController as? UITabBarController,
            tabBarController.viewControllers?.count == 2,
            let categoryTableViewController = (
                tabBarController.viewControllers?[0] as? UINavigationController
            )?.topViewController as? CategoryTableViewController
        else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch restorationController {
        case .categories:
            break
        case .menu(let category):
            let menuTableViewController = storyboard.instantiateViewController(
                identifier: restorationController.identifier.rawValue,
                creator: { coder in
                return MenuTableViewController(coder: coder, category: category)
            })
            categoryTableViewController.navigationController?.pushViewController(
                menuTableViewController,
                animated: false
            )

        case .menuItemDetail(let menuItem):
            let menuTableViewController = storyboard.instantiateViewController(
                identifier: restorationController.identifier.rawValue,
                creator: { coder in
                    return MenuTableViewController(coder: coder, category: menuItem.category)
            })

            let menuItemDetailViewController = storyboard.instantiateViewController(
                identifier: restorationController.identifier.rawValue,
                creator: { coder in
                    return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
            })

            categoryTableViewController.navigationController?.pushViewController(
                menuTableViewController,
                animated: false
            )
            categoryTableViewController.navigationController?.pushViewController(
                menuItemDetailViewController,
                animated: false
            )

        case .order:
            tabBarController.selectedIndex = 1
        }
    }

    // MARK: - State Restoration Activity

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return menuController.userActivity
    }

    // MARK: - Update Order Badge

    @objc
    func updateOrderBadge() {
        switch menuController.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }
}
