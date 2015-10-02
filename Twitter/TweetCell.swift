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

  @IBOutlet weak var originContextView: TweetOriginContextView!
  @IBOutlet weak var inlineImageView: UIImageView!
  @IBOutlet weak var inlineImageHeight: NSLayoutConstraint!

  var tweet: API.Tweet! {
    didSet {
      userIconImageView.image = nil

      originContextView.tweet = tweet

      let primaryTweet = tweet.isRetweet ? tweet.retweetedTweet! : tweet
      let formatter = Formatter(tweet: primaryTweet)
      timeSinceTweetCreation.text = formatter.timeSinceCreationInWords()

      setInlineImage(primaryTweet)

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
      retweetCountLabel.text = primaryTweet.retweetCount == 0 ? "" : "\(primaryTweet.retweetCount)"
      favoriteCountLabel.text = primaryTweet.favoriteCount == 0 ? "" : "\(primaryTweet.favoriteCount)"

      setNeedsLayout()
    }
  }
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var userIconImageView: UIImageView!
  @IBOutlet weak var timeSinceTweetCreation: UILabel!

  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var favoriteCountLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    separatorInset = UIEdgeInsetsZero
    configureStyles()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func setInlineImage(tweet: API.Tweet) {
    if tweet.hasInlineImage {
      inlineImageHeight.constant = 172
      inlineImageView.hidden = false
      let mediaURL = tweet.extendedEntities!.media[0].mediaURL
      print("Inline image at url: \(mediaURL.absoluteString)")
      inlineImageView.setImageWithURL(mediaURL)
      // TODO Remove URL from tweet text
    } else {
      inlineImageHeight.constant = 0
      inlineImageView.hidden = true
    }
  }

  func configureStyles() {
    let iconLayer = userIconImageView.layer
    iconLayer.cornerRadius = 5
    inlineImageView.layer.cornerRadius = 5
    inlineImageView.layer.masksToBounds = true
  }

  struct Formatter {
    let tweet: API.Tweet
    static let dateFormatter: NSDateFormatter = {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MM/dd/yy"
      return formatter
    }()

    // Tweet created at in timeline is 1-59s then 1m-59m then 1h-23h then 1d-6d then 9/22/15
    func timeSinceCreationInWords() -> String {
      let createdAt = tweet.createdAt
      let timeSince = Int(NSDate().timeIntervalSinceDate(createdAt))

      switch timeSince {
      case 0..<Duration.minute:
        return "\(timeSince)s"
      case Duration.minute..<Duration.hour:
        return "\(timeSince / Duration.minute)m"
      case Duration.hour..<Duration.day:
        return "\(timeSince / Duration.hour)h"
      case Duration.day..<Duration.week:
        return "\(timeSince / Duration.day)d"
      default:
        return formateDate(createdAt)
      }
    }

    private func formateDate(date: NSDate) -> String {
      objc_sync_enter(Formatter.dateFormatter)
      let result = Formatter.dateFormatter.stringFromDate(date)
      objc_sync_exit(Formatter.dateFormatter)
      return result
    }

    struct Duration {
      static let minute = 60
      static let hour   = minute * minute
      static let day    = hour   * 24
      static let week   = day    * 7
      static let month  = day    * 31
      static let year   = month  * 12
    }
  }

}
