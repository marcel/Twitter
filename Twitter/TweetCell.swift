//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Marcel Molina on 9/28/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTextLabel: UILabel {
  var tweet: API.Tweet! {
    didSet {
      layoutText()
    }
  }

  func layoutText() {
    // TODO
  }
}

class TweetCell: UITableViewCell {
  static let identifier = "TweetCell"

  var tweet: API.Tweet! {
    didSet {
      userIconImageView.image = nil

      let primaryTweet = tweet.isRetweet ? tweet.retweetedTweet! : tweet

      let tweetText = NSMutableAttributedString(string: primaryTweet.text.stringByRemovingPercentEncoding!)

      if let entities = primaryTweet.entities {
        if let hashtags = entities.hashtags {
          hashtags.forEach { hashtag in
            tweetText.addAttribute(
              NSForegroundColorAttributeName,
              value: UIColor.twitterBlueColor(),
              range: hashtag.indices.asRange
            )
          }
        }

        if let urls = entities.urls {
          urls.forEach { url in
            let displayUrl = NSMutableAttributedString(string: url.display)
            displayUrl.addAttribute(NSForegroundColorAttributeName, value: UIColor.twitterBlueColor(), range: NSMakeRange(0, url.display.characters.count))
            tweetText.replaceCharactersInRange(url.indices.asRange, withAttributedString: displayUrl)
          }
        }

        if let mentions = entities.userMentions {
          mentions.forEach { mention in
            let screenName = NSMutableAttributedString(string: "@\(mention.screenName)")
            screenName.addAttribute(NSForegroundColorAttributeName, value: UIColor.twitterBlueColor(), range: NSMakeRange(0, mention.screenName.characters.count + 1))
            tweetText.replaceCharactersInRange(mention.indices.asRange, withAttributedString: screenName)
          }
        }
      }
//      primaryTweet.entities.map { entities in
//        entities.hashtags.flatMap { hashTag in
//        }
//      }
//      [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
//      [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5,6)];
//      [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11,5)];

      tweetTextLabel.attributedText = tweetText
      userNameLabel.text = primaryTweet.user.name
      userScreenNameLabel.text = "@\(primaryTweet.user.screenName)"

      let cachedRequest = CachedRequest(url: primaryTweet.user.profileImageURL)
      userIconImageView.setImageWithURLRequest(
        cachedRequest,
        placeholderImage: nil,
        success: { request, response, image in
          self.userIconImageView.image = image
        }, failure: nil // TODO Failure case
      )

      // set callback to handle images that are larger than the image view
      // something like this
//      imageView.contentMode = UIViewContentModeCenter;
//      if (imageView.bounds.size.width > ((UIImage*)imagesArray[i]).size.width && imageView.bounds.size.height > ((UIImage*)imagesArray[i]).size.height) {
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//      }
    }
  }
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var userIconImageView: UIImageView!
  @IBOutlet weak var timeSinceTweetCreation: UILabel!
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
