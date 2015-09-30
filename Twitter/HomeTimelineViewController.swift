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

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

//  var tweets: [API.Tweet] = [] // TODO Make Timeline struct
  var tweets = HomeTimeline.tweets

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    let titleView = UIImageView(image: UIImage(named: "blue-bird.png"))
    let navigationBarHeight = navigationController?.navigationBar.frame.size.height
    let titleViewIconDimention = (navigationBarHeight ?? 44) * 0.75
    titleView.frame = CGRectMake(0, 0, titleViewIconDimention, titleViewIconDimention)
    titleView.contentMode = UIViewContentMode.ScaleAspectFill
    navigationItem.titleView = titleView
//    let store = Twitter.sharedInstance().sessionStore
//
//    if let userID = store.session()?.userID {
//      let client = TWTRAPIClient(userID: userID)
//      debugPrint("userId", userID)
//      let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
//      var clientError : NSError?
//
//      let rateLimitUrl = "https://api.twitter.com/1.1/application/rate_limit_status.json"
//      let rateLimitRequest = client.URLRequestWithMethod("GET", URL: rateLimitUrl, parameters: ["resources":"statuses"], error: nil)
//      client.sendTwitterRequest(rateLimitRequest) { (response, data, connectionError) -> Void in
//        if (connectionError == nil) {
//          let json  = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
//          print("Rate limit info: ")
//          debugPrint(json)
//        } else {
//          print("Rate limit request failed: \(connectionError)")
//        }
//      }
//
//      let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: [:], error: &clientError)
//
//      client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
//        if (connectionError == nil) {
//          let json  = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [NSDictionary]
//          self.tweets = json.map { tweetJson in
//            let imageUrl = tweetJson.valueForKeyPath("user.profile_image_url_https") as! String
//            let tweetText = tweetJson["text"] as! String
//
//            return Tweete(text: tweetText, userIconURL: NSURL(string: imageUrl)!)
//          }
//          self.reloadData()
////          debugPrint(json)
//        } else {
//          print("Error: \(connectionError)")
//        }
//      }
//    }

//    presentViewController(LoginViewController(), animated: true, completion: .None)
  }

  func reloadData() {
    tableView.reloadData()
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

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
