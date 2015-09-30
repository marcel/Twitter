//
//  main.swift
//  Twitter
//
//  Created by Marcel Molina on 9/29/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation
import UIKit


func isRunningTests() -> Bool {
  let environment = NSProcessInfo.processInfo().environment
  if let injectBundle = environment["XCInjectBundle"] {
    return NSURL(string: injectBundle)!.pathExtension == "xctest"
  }
  return false
}

class UnitTestsAppDelegate: UIResponder, UIApplicationDelegate { }

let appDelegateClass = isRunningTests() ? NSStringFromClass(UnitTestsAppDelegate) : NSStringFromClass(AppDelegate)

UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), appDelegateClass)
