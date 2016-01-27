//
//  ViewController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 1/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit

protocol LayoutViewControllerDelegate {
    func innerScrollViewShouldScroll() -> Bool
}

class LayoutViewController: UIViewController {
        
    var middleVc: UIViewController!
    var topVc: UIViewController!
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: LayoutViewControllerDelegate?
    
    class func containerViewWith(middleVC: UIViewController, topVC: UIViewController) -> LayoutViewController {
        let container = LayoutViewController()
        container.middleVc = middleVC
        container.topVc = topVC
        return container
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupVerticalScrollView()
        setupHorozontalScrollView()
       
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    
    func setupVerticalScrollView()
    {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc, topVc: topVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorozontalScrollView()
    {
        scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        self.scrollView!.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = 3 * CGRectGetWidth(self.view.bounds)
        let scrollHeight: CGFloat  = CGRectGetHeight(self.view.bounds)
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        middleVertScrollVc.view.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        
        self.addChildViewController(middleVertScrollVc)
        self.scrollView!.addSubview(middleVertScrollVc.view)
        middleVertScrollVc.didMoveToParentViewController(self)
        
        self.scrollView!.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        self.scrollView!.delegate = self;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension LayoutViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if delegate != nil && !delegate!.innerScrollViewShouldScroll() {
            // This is probably crazy movement: diagonal scrolling
            var newOffset = CGPoint()
            
            if (abs(scrollView.contentOffset.x) > abs(scrollView.contentOffset.y)) {
                newOffset = CGPointMake(self.initialContentOffset.x, self.initialContentOffset.y)
            } else {
                newOffset = CGPointMake(self.initialContentOffset.x, self.initialContentOffset.y)
            }
            
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset,animated:  false)
        }
    }
}
