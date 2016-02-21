//
//  Tweet.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//


class Tweet: NSObject {

    var author: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var creationDay: String?
    var creationFullDate: String?
    var retweetCount: Int
    var favoriteCount: Int
    
    var dictionary: NSDictionary
    
    private static var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return dateFormatter
    }
    
    private static var dayFormatter: NSDateFormatter {
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "MM-DD-YYYY"
        return dayFormatter
    }
    
    private static var fullDateFormatter: NSDateFormatter {
        let fullDateFormatter = NSDateFormatter()
        fullDateFormatter.dateFormat = "M-d-yy, HH:mm a"
        return fullDateFormatter
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.author = User(dictionary: dictionary["user"] as! NSDictionary)
        self.text = dictionary["text"] as? String
        self.createdAtString = dictionary["created_at"] as? String
        if let createAt = self.createdAtString {
            self.createdAt = Tweet.dateFormatter.dateFromString(createAt)
            if let date = self.createdAt {
                self.creationDay = Tweet.dayFormatter.stringFromDate(date)
                self.creationFullDate = Tweet.fullDateFormatter.stringFromDate(date)
            }
        }
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
    }
    
    static func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
