//
//  Hashtag.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct Hashtag: Entity, Decodable {
    let text: String
    let indices: Indices

    static func decode(json: JSON) -> Decoded<Hashtag> {
      return curry(self.init)
        <^> json <|  "text"
        <*> json <| "indices"
    }
  }
}