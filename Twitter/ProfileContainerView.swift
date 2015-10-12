//
//  ProfileContainerView.swift
//  Twitter
//
//  Created by Marcel Molina on 10/11/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

class ProfileContainerView: UIView {
  var user: API.User! {
    didSet {
      backgroundImageView.setImageWithURL(user.profileBackgroundImageURL)
      avatarImageView.setImageWithURL(user.profileImageURL)
      userNameLabe.text = user.name
      screenNameLabel.text = "@\(user.screenName)"
      profileLabel.text = user.description
      locationLabel.text = user.location
      followerCountLabel.text = String(user.followerCount)
      followingCountLabel.text = String(user.followingCount)
      avatarImageView.layer.cornerRadius = 5
      avatarImageView.layer.masksToBounds = false
      avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
      avatarImageView.layer.borderWidth = 2.0
    }
  }
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var userNameLabe: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var profileLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var followerCountLabel: UILabel!
}
