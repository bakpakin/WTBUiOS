//
//  ALAccordionSection.swift
//  ALAccordion
//
//  Created by Sam Williams on 13/04/2015.
//  Copyright (c) 2015 Alliants Ltd. All rights reserved.
//
//  http://alliants.com
//

import UIKit

class ALAccordionSection: NSObject
{
    // MARK: - Properties

    weak var accordion: ALAccordionController?
    {
        didSet
        {
            // Start off closed
            accordion?.closeSection(self, animated: false)
        }
    }

    var sectionView = UIView()

    private let headerContainerView = UIView()
    private let bodyContainerView = UIView()

    private (set) internal var viewController: UIViewController!

    var openConstraint: NSLayoutConstraint!
    var closeConstraint: NSLayoutConstraint!

    private (set) internal var open = false

    init(viewController: UIViewController)
    {
        super.init()

        assert(viewController is ALAccordionSectionDelegate, "View Controller \(viewController) must conform to the protocol \(_stdlib_getDemangledTypeName(ALAccordionSectionDelegate))")

        self.viewController = viewController

        self.sectionView.clipsToBounds = true

        self.setupHeaderView((viewController as! ALAccordionSectionDelegate).headerView)
        self.setupBodyView(viewController.view)

        self.layoutViews()
    }

    // MARK: - Layout Methods

    private func layoutViews()
    {
        // Layout the header and body views

        self.sectionView.addSubview(self.headerContainerView)
        self.sectionView.addSubview(self.bodyContainerView)

        self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.bodyContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Header should hug tightly - body loosly
        self.headerContainerView.setContentHuggingPriority(1000, forAxis: .Vertical)
        self.headerContainerView.setContentCompressionResistancePriority(1000, forAxis: .Vertical)

        self.bodyContainerView.setContentHuggingPriority(250, forAxis: .Vertical)
        self.bodyContainerView.setContentCompressionResistancePriority(250, forAxis: .Vertical)

        self.headerContainerView.clipsToBounds = true
        self.bodyContainerView.clipsToBounds = true

        // Constraints
        let views = ["header": self.headerContainerView, "body": self.bodyContainerView]

        let headerHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[header]|", options: [], metrics: nil, views: views)
        let bodyHorizontal   = NSLayoutConstraint.constraintsWithVisualFormat("H:|[body]|", options: [], metrics: nil, views: views)

        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[header][body]", options: [], metrics: nil, views: views)

        self.sectionView.addConstraints(headerHorizontal + bodyHorizontal + vertical)

        // Create the constraint for opening / closing section
        self.openConstraint = NSLayoutConstraint(item: self.sectionView, attribute: .Bottom, relatedBy: .Equal, toItem: self.bodyContainerView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        self.closeConstraint = NSLayoutConstraint(item: self.headerContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.sectionView, attribute: .Bottom, multiplier: 1.0, constant: 0)
    }

    func setupHeaderView(header: UIView)
    {
        // Add the header view to the header container view
        self.headerContainerView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        let views = ["header": header]
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[header]|", options: [], metrics: nil, views: views)
        let vertical   = NSLayoutConstraint.constraintsWithVisualFormat("V:|[header]", options: [], metrics: nil, views: views)

        // Low priority bottom view that can break if needed
        let bottom = NSLayoutConstraint(item: self.headerContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: header, attribute: .Bottom, multiplier: 1.0, constant: 0)
        //bottom.priority = 250

        self.headerContainerView.addConstraints(horizontal + vertical)
        self.headerContainerView.addConstraint(bottom)
    }

    func setupBodyView(body: UIView)
    {
        // Add the footer view to the footer container view
        self.bodyContainerView.addSubview(body)
        body.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        let views = ["body": body]
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[body]|", options: [], metrics: nil, views: views)
        let vertical   = NSLayoutConstraint.constraintsWithVisualFormat("V:|[body]", options: [], metrics: nil, views: views)

        // Low priority bottom view that can break if the containing body view is a fixed height
        let bottom = NSLayoutConstraint(item: self.bodyContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: body, attribute: .Bottom, multiplier: 1.0, constant: 0)
        bottom.priority = 250

        self.bodyContainerView.addConstraints(horizontal + vertical)
        self.bodyContainerView.addConstraint(bottom)
    }


    // MARK: - Opening / closing the section

    func activateOpenConstraints()
    {
        // Swap open / close constraints
        self.sectionView.removeConstraint(self.closeConstraint)
        self.sectionView.addConstraint(self.openConstraint)

        // Mark as open
        self.open = true
    }

    func activateCloseConstraints()
    {
        // Swap open / close constraints
        self.sectionView.removeConstraint(self.openConstraint)
        self.sectionView.addConstraint(self.closeConstraint)

        // Mark as closed
        self.open = false
    }
}