//
//  TwitterTests.swift
//  TwitterTests
//
//  Created by Marcel Molina on 9/28/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import XCTest
import Argo
@testable import Twitter

class TwitterTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testFullTimelineIsParsedWithNoExceptions() {
    let tweets = Fixture.HomeTimeline.tweets.map { tweet in
      try! API.Tweet.decode(JSON.parse(tweet)).dematerialize()
    }

    XCTAssert(true)
  }
}
