//
//  MenuViewController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controllersData = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsetsMake(0, -15, 0, 0)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        let storyboard = self.storyboard!
        let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController")
        let mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController") as! UINavigationController
        (mentionsViewController.viewControllers[0] as! HomeTimelineViewController).setIsMentions(true)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        
        self.controllersData = [
            ["label": "Timeline", "controller": homeViewController],
            ["label": "Profile", "controller": profileViewController],
            ["label": "Mentions", "controller": mentionsViewController]
        ]
        self.tableView.reloadData()
        
        self.hamburgerViewController.contentViewController = self.controllersData[0]["controller"] as? UIViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllersData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "defaultCell"
        let rowIndex = indexPath.row
        let cellData = self.controllersData[rowIndex]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) ?? UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        cell.textLabel!.text = cellData["label"] as? String
        cell.indentationLevel = 1
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowIndex = indexPath.row
        let controllerData = self.controllersData[rowIndex]
        let controller = controllerData["controller"]
        if rowIndex == 1 {
            ((controller as! UINavigationController).viewControllers[0] as! ProfileViewController).setData(User.currentUser!)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.hamburgerViewController.contentViewController = controller as! UIViewController
    }
    
}
