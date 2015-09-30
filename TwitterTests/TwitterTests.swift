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
    let homeTimeline = Fixture.HomeTimeline.tweets

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
      let firstTweets = homeTimeline.prefix(200)
      let tweets = firstTweets.map { tweet in

        try! API.Tweet.decode(JSON.parse(tweet)).dematerialize()
      }

//      } else {
//        XCTFail("Tweet wasn't parsed")
//      }
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
