//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import UIKit

final class OrderTableViewController: UITableViewController {
    let menuController = MenuController.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = tableView else { fatalError() }

        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(
            tableView,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification, object: nil
        )
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuController.order.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "OrderCell",
            for: indexPath
        ) as? OrderTableViewCell else { fatalError() }

        let model = menuController.order.menuItems[indexPath.row]
        cell.populate(with: model)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            menuController.order.menuItems.remove(at: indexPath.row)
        }
    }
}