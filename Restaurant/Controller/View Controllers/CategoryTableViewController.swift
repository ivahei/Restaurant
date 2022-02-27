//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import UIKit

final class CategoryTableViewController: UITableViewController {
    let menuController = MenuController.shared
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - API Request Task

        Task {
            do {
                let categories = try await menuController.sendRequest(CategoryRequest())
                updateUI(with: categories)
            } catch {
                displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }

    // MARK: - Update UI

    func updateUI(with categories: [String]) {
        self.categories = categories
        self.tableView.reloadData()
    }

    // MARK: - Error Handling

    func displayError(_ error: Error, title: String) {
        if viewIfLoaded?.window == nil { return }

        let alert = UIAlertController(
            title: title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true)
    }

    // MARK: - ShowMenu Segue Action

    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else { return nil }

        let category = categories[indexPath.row]
        return MenuTableViewController(coder: coder, category: category)
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
}

    // MARK: - Table View Methods

extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        configureCell(cell, forCategoryAt: indexPath)

        return cell
    }

    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.capitalized
        cell.contentConfiguration = content
    }
}
