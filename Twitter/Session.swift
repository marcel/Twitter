//
//  Session.swift
//  Twitter
//
//  Created by Marcel Molina on 10/2/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import enum Argo.JSON

struct Session {
  typealias Payloads = NSMutableDictionary // NSDictionary<UserId,NSData>
  static var currentSession: Session? = .None

  enum Key: String {
    case Payloads = "user.payloads"
  }

  static func setCurrentSession(user: API.User, payload: NSData) {
    currentSession = Session(user: user, payload: payload)
    currentSession!.storePayload()
  }

  static func loadFromUserId(userId: Int) -> Session? {
    if currentSession?.user.id == userId {
      return currentSession!
    } else {
      let payloads = fetchPayloads()
      if let archivedPayload = payloads.objectForKey(String(userId)) as? NSData {
        let json  = JSON.parse(
          try! NSJSONSerialization.JSONObjectWithData(archivedPayload, options: [])
        )

        return try? API.User.decode(json).map { user in
          let session = Session(user: user, payload: archivedPayload)
          currentSession = session
          return session
        }.dematerialize()
      } else {
        return .None
      }
    }
  }

  private static func fetchPayloads() -> NSMutableDictionary {
    if let archivedData = store.objectForKey(Key.Payloads.rawValue) as? NSData {
      if let unarchived = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData) as? NSMutableDictionary {
        return unarchived
      } else {
        return NSMutableDictionary()
      }
    } else {
      return NSMutableDictionary()
    }
  }

  private static var store: NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }

  private func storePayload() {
    let payloads = Session.fetchPayloads()

    payloads.setObject(payload, forKey: String(user.id))
    let updatedPayloads = NSKeyedArchiver.archivedDataWithRootObject(payloads)
    Session.store.setObject(updatedPayloads, forKey: Key.Payloads.rawValue)
  }

  var user: API.User
  var payload: NSData
}