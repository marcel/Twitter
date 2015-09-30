//
//  NSURL.swift
//  Twitter
//
//  Created by Marcel Molina on 9/30/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import Argo
import Curry

extension NSURL: Decodable {
  public typealias DecodedType = NSURL

  public class func decode(j: JSON) -> Decoded<NSURL> {
    switch j {
    case .String(let urlString):
      return NSURL(string: urlString).map(pure) ?? .typeMismatch("URL", actual: j)
    default: return .typeMismatch("URL", actual: j)
    }
  }
}