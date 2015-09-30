//
//  User.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct User: Decodable {
    let id: Int
    let name: String
    let screenName: String

    let location: String
    let description: String
    let url: String?

    // Counts
    let followerCount: Int
    let followingCount: Int
    let favoritesCount: Int
    let tweetCount: Int

    let createdAtStr: String
    let isVerified: Bool
    let isProtected: Bool // or comment me out (or any other property) and leave the Delete me line in to fix

    // Profile
    let profileBackgroundImageURL: NSURL
    let profileImageThumbnailURL: NSURL

    // Perspectival
    let isFollowed: Bool // Delete me to fix

    var profileImageURL: NSURL {
      let url = profileImageThumbnailURL.absoluteString
      if let range = url.rangeOfString("_normal", options: .BackwardsSearch) {
        return NSURL(string: url.stringByReplacingCharactersInRange(
          range,
          withString: "_bigger"
        ))!
      } else {
        return profileImageThumbnailURL
      }
    }

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
        <*> json <| "protected" // or comment me out (or any other property) and leave the Delete me line in to fix

      let profile = misc
        <*> json <| "profile_background_image_url_https"
        <*> json <| "profile_image_url_https"

      let perspectival = profile
        <*> json <| "following" // Delete me to fix
      
      return perspectival
    }
  }
}