//
//  MenuDrawerSegue.swift
//  Twitter
//
//  Created by Marcel Molina on 10/10/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

class MenuDrawerSegue: UIStoryboardSegue {
  override func perform() {
    print("performing segue")

    sourceViewController.addChildViewController(destinationViewController)

    UIView.animateWithDuration(1, animations: {
      self.sourceViewController.view.frame.origin.x = self.sourceViewController.view.frame.size.width - 40
    })
  }
}
