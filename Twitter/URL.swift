//
//  URL.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct URL: Entity, Decodable {
    let url: NSURL
    let expanded: String
    let display: String
    let indices: Indices

    static func decode(json: JSON) -> Decoded<URL> {
      return curry(self.init)
        <^> json <|  "url"
        <*> json <|  "expanded_url"
        <*> json <|  "display_url"
        <*> json <| "indices"
    }
  }
}