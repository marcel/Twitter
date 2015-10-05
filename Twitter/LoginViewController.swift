//
//  LoginViewController.swift
//  Twitter
//
//  Created by Marcel Molina on 9/28/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit
import TwitterKit
import enum Argo.JSON

protocol LoginViewControllerDelegate {
  func loginController(loginController: LoginViewController, didLogInUser user: API.User)
}

class LoginViewController: UIViewController {
  var delegate: LoginViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    let logInButton = TWTRLogInButton { session, error in
      if let session = session {
        print("signed in as \(session.userName)")
        self.establishSession(session) { user in
          self.delegate?.loginController(self, didLogInUser: user)
          self.dismissViewControllerAnimated(true, completion: nil)
        }
      } else {
        print("error: \(error!.localizedDescription)")
      }
    }

    logInButton.center = view.center
    view.addSubview(logInButton)
  }

  func establishSession(session: TWTRSession, completion: (API.User -> ())?) {
    let client = TWTRAPIClient(userID: session.userID)
    let userShowEndpoint = "https://api.twitter.com/1.1/users/show.json"

    let userShowRequest = client.URLRequestWithMethod(
      "GET",
      URL: userShowEndpoint,
      parameters: ["user_id": String(session.userID)],
      error: nil
    )

    client.sendTwitterRequest(userShowRequest) { (response, data, connectionError) in

      if (connectionError == nil) {
        let json  = JSON.parse(
          try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
        )


        API.User.decode(json).map { user in
          Session.setCurrentSession(user, payload: data!)
          completion?(user)
        }

      } else {
        print("Couldn't load authenticated user")
      }
    }
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
