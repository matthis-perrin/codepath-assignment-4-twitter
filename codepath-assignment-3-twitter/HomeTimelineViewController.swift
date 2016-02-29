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
    private var isMentions: Bool = false
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.fetchTimeline()
    }
    
    func setIsMentions(isMentions: Bool) {
        self.isMentions = isMentions
        self.fetchTimeline()
    }
    
    private func reloadUI() {
        self.view.layoutIfNeeded()
        CATransaction.begin()
        CATransaction.setCompletionBlock({ () -> Void in
            self.refreshControl.endRefreshing()
        })
        self.tableView.reloadData()
        CATransaction.commit()
    }
    
    private func fetchTimeline() {
        if isMentions {
            TwitterClient.sharedInstance.mentions(nil, completion: { (tweets, error) -> Void in
                if let tweets = tweets {
                    self.tweets = tweets
                } else {
                    print(error)
                }
                self.reloadUI()
            })
        } else {
            if User.currentUser != nil {
                TwitterClient.sharedInstance.home_timeline(nil, completion: { (tweets, error) -> Void in
                    if let tweets = tweets {
                        self.tweets = tweets
                    } else {
                        print(error)
                    }
                    self.reloadUI()
                })
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.fetchTimeline()
    }
    
    func delay(delay: Double, closure: () -> Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
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
        if let profileViewNavController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? UINavigationController {
            if let profileViewController = profileViewNavController.viewControllers[0] as? ProfileViewController {
                if let navController = self.navigationController {
                    navController.pushViewController(profileViewController, animated: true)
                    profileViewController.setData(self.tweets[indexPath.row].author!)
                }
            }
        }
    }

}

