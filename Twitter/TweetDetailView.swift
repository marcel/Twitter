//
//  TweetDetailView.swift
//  Twitter
//
//  Created by Marcel Molina on 10/3/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

class TweetDetailView: UIView {
  var tweet: API.Tweet! {
    didSet {
      let formatter = Formatter(tweet: tweet)

      activityCountsView.layer.borderColor = UIColor.grayColor().CGColor
      activityCountsView.layer.borderWidth = 0.25

      engagementActionButtonsView.layer.borderColor = UIColor.grayColor().CGColor
      engagementActionButtonsView.layer.borderWidth = 0.25

      authorIconView.layer.cornerRadius = 5
      authorIconView.layer.masksToBounds = true
      let user = tweet.user
      authorIconView.setImageWithURL(user.profileImageURL)
      fullNameLabel.text = user.name
      screenNameLabel.text = "@\(user.screenName)"

      tweetTextLabel.text = tweet.text

      timestampLabel.text = formatter.timestamp
      replyTextField.text = "Reply to \(user.name)"
    }
  }

  @IBOutlet weak var authorIconView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var activityCountsView: UIView!
  @IBOutlet weak var retweetCount: UILabel!
  @IBOutlet weak var retweetCountDescriptionLabel: UILabel!
  @IBOutlet weak var favoritesCount: UILabel!
  @IBOutlet weak var favoritesCountDescriptionLabel: UILabel!
  @IBOutlet weak var engagementActionButtonsView: UIView!

  @IBOutlet weak var replyContainerView: UIView!
  @IBOutlet weak var replyTextField: UITextField!

  struct Formatter {
    let tweet: API.Tweet

    static let dateFormatter: NSDateFormatter = {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MM/dd/yy h:mm a"
      return formatter
    }()

    var timestamp: String {
      return Formatter.dateFormatter.stringFromDate(tweet.createdAt)
    }
  }
}
