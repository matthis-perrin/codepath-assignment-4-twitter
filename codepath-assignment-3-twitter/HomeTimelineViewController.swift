//
//  ViewController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet] = [Tweet]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
                    print(self.tweets[0].author!.profileImageUrl)
                } else {
                    print(error)
                }
                self.tableView.reloadData()
            })
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("tweetTableViewCell") as? TweetTableViewCell {
            let row = indexPath.row
            let tweet = self.tweets[row]
            cell.setTweet(tweet)
            cell.selectionStyle = .None
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tweetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tweetViewController") as? TweetViewController {
            if let navController = self.navigationController {
                navController.pushViewController(tweetViewController, animated: true)
                tweetViewController.setData(self.tweets[indexPath.row])
            }
        }
    }

}

