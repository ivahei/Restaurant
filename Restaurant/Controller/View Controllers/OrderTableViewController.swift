//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import UIKit

final class OrderTableViewController: UITableViewController {
    let menuController = MenuController.shared

    var minutesToPrepareOrder = 0

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = tableView else { fatalError() }

        NotificationCenter.default.addObserver(
            tableView,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification, object: nil
        )

        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkContent(of: menuController.order.menuItems)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Check Content of menuItems

    func checkContent(of menuItems: [MenuItem]) {
        if menuItems.isEmpty {
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    // MARK: - Confirm Order Segue

    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }

    @IBAction func submitTapped(_ sender: Any) {
        let orderTotal = menuController.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }

        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))

        let alertController = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedTotal)",
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            self?.uploadOrder()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        Task.init {
            do {
                let minutesToPrepare = try await
                menuController.sendRequest(SubmitOrder(menuIDs: menuIds))
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
    }

    func displayError(_ error: Error, title: String) {
        if viewIfLoaded?.window != nil {
            let alert = UIAlertController(
                title: title,
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - TableViewController Methods

extension OrderTableViewController {

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
            checkContent(of: menuController.order.menuItems)
        }
    }
}
