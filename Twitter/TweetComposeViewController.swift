//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Marcel Molina on 9/30/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
protocol TweetComposeViewControllerDelegate {
  func tweetComposeController(
    composeController: TweetComposeViewController,
    didCreateTweet tweet: API.Tweet
  )
}

class TweetComposeViewController: UIViewController, UITextViewDelegate {
  static let characterLimit  = 140
  static let placeholderText = "What's Happening?"

  @IBOutlet weak var authorIconView: UIImageView!
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var controlView: UIView!
  @IBOutlet weak var characterLimitLabel: UILabel!
  @IBOutlet weak var tweetButton: UIButton!
  @IBOutlet weak var dismissButton: UIButton!

  @IBOutlet weak var distanceOfControlViewToBottom: NSLayoutConstraint!

  @IBAction func onDismissButtonTap(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func onTweetButtonTap(sender: AnyObject) {
    print("Tweeted! -> '\(tweetTextTrimmingWhitespace)'")
  }

  private var typingHasOccurred = false
  private var characterLimitWarningThreshold = 10

  var delegate: TweetComposeViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let authorIconURL = Session.currentSession?.user?.profileImageThumbnailURL {
      authorIconView.setImageWithURL(authorIconURL)
    }
    registerKeyboardNotification()

    tweetTextView.delegate = self
    tweetTextView.text = TweetComposeViewController.placeholderText
    tweetTextView.selectedRange = NSMakeRange(0, 0)
    tweetTextView.textColor = UIColor.grayColor()
    tweetTextView.becomeFirstResponder()

    tweetButton.layer.cornerRadius = 5
    authorIconView.layer.cornerRadius = 5
    controlView.layer.borderColor = UIColor.grayColor().CGColor
    controlView.layer.borderWidth = 0.25

    tweetButton.enabled = tweetButtonShouldBeEnabled()
  }

  func registerKeyboardNotification() {
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWasShown:",
      name: UIKeyboardDidShowNotification,
      object: nil
    )
  }

  func keyboardWasShown(aNotification: NSNotification) {
    let info = aNotification.userInfo!
    print("Current control view frame: \(controlView.frame)")
    if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      distanceOfControlViewToBottom.constant = keyboardSize.height

      view.setNeedsUpdateConstraints()
      UIView.animateWithDuration(0.4, animations: {
        self.view.layoutIfNeeded()
      })
    } else {
      print("No kayboard frame info")
    }
  }

  func tweetButtonShouldBeEnabled() -> Bool {
    return typingHasOccurred && tweetTextTrimmingWhitespace.characters.count > 0
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func textViewDidChange(textView: UITextView) {
    if !typingHasOccurred {
      let text = textView.text
      let range          = Range(
        start: text.startIndex,
        end: text.startIndex.advancedBy(1)
      )
      textView.text      = text.substringWithRange(range)
      textView.textColor = UIColor.blackColor()
    }

    typingHasOccurred = true

    tweetButton.enabled = tweetButtonShouldBeEnabled()
    updateCharacterCounter()

    prohibitExceedingCharacterLimit()
  }

  func prohibitExceedingCharacterLimit() {
    if charactersRemaining < 0 {
      let text = tweetTextView.text
      let range = Range(start: text.startIndex, end: text.endIndex.advancedBy(-1))
      tweetTextView.text = text.substringWithRange(range)
    }
  }

  var charactersRemaining: Int {
    return TweetComposeViewController.characterLimit - tweetTextView.text.characters.count
  }

  var tweetTextTrimmingWhitespace: String {
    return tweetTextView.text.stringByTrimmingCharactersInSet(
      NSCharacterSet.whitespaceCharacterSet()
    )
  }

  func updateCharacterCounter() {
    let textColor = charactersRemaining <= characterLimitWarningThreshold ?
      UIColor.redColor() : UIColor.grayColor()

    characterLimitLabel.textColor = textColor

    if charactersRemaining < 0 {
      let rotationAngle = CGFloat(M_PI_2/3)

      UIView.animateWithDuration(0.15, animations: {
        UIView.setAnimationRepeatCount(2)
        self.characterLimitLabel.transform = CGAffineTransformMakeScale(2, 2)

        self.rotateCharacterLimitByAngle(-rotationAngle)
        self.rotateCharacterLimitByAngle(rotationAngle * 2)
        self.rotateCharacterLimitByAngle(-rotationAngle * 2)
        }, completion: { _ in
          self.characterLimitLabel.transform = CGAffineTransformMakeRotation(0)
        }
      )
    }
    characterLimitLabel.text = "\(max(0, charactersRemaining))"
  }

  func rotateCharacterLimitByAngle(angle: CGFloat) {
    characterLimitLabel.transform = CGAffineTransformRotate(
      characterLimitLabel.transform,
      angle
    )
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print("prepare for segue")
  }
  override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
    print("unwinding")
    return .None
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
