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

protocol Entity {}

extension API {
  struct Indices: Decodable {
    let start: Int
    let end: Int

    var length: Int {
      return end - start
    }

    var asRange: NSRange {
      return NSMakeRange(start, length)
    }
    
    static func decode(j: JSON) -> Decoded<Indices> {
      switch j {
        case let .Array(a):
          return sequence(a.map(Int.decode)).value.map { ints in
            if ints.count == 2 {
              return .Success(Indices(start: ints[0], end: ints[1]))
            } else {
              return .typeMismatch("Array", actual: j)
            }
          }!
        default: return .typeMismatch("Array", actual: j)
      }
    }
  }

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