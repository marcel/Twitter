//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Marcel Molina on 10/11/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
import TwitterKit
import enum Argo.JSON

class ProfileViewController: UIViewController, UITableViewDataSource {
  var user: API.User!
  var timeline: [API.Tweet] = []
  var client: TWTRAPIClient!

  @IBOutlet weak var userTimelineTableView: UITableView!
  @IBOutlet weak var profileContainerView: ProfileContainerView!

  override func viewDidLoad() {
    super.viewDidLoad()
    userTimelineTableView.rowHeight = UITableViewAutomaticDimension
    userTimelineTableView.estimatedRowHeight = 200
    userTimelineTableView.dataSource = self
    profileContainerView.user = user
    profileContainerView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.0)

    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
    navigationController?.navigationBar.translucent = true
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.setNavigationBarHidden(false, animated:true)
    navigationItem.backBarButtonItem?.title = ""
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.backItem?.title = ""

    loadUserTimeline()
  }

  func loadUserTimeline(completion: (() -> ())? = .None) {
    let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    var clientError: NSError?
    let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: ["user_id": String(user.id)], error: &clientError)

    client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
      if (connectionError == nil) {
        let json  = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [NSDictionary]
        self.timeline = json.flatMap { tweetJson in
          return try? API.Tweet.decode(JSON.parse(tweetJson)).dematerialize()
        }
        self.reloadData()
        completion?()
        debugPrint(json)
      } else {
        print("Error: \(connectionError)")
      }
    }
  }

  func reloadData() {
    userTimelineTableView.reloadData()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeline.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(TweetCell.identifier, forIndexPath: indexPath) as! TweetCell
    let tweet = timeline[indexPath.row]
    cell.tweet = tweet

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
