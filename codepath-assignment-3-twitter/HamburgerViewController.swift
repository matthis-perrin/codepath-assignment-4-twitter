//
//  HamburgerViewController.swift
//  codepath-assignment-3-twitter
//
//  Created by Matthis Perrin on 2/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//

let MENU_VIEW_VISIBLE_WIDTH: CGFloat = 200
let MENU_ANIMATION_DURATION = 0.3

class HamburgerViewController: UIViewController {

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    
    var originalLeftMargin: CGFloat!
    var oldViewController: UIViewController?
    var menuViewController: UIViewController! {
        didSet {
            self.view.layoutIfNeeded() // Kick in the viewDidLoad
            self.menuViewController.willMoveToParentViewController(self)
            self.menuView.addSubview(self.menuViewController.view)
            self.menuViewController.view.frame = self.menuView.bounds
            self.menuViewController.didMoveToParentViewController(self)
        }
    }
    var contentViewController: UIViewController! {
        didSet {
            self.view.layoutIfNeeded() // Kick in the viewDidLoad
            if let oldViewController = self.oldViewController {
                oldViewController.willMoveToParentViewController(nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.didMoveToParentViewController(nil)
            }
            self.oldViewController = self.contentViewController
            self.contentViewController.willMoveToParentViewController(self)
            self.contentView.addSubview(self.contentViewController.view)
            self.contentViewController.view.frame = self.contentView.bounds
            self.contentViewController.didMoveToParentViewController(self)
            UIView.animateWithDuration(MENU_ANIMATION_DURATION, animations: { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        let velocity = sender.velocityInView(self.view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = max(0, originalLeftMargin + translation.x)
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(MENU_ANIMATION_DURATION, animations: { () -> Void in
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = MENU_VIEW_VISIBLE_WIDTH
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
}
