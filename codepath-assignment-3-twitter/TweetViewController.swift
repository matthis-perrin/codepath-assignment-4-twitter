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
    
    private var tweet: Tweet!
    
    func setData(tweet: Tweet) {
        self.tweet = tweet
    }
    
    override func viewDidLoad() {
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
    }
    
}
