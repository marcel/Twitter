//
//  API.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation

struct API {
  static let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    // "Wed Sep 30 21:46:10 +0000 2015"
    dateFormatter.dateFormat = "EEE LLL dd kk:mm:ss X y"
    return dateFormatter
  }()

  static func dateFromString(string: String) ->  NSDate? {
    objc_sync_enter(dateFormatter)
    let date = dateFormatter.dateFromString(string)
    objc_sync_exit(dateFormatter)
    return date
  }
}