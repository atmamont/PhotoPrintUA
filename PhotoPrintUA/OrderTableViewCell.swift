//
//  OrderTableViewCell.swift
//  PhotoPrintUA
//
//  Created by atMamont on 13.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
