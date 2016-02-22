//
//  TweetViewController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

class TweetViewController: UIViewController {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyIconImageView: UIImageView!
    @IBOutlet weak var retweetIconImageView: UIImageView!
    @IBOutlet weak var favoriteIconImageView: UIImageView!
    
    private var tweet: Tweet!
    
    func setData(tweet: Tweet) {
        self.tweet = tweet
    }
    
    override func viewDidLoad() {
        self.updateUI()
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onRetweetTap")
        self.retweetIconImageView.userInteractionEnabled = true
        self.retweetIconImageView.addGestureRecognizer(retweetTapGestureRecognizer)
        let favoriteTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onFavoriteTap")
        self.favoriteIconImageView.userInteractionEnabled = true
        self.favoriteIconImageView.addGestureRecognizer(favoriteTapGestureRecognizer)
    }
    
    private func updateUI() {
        if let author = self.tweet?.author {
            if let profileImageUrlString = author.profileImageUrl {
                if let profileImageUrl = NSURL(string: profileImageUrlString) {
                    self.authorImageView.setImageWithURL(profileImageUrl)
                } else {
                    self.authorImageView.image = nil
                }
            } else {
                self.authorImageView.image = nil
            }
            self.authorNameLabel.text = author.name
            self.authorUsernameLabel.text = author.screenName
        } else {
            self.authorImageView.image = nil
        }
        self.tweetTextLabel.text = self.tweet.text
        self.tweetDateLabel.text = self.tweet.creationFullDate
        self.retweetCountLabel.text = String(self.tweet.retweetCount)
        self.favoriteCountLabel.text = String(self.tweet.favoriteCount)
        
        self.replyIconImageView.tintColor = UIColor(white: 0, alpha: 0.35)
        if self.tweet.retweeted {
            self.retweetIconImageView.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 0.75)
        } else {
            self.retweetIconImageView.tintColor = UIColor(white: 0, alpha: 0.35)
        }
        if self.tweet.favorited {
            self.favoriteIconImageView.tintColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 0.75)
        } else {
            self.favoriteIconImageView.tintColor = UIColor(white: 0, alpha: 0.35)
        }
    }
    
    func onRetweetTap() {
        TwitterClient.sharedInstance.setRetweet(!self.tweet.retweeted, tweetId: self.tweet.id) { (tweet, error) -> Void in
            if let tweet = tweet {
                self.tweet.retweetCount = tweet.retweetCount
                self.tweet.retweeted = !self.tweet.retweeted
                self.updateUI()
            } else {
                print(error)
            }
        }
    }
    
    func onFavoriteTap() {
        TwitterClient.sharedInstance.setFavorite(!self.tweet.favorited, tweetId: self.tweet.id) { (tweet, error) -> Void in
            if let tweet = tweet {
                self.tweet.favoriteCount = tweet.retweetCount
                self.tweet.favorited = !self.tweet.favorited
                self.updateUI()
            } else {
                print(error)
            }
        }
    }
    
}
