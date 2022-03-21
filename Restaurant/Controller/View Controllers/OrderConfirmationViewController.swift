//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 27.02.22.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    let menuController = MenuController.shared
    let minutesToPrepare: Int
    @IBOutlet private var confirmationLabel: UILabel!

    init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = String.getConfirmationText(minutes: minutesToPrepare)
    }

    @IBAction func dismissAction(_ sender: Any) {
        menuController.order.menuItems.removeAll()
        self.performSegue(withIdentifier: "unwindToCategoryVC", sender: nil)
    }
}

private extension String {
    static func getConfirmationText(minutes: Int) -> String {
        "Thank you for your order! Your wait time is approximately \(minutes) minutes."
    }
}
