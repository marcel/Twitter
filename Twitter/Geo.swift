//
//  Geo.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension API {
  struct Geo: Decodable {
    let type: String
    let coordinates: [Float]

    static func decode(json: JSON) -> Decoded<Geo> {
      return curry(self.init)
        <^> json <|  "type"
        <*> json <|| "coordinates"
    }
  }

  struct Place: Decodable {
    enum PlaceType: String {
      case POI   = "poi"
      case City  = "city"
      case Admin = "admin" // No idea
    }

    let id: String
    let url: NSURL
    let type: PlaceType
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
}

extension API.Place.PlaceType: Decodable {}