//
//  Session.swift
//  Twitter
//
//  Created by Marcel Molina on 10/2/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation

struct Session {
  static var currentSession: Session? = .None

  static func setCurrentSession(user: API.User) {
    currentSession = Session(user: user)
  }

  var user: API.User? = .None
}