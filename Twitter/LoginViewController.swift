//
//  LoginViewController.swift
//  Twitter
//
//  Created by Marcel Molina on 9/28/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let logInButton = TWTRLogInButton { session, error in
      if let session = session {
        print("signed in as \(session.userName)")
      } else {
        print("error: \(error!.localizedDescription)")
      }
    }

    logInButton.center = view.center
    view.addSubview(logInButton)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
