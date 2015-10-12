//
//  MenuDrawerCell.swift
//  Twitter
//
//  Created by Marcel Molina on 10/10/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

class MenuDrawerCell: UITableViewCell {
  static let identifier = "MenuDrawerCell"
  
  @IBOutlet weak var menuItemLabel: UILabel!
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
