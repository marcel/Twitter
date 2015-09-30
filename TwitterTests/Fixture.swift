//
//  Fixture.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation

struct Fixture {
  static func loadFromFileNamed(name: String) -> AnyObject {
    let filePath     = NSBundle.mainBundle().pathForResource(name, ofType: "json")!
    let data         = NSData(contentsOfFile: filePath)!

    return try! NSJSONSerialization.JSONObjectWithData(data, options: [])
  }
}