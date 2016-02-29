//
//  TwitterClient.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

let twitterConsumerKey = "qxKsIk64UAU2fEnZeU3YQr7Yy"
let twitterConsumerSecret = "PZvsiw2NOSEFivRD308uuSiDOxJAtUfprab1dYWUb1ZO93fXHb"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((user: User?, error: NSError?) -> Void)?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func openUrl(url: NSURL) {
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask, res: AnyObject?) -> Void in
                if let data = res as? NSDictionary {
                    User.currentUser = User(dictionary: data)
                    self.loginCompletion?(user: User.currentUser, error: nil)
                }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    self.loginCompletion?(user: nil, error: error)
            })
        }, failure: { (error: NSError!) -> Void in
            self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> Void) {
        self.loginCompletion = completion
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "codepathassignment3://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            if let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)") {
                UIApplication.sharedApplication().openURL(authURL)
            }
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    static func logout(completion: (() -> Void)?) {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        completion?()
    }
    
    func mentions(parameters: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        self.GET("1.1/statuses/mentions_timeline.json", parameters: parameters, success: { (task: NSURLSessionDataTask, res: AnyObject?) -> Void in
            print(res)
            if let data = res as? [NSDictionary] {
                let tweets = Tweet.tweetsWithArray(data)
                completion(tweets: tweets, error: nil)
            }
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweets: nil, error: error)
        })
    }
    
    func home_timeline(parameters: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        self.GET("1.1/statuses/home_timeline.json", parameters: parameters, success: { (task: NSURLSessionDataTask, res: AnyObject?) -> Void in
            if let data = res as? [NSDictionary] {
                let tweets = Tweet.tweetsWithArray(data)
                completion(tweets: tweets, error: nil)
            }
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            completion(tweets: nil, error: error)
        })
    }
    
    
    func update_status(status: String, replyTo: Int?, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        let parameters = NSMutableDictionary(dictionary: ["status": status])
        if let replyTo = replyTo {
            parameters.setValue(replyTo, forKey: "in_reply_to_status_id")
        }
        self.POST("1.1/statuses/update.json", parameters: parameters, success: { (task: NSURLSessionDataTask, res: AnyObject) -> Void in
            if let data = res as? NSDictionary {
                completion(tweet: Tweet(dictionary: data), error: nil)
            } else {
                completion(tweet: nil, error: NSError(domain: "TwitterClient", code: 1, userInfo: nil))
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            completion(tweet: nil, error: error)
        }
    }
    
    func setRetweet(retweet: Bool, tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        let verb = retweet ? "retweet" : "unretweet"
        let url = "1.1/statuses/\(verb)/\(tweetId).json"
        self.POST(url, parameters: nil, success: { (task: NSURLSessionDataTask, res: AnyObject) -> Void in
            if let data = res as? NSDictionary {
                completion(tweet: Tweet(dictionary: data), error: nil)
            } else {
                completion(tweet: nil, error: NSError(domain: "TwitterClient", code: 1, userInfo: nil))
            }
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            completion(tweet: nil, error: error)
        }
    }
    
    func setFavorite(favorite: Bool, tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        let parameters = NSDictionary(dictionary: ["id": tweetId])
        let verb = favorite ? "create" : "destroy"
        let url = "1.1/favorites/\(verb).json"
        self.POST(url, parameters: parameters, success: { (task: NSURLSessionDataTask, res: AnyObject) -> Void in
            if let data = res as? NSDictionary {
                completion(tweet: Tweet(dictionary: data), error: nil)
            } else {
                completion(tweet: nil, error: NSError(domain: "TwitterClient", code: 1, userInfo: nil))
            }
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    
}
