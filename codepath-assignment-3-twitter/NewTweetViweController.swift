//
//  NewTweetViweController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

class NewTweetViweController: UIViewController {

    @IBOutlet weak var currentUserImageView: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserUsernameLabel: UILabel!
    
    @IBOutlet weak var tweetTextField: UITextView!
    
    private var user: User!
    private var onNewTweet: ((tweet: Tweet) -> Void)?
    
    func setData(user: User, onNewTweet: ((tweet: Tweet) -> Void)?) {
        self.user = user
        self.onNewTweet = onNewTweet
    }
    
    override func viewDidLoad() {
        if let profileImageUrlString = self.user.profileImageUrl {
            if let profileImageUrl = NSURL(string: profileImageUrlString) {
                self.currentUserImageView.setImageWithURL(profileImageUrl)
            } else {
                self.currentUserImageView.image = nil
            }
        } else {
            self.currentUserImageView.image = nil
        }
        self.currentUserNameLabel.text = self.user.name
        self.currentUserUsernameLabel.text = self.user.screenName
        self.tweetTextField.text = ""
        self.tweetTextField.becomeFirstResponder()
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: "tweetButtonTap"), animated: true)
    }
    
    func tweetButtonTap() {
        TwitterClient.sharedInstance.update_status(tweetTextField.text) { (tweet: Tweet?, error: NSError?) in
            if let tweet = tweet, let onNewTweet = self.onNewTweet {
                onNewTweet(tweet: tweet)
            }
            guard let nc = self.navigationController else { return }
            nc.popViewControllerAnimated(true)
        }
    }
}
