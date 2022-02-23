//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 10.02.22.
//

import UIKit

final class MenuItemDetailViewController: UIViewController {

    let menuItem: MenuItem

    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var detailTextLabel: UILabel!
    @IBOutlet private var addToOrderButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    func updateUI() {
        nameLabel.text = menuItem.name
        priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
        detailTextLabel.text = menuItem.detailText
    }

    @IBAction func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.1,
            options: [],
            animations: {
                self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
    }
}
