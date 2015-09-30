//
//  Media.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct Media: Entity, Decodable {
    enum MediaType: String {
      case Video       = "video"
      case Photo       = "photo"
      case AnimatedGIF = "animated_gif"
    }

    let type: MediaType
    let id: Int
    let indices: Indices

    // URLs
    let mediaURL: NSURL
    let url: NSURL
    let displayURL: NSURL
    let expandedURL: NSURL

    // Sizes
    let sizes: Sizes

    // Video info
    let videoInfo: VideoInfo?

    static func decode(json: JSON) -> Decoded<Media> {
      let basicInfo = curry(self.init)
        <^> json <|  "type"
        <*> json <|  "id"
        <*> json <| "indices"

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
        enum ResizeInstruction: String {
          case Fit  = "fit"
          case Crop = "crop"
        }

        let width: Int
        let height: Int
        let resizeInstruction: ResizeInstruction

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
}

extension API.Media.Sizes.Size.ResizeInstruction: Decodable {}
extension API.Media.MediaType: Decodable {}
