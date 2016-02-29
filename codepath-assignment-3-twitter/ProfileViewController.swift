//
//  ProfileViewController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    
    @IBOutlet weak var tweetsPanel: UIView!
    @IBOutlet weak var followingPanel: UIView!
    @IBOutlet weak var followersPanel: UIView!
    
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    func setData(user: User) {
        self.user = user
        self.reloadUI()
        print(user.dictionary)
    }
    
    private func setImage(imageView: UIImageView, imageUrl: String?) {
        var imageSet = false
        if let urlString = imageUrl {
            if let url = NSURL(string: urlString) {
                imageView.setImageWithURL(url)
                imageSet = true
            }
        }
        if !imageSet {
            imageView.image = nil
        }
    }
    
    func reloadUI() {
        self.view.layoutIfNeeded()
        self.setImage(self.backgroundImageView, imageUrl: self.user.profileBannerUrl)
        self.setImage(self.profileImageView, imageUrl: self.user.profileImageUrl)
        self.userName.text = self.user.name
        self.userScreenName.text = self.user.screenName
        self.title = self.user == User.currentUser ? "Me" : self.user.name
        self.tweetsCount.text = String((self.user.tweetsCount ?? 0).formatted)
        self.followingCount.text = String((self.user.followingCount ?? 0).formatted)
        self.followersCount.text = String((self.user.followersCount ?? 0).formatted)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in [self.tweetsPanel, self.followingPanel, self.followersPanel] {
            view.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
            view.layer.borderWidth = 2
        }
        self.backgroundImageView.contentMode = .ScaleAspectFill
        self.backgroundImageView.clipsToBounds = true
        self.profileImageView.contentMode = .ScaleAspectFill
        self.profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}

extension IntegerType {
    var formatted: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}
