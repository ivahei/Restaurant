//
//  OrderTableViewCell.swift
//  Restaurant
//
//  Created by Vahe Abazyan on 26.02.22.
//

import UIKit

import Kingfisher

final class OrderTableViewCell: UITableViewCell {

    let menuController = MenuController.shared

    @IBOutlet var orderName: UILabel!
    @IBOutlet var orderPrice: UILabel!
    @IBOutlet var orderImageView: UIImageView!

    func populate(with model: MenuItem) {
        orderName.text = model.name
        orderPrice.text = model.price.formatted(.currency(code: "usd"))
        orderImageView.kf.setImage(with: model.imageURL, placeholder: UIImage(systemName: "trash") )
    }
}
