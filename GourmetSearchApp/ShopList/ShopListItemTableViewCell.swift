//
//  ShopListItemTableViewCell.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 6/20/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit

class ShopListItemTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var location: UILabel!

    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var locationWidth: NSLayoutConstraint!
    @IBOutlet weak var locationX: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}