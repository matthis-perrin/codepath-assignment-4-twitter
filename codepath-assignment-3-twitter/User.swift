//
//  User.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

class User: NSObject {

    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileBannerUrl: String?
    var tagline: String?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    var dictionary: NSDictionary
    
    private static let currentUserKey = "currentUserKey"
    private static var _currentUser: User?
    static var currentUser: User? {
        get {
            if User._currentUser == nil {
                guard let data = NSUserDefaults.standardUserDefaults().objectForKey(User.currentUserKey) as? NSData else {
                    return nil
                }
                do {
                    if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary {
                        User._currentUser = User(dictionary: dictionary)
                    } else {
                        return nil
                    }
                } catch {
                    return nil
                }
            }
            return User._currentUser
        }
        set(user) {
            User._currentUser = user
            let clearUser = {() in
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: User.currentUserKey)
            }
            if let user = User._currentUser {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: User.currentUserKey)
                } catch {
                    clearUser()
                }
            } else {
                clearUser()
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screenName = "@" + ((dictionary["screen_name"] as? String) ?? "")
        self.profileImageUrl = dictionary["profile_image_url"] as? String
        self.profileBannerUrl = dictionary["profile_banner_url"] as? String
        self.tagline = dictionary["description"] as? String
        self.tweetsCount = dictionary["statuses_count"] as? Int
        self.followingCount = dictionary["friends_count"] as? Int
        self.followersCount = dictionary["followers_count"] as? Int
    }
    
}
