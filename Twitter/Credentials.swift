//
//  Credentials.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation

struct Credentials {
  static let defaultCredentialsFile = "Credentials"
  static let defaultCredentials     = Credentials.loadFromPropertyListNamed(defaultCredentialsFile)

  let consumerKey: String
  let consumerSecret: String

  private static func loadFromPropertyListNamed(name: String) -> Credentials {
    let path           = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
    let dictionary     = NSDictionary(contentsOfFile: path)!
    let consumerKey    = dictionary["ConsumerKey"] as! String
    let consumerSecret = dictionary["ConsumerSecret"] as! String

    return Credentials(consumerKey: consumerKey, consumerSecret: consumerSecret)
  }
}