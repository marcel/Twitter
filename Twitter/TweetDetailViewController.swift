//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Marcel Molina on 10/3/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

  var tweet: API.Tweet!
  @IBOutlet var tweetDetailView: TweetDetailView!
    override func viewDidLoad() {
        super.viewDidLoad()
      tweetDetailView.tweet = tweet.primaryTweet
//      tweetDetailView.tweetTextLabel.preferredMaxLayoutWidth = 359
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
