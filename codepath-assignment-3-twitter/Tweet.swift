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
    
    var dictionary: NSDictionary
    
    private static var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return dateFormatter
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.author = User(dictionary: dictionary["user"] as! NSDictionary)
        self.text = dictionary["text"] as? String
        self.createdAtString = dictionary["created_at"] as? String
        if let createAt = self.createdAtString {
            self.createdAt = Tweet.dateFormatter.dateFromString(createAt)
        }
    }
    
    static func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
