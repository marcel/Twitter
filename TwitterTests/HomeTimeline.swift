//
//  HomeTimeline.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation

extension Fixture {
  struct HomeTimeline {
    static let tweets = Fixture.loadFromFileNamed("noradio-home-timeline-200-count") as! [NSDictionary]
    static let exampleTweet = tweets[0]
  }
}