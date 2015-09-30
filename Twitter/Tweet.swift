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

struct API {}

extension API {
  typealias Indices = [Int]

  struct ExtendedEntities: Decodable {
    let media: [Media]

    static func decode(json: JSON) -> Decoded<ExtendedEntities> {
      return curry(self.init)
        <^> json <|| "media"
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

  struct Media: Decodable {
    let type: String
    let id: Int
    let indices: Indices

    // URLs
    let mediaURL: String
    let url: String
    let displayURL: String
    let expandedURL: String

    // Sizes
    let sizes: Sizes

    // Video info
    let videoInfo: VideoInfo?

    static func decode(json: JSON) -> Decoded<Media> {
      let basicInfo = curry(self.init)
        <^> json <|  "type"
        <*> json <|  "id"
        <*> json <|| "indices"

      let urls = basicInfo
        <*> json <| "media_url_https"
        <*> json <| "url"
        <*> json <| "display_url"
        <*> json <| "expanded_url"

      let sizes = urls
        <*> json <| "sizes"

      let videoInfo = sizes
        <*> json <|? "video_info"

      return videoInfo
    }

    struct Sizes: Decodable {
      let medium: Size
      let large: Size
      let thumb: Size
      let small: Size

      static func decode(json: JSON) -> Decoded<Sizes> {
        return curry(self.init)
          <^> json <| "medium"
          <*> json <| "large"
          <*> json <| "thumb"
          <*> json <| "small"
      }

      struct Size: Decodable {
        let width: Int
        let height: Int
        let resizeInstruction: String

        static func decode(json: JSON) -> Decoded<Size> {
          return curry(self.init)
            <^> json <| "w"
            <*> json <| "h"
            <*> json <| "resize"
        }
      }
    }

    struct VideoInfo: Decodable {
      typealias AspectRatio = [Int]

      let aspectRatio: AspectRatio
      let durationInMillis: Int?
      let variants: [Variant]

      static func decode(json: JSON) -> Decoded<VideoInfo> {
        return curry(self.init)
          <^> json <|| "aspect_ratio"
          <*> json <|? "duration_millis"
          <*> json <|| "variants"
      }

      struct Variant: Decodable {
        let bitrate: Int?
        let contentType: String
        let url: String

        static func decode(json: JSON) -> Decoded<Variant> {
          return curry(self.init)
            <^> json <|? "bitrate"
            <*> json <|  "content_type"
            <*> json <|  "url"
        }
      }
    }
  }

  struct URL: Decodable {
    let url: String
    let expanded: String
    let display: String
    let indices: Indices

    static func decode(json: JSON) -> Decoded<URL> {
      return curry(self.init)
        <^> json <|  "url"
        <*> json <|  "expanded_url"
        <*> json <|  "display_url"
        <*> json <|| "indices"
    }
  }

  struct Hashtag: Decodable {
    let text: String
    let indices: Indices

    static func decode(json: JSON) -> Decoded<Hashtag> {
      return curry(self.init)
        <^> json <|  "text"
        <*> json <|| "indices"
    }
  }

  struct User: Decodable {
    let id: Int
    let name: String
    let screenName: String

    let location: String
    let description: String
    let url: String?
    let areFollowing: Bool

    // Counts
    let followerCount: Int
    let followingCount: Int
    let favoritesCount: Int
    let tweetCount: Int

    let createdAtStr: String
    let isVerified: Bool

    // Profile
    let profileBackgroundImageURL: String
    let profileImageURL: String

    static func decode(json: JSON) -> Decoded<User> {
      let identifiers = curry(self.init)
        <^> json <|  "id"
        <*> json <|  "name"
        <*> json <|  "screen_name"


      let other = identifiers
        <*> json <|  "location"
        <*> json <|  "description"
        <*> json <|? "url"

      let counts = other
        <*> json <| "followers_count"
        <*> json <| "friends_count"
        <*> json <| "favourites_count"
        <*> json <| "statuses_count"

      let misc = counts
        <*> json <| "created_at"
        <*> json <| "verified"
        <*> json <| "protected"

      let profile = misc
        <*> json <| "profile_background_image_url_https"
        <*> json <| "profile_image_url_https"


      return profile
    }
  }

  struct Geo: Decodable {
    let type: String
    let coordinats: [Float]

    static func decode(json: JSON) -> Decoded<Geo> {
      return curry(self.init)
        <^> json <|  "type"
        <*> json <|| "coordinates"
    }
  }

  struct Place: Decodable {
    let id: String
    let url: String
    let type: String
    let name: String
    let fullName: String

    // Country Info
    let countryCode: String
    let country: String

    static func decode(json: JSON) -> Decoded<Place> {
      let basicInfo = curry(self.init)
        <^> json <| "id"
        <*> json <| "url"
        <*> json <| "place_type"
        <*> json <| "name"
        <*> json <| "full_name"

      let countryInfo = basicInfo
        <*> json <| "country_code"
        <*> json <| "country"

      return countryInfo
    }
  }

  struct Tweet: Decodable {
    let id: Int
    let text: String
    let createdAtStr: String // NSDate isn't Decodable yet
    let user: User

    // Optionals
    let entities: Entities?
    let extendedEntities: ExtendedEntities?

    // Retweet
    let retweetedTweetJSON: JSON? // Recursive reference needs to be parsed later
    
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