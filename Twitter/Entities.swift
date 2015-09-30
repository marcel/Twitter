//
//  Entities.swift
//  Twitter
//
//  Created by Marcel Molina on 9/30/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  typealias Indices = [Int]

  struct Entities: Decodable {
    let userMentions: [UserMention]?
    let media: [Media]?
    let urls: [URL]?
    let hashtags: [Hashtag]?

    static func decode(json: JSON) -> Decoded<Entities> {
      return curry(self.init)
        <^> json <||? "user_mentions"
        <*> json <||? "media"
        <*> json <||? "urls"
        <*> json <||? "hashtags"
    }
  }

  struct ExtendedEntities: Decodable {
    let media: [Media]

    static func decode(json: JSON) -> Decoded<ExtendedEntities> {
      return curry(self.init)
        <^> json <|| "media"
    }
  }
}