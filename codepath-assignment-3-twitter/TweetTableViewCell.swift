//
//  TweetTableViewCell.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetDayLabel: UILabel!
    
    private var tweet: Tweet?
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
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
            self.tweetTextLabel.text = tweet.text
            self.tweetDayLabel.text = tweet.creationDay
        } else {
            self.authorImageView.image = nil
        }
    }
    
}
