//
//  ViewController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController {

    var tweets: [Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.currentUser == nil {
            TwitterClient.sharedInstance.loginWithCompletion() { (user: User?, error: NSError?) in
                if User.currentUser != nil {
                    self.fetchTimeline()
                } else {
                    print(error)
                }
            }
        } else {
            self.fetchTimeline()
        }
    }
    
    private func fetchTimeline() {
        if User.currentUser != nil {
            TwitterClient.sharedInstance.home_timeline(nil, completion: { (tweets, error) -> Void in
                if let tweets = tweets {
                    self.tweets = tweets
                    print(self.tweets.count)
                } else {
                    print(error)
                }
//                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

