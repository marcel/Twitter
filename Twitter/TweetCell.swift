//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Marcel Molina on 9/28/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
  static let identifier = "TweetCell"

  var tweet: Tweete! {
    didSet {
      tweetTextLabel.text = tweet.text
      userIconImageView.setImageWithURL(tweet.userIconURL)
      // set callback to handle images that are larger than the image view
      // something like this
//      imageView.contentMode = UIViewContentModeCenter;
//      if (imageView.bounds.size.width > ((UIImage*)imagesArray[i]).size.width && imageView.bounds.size.height > ((UIImage*)imagesArray[i]).size.height) {
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//      }
    }
  }
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var userIconImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()

    configureStyles()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }


  func configureStyles() {
    let iconLayer = userIconImageView.layer
    iconLayer.cornerRadius = 5
  }
}
