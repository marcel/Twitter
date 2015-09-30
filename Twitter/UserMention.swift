//
//  UserMention.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct UserMention: Decodable {
    let screenName: String
    let name: String
    let id: Int

    static func decode(json: JSON) -> Decoded<UserMention> {
      return curry(self.init)
        <^> json <| "screen_name"
        <*> json <| "name"
        <*> json <| "id"
    }
  }
}