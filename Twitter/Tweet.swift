//
//  Tweet.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct Tweet: Decodable {
    let id: Int
    let text: String
    let createdAtStr: String // NSDate isn't Decodable

    var createdAt: NSDate {
      return API.dateFromString(createdAtStr)!
    }

    let user: User

    // Optionals
    let entities: Entities?
    let extendedEntities: ExtendedEntities?

    var hasInlineImage: Bool {
      return extendedEntities.flatMap { entities in
        entities.media.first.map {
          $0.type == API.Media.MediaType.Photo
        }
      } ?? false
    }

    // Retweet
    let retweetedTweetJSON: JSON? // Recursive reference needs to be parsed lazily
    
    var retweetedTweet: Tweet? {
      return retweetedTweetJSON.map {
        try! Tweet.decode($0).dematerialize()
      }
    }
  
    var isRetweet: Bool {
      return retweetedTweetJSON != nil
    }

    // Predicates
    let isQuoteTweet: Bool

    // Counts
    let retweetCount: Int
    let favoriteCount: Int

    // Reply Info
    let inReplyToTweetId: Int?
    let inReplyToUserId: Int?
    let inReplyToScreenName: String?

    var isReply: Bool {
      return inReplyToTweetId != nil
    }

    // Geo
    let geo: Geo?
    let place: Place?

    static func decode(json: JSON) -> Decoded<Tweet> {
      let basicInfo = curry(self.init)
        <^> json <| "id"
        <*> json <| "text"
        <*> json <| "created_at"
        <*> json <| "user"

      let optionals = basicInfo
        <*> json <|? "entities"
        <*> json <|? "extended_entities"

      let retweet = optionals
        <*> json <|? "retweeted_status"

      let predicates = retweet
        <*> json <| "is_quote_status"

      let counts = predicates
        <*> json <| "retweet_count"
        <*> json <| "favorite_count"

      let replyInfo = counts
        <*> json <|? "in_reply_to_status_id"
        <*> json <|? "in_reply_to_user_id"
        <*> json <|? "in_reply_to_screen_name"

      let place = replyInfo
        <*> json <|? "geo"
        <*> json <|? "place"

      return place
    }
  }
}