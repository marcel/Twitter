//
//  TweetOriginContextView.swift
//  Twitter
//
//  Created by Marcel Molina on 10/1/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

class TweetOriginContextView: UIView {
  @IBOutlet weak var originActionIconView: UIImageView!
  @IBOutlet weak var originActionLabel: UILabel!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!

  var tweet: API.Tweet! {
    didSet {
      guard tweet.isRetweet || tweet.isReply else {
        heightConstraint.constant = 0
        self.hidden = true
        return
      }

      heightConstraint.constant = 24
      self.hidden = false

      if tweet.isRetweet {
        originActionLabel.text = "\(tweet.user.name) Retweeted"
        originActionIconView.image = UIImage(named: "retweet-default.png")
      } else if tweet.isReply {
        originActionLabel.text = "in reply to @\(tweet.inReplyToScreenName!)"
        originActionIconView.image = UIImage(named: "reply-default.png")
      }
    }
  }
}
