//
//  OrderTableViewCell.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 26.02.22.
//

import UIKit

final class OrderTableViewCell: UITableViewCell {

    @IBOutlet var orderName: UILabel!
    @IBOutlet var orderPrice: UILabel!

    func populate(with model: MenuItem) {
        orderName.text = model.name
        orderPrice.text = model.price.formatted(.currency(code: "usd"))
    }

}
