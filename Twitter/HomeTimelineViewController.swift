//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Marcel Molina on 9/28/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
import TwitterKit
import Argo

class HomeTimelineViewController: UIViewController,
  UITableViewDelegate, UITableViewDataSource,
  TweetComposeViewControllerDelegate,
  LoginViewControllerDelegate {

  @IBOutlet weak var tableView: UITableView!

  var tweets: [API.Tweet] = []
  var client: TWTRAPIClient!
  var loginViewController = LoginViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    loginViewController.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension

    let titleView = UIImageView(image: UIImage(named: "blue-bird.png"))
    titleView.tintColor = UIColor.twitterBlueColor()
    let navigationBarHeight = navigationController?.navigationBar.frame.size.height
    let titleViewIconDimention = (navigationBarHeight ?? 44) * 0.75
    titleView.frame = CGRectMake(0, 0, titleViewIconDimention, titleViewIconDimention)
    titleView.contentMode = UIViewContentMode.ScaleAspectFill
    navigationItem.titleView = titleView
    tableView.estimatedRowHeight = 200

    let store = Twitter.sharedInstance().sessionStore

    if let userID = store.session()?.userID {
      if let _ = Session.loadFromUserId(Int(userID)!) {
        client = TWTRAPIClient(userID: userID)
        loadHometimeline()
      } else {
        attemptLogin()
      }
    } else {
      attemptLogin()
    }
  }

  func loadHometimeline() {
    let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    var clientError: NSError?
    let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: [:], error: &clientError)

    client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
      if (connectionError == nil) {
        let json  = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [NSDictionary]
        self.tweets = json.flatMap { tweetJson in
          return try? API.Tweet.decode(JSON.parse(tweetJson)).dematerialize()
        }
        self.reloadData()
        debugPrint(json)
      } else {
        print("Error: \(connectionError)")
      }
    }
  }

  func reloadData() {
    tableView.reloadData()
  }

  func attemptLogin() {
    presentViewController(loginViewController, animated: true, completion: .None)
  }

  func loginController(loginController: LoginViewController, didLogInUser user: API.User) {
    client = TWTRAPIClient(userID: String(user.id))
    loadHometimeline()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier(
      TweetCell.identifier,
      forIndexPath: indexPath
    ) as! TweetCell

    cell.tweet = tweets[indexPath.row]

    return cell
  }

  enum Segue: String {
    case HomeTimelineToTweetCompose
    case TimelineToTweetDetail
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print("segue", segue)
    switch segue.identifier {
    case .Some(Segue.HomeTimelineToTweetCompose.rawValue):
      print("Segueing to tweet compose")
      let tweetComposeViewController = segue.destinationViewController as! TweetComposeViewController
      tweetComposeViewController.delegate = self
    case .Some(Segue.TimelineToTweetDetail.rawValue):
      print("Segueing to tweet detail view")
      let tapRecognizer = sender as! UITapGestureRecognizer
      let tapPoint      = tapRecognizer.locationInView(tableView)
      let indexPath     = tableView.indexPathForRowAtPoint(tapPoint)!
      let tappedTweet   = tweets[indexPath.row]
      let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController

      tweetDetailViewController.tweet = tappedTweet
    default:
      ()
    }
  }

  // MARK: - TweetComposeViewControllerDelegate

  func tweetComposeController(
    composeController: TweetComposeViewController,
    didCreateTweet tweet: API.Tweet
  ) {
    print("Tweet was created", tweet)
  }
}

struct Fixture {
  static func loadFromFileNamed(name: String) -> [NSDictionary] {
    let filePath     = NSBundle.mainBundle().pathForResource(name, ofType: "json")!
    let data         = NSData(contentsOfFile: filePath)!

    return try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! [NSDictionary]
  }
}

struct HomeTimeline {
  static let tweets = Fixture.loadFromFileNamed("noradio-home-timeline-50-count").map {
    return try! API.Tweet.decode(JSON.parse($0)).dematerialize()
  }
}
