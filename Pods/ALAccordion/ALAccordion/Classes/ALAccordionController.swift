//
//  ALAccordionViewController.swift
//  ALAccordion
//
//  Created by Sam Williams on 10/04/2015.
//  Copyright (c) 2015 Alliants Ltd. All rights reserved.
//
//  http://alliants.com
//

import UIKit

public class ALAccordionController: UIViewController
{
    // MARK: - Properties

    public var animationDuration = 0.3

    private let headerContainerView = UIView()
    private let sectionContainerView = UIView()
    private let footerContainerView = UIView()

    private var sections = [ALAccordionSection]()

    private var sectionTopConstraint: NSLayoutConstraint?
    private var sectionBottomConstraint: NSLayoutConstraint?

    public var openSectionIndex: Int?
    {
        // Return the index of the first section that's marked as open
        for (idx, section) in self.sections.enumerate()
        {
            if section.open
            {
                return idx
            }
        }

        return nil
    }

    public var headerView: UIView?
    {
        didSet
        {
            if headerView != nil
            {
                self.setupHeaderView(headerView!)
            }
        }
    }

    public var footerView: UIView?
    {
        didSet
        {
            if footerView != nil
            {
                self.setupFooterView(footerView!)
            }
        }
    }


    // MARK: - View Methods

    override public func viewDidLoad()
    {
        super.viewDidLoad()

        self.layoutView()

        self.sectionContainerView.clipsToBounds = true
        self.sectionContainerView.backgroundColor = UIColor.clearColor()
    }

    // MARK: - Layout views

    public func setViewControllers(viewControllers: UIViewController...)
    {
        for vc in viewControllers
        {
            assert(vc is ALAccordionSectionDelegate, "View Controller \(vc) must conform to the protocol \(_stdlib_getDemangledTypeName(ALAccordionSectionDelegate))")

            let section = ALAccordionSection(viewController: vc)

            section.accordion = self
            self.sections.append(section)
        }

        self.layoutSectionViews()
    }

    // Layouts out the header, container and footer views

    private func layoutView()
    {
        // Layout views

        self.view.addSubview(self.headerContainerView)
        self.view.addSubview(self.sectionContainerView)
        self.view.addSubview(self.footerContainerView)

        self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.sectionContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.footerContainerView.translatesAutoresizingMaskIntoConstraints = false

        let headerTop = NSLayoutConstraint(item: self.headerContainerView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0)
        headerTop.priority = 250

        let footerBottom = NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: .Bottom, relatedBy: .Equal, toItem: self.footerContainerView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        footerBottom.priority = 250


        let views = ["header": self.headerContainerView, "container": self.sectionContainerView, "footer": self.footerContainerView]

        let headerHorizontal    = NSLayoutConstraint.constraintsWithVisualFormat("H:|[header]|", options: [], metrics: nil, views: views)
        let containerHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[container]|", options: [], metrics: nil, views: views)
        let footerHorizontal    = NSLayoutConstraint.constraintsWithVisualFormat("H:|[footer]|", options: [], metrics: nil, views: views)

        let centerYContainer = NSLayoutConstraint(item: self.sectionContainerView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0)
        centerYContainer.priority = 250

        let topContainer = NSLayoutConstraint(item: self.sectionContainerView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.headerContainerView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let bottomContainer = NSLayoutConstraint(item: self.footerContainerView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.sectionContainerView, attribute: .Bottom, multiplier: 1.0, constant: 0)

        self.view.addConstraints([headerTop, footerBottom, centerYContainer, topContainer, bottomContainer])
        self.view.addConstraints(headerHorizontal + containerHorizontal + footerHorizontal)
    }

    private func setupHeaderView(header: UIView)
    {
        // Remove any previous header
        for v in self.headerContainerView.subviews 
        {
            v.removeFromSuperview()
        }

        // Add the header view to the header container view
        self.headerContainerView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        let views = ["header": header]
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[header]|", options: [], metrics: nil, views: views)
        let vertical   = NSLayoutConstraint.constraintsWithVisualFormat("V:|[header]|", options: [], metrics: nil, views: views)

        self.headerContainerView.addConstraints(horizontal + vertical)
    }

    private func setupFooterView(footer: UIView)
    {
        // Remove any previous footer
        for v in self.footerContainerView.subviews 
        {
            v.removeFromSuperview()
        }

        // Add the footer view to the footer container view
        self.footerContainerView.addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        let views = ["footer": footer]
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[footer]|", options: [], metrics: nil, views: views)
        let vertical   = NSLayoutConstraint.constraintsWithVisualFormat("V:|[footer]|", options: [], metrics: nil, views: views)

        self.footerContainerView.addConstraints(horizontal + vertical)
    }

    // Layout the sections within the container view
    private func layoutSectionViews()
    {
        // Remove current sections
        self.removeCurrentSections()

        if self.sections.count == 0
        {
            return
        }

        // Add all the section views and setup constraints between them
        var previousView = self.sectionContainerView
        for section in self.sections
        {
            // Add section to view
            self.sectionContainerView.addSubview(section.sectionView)
            section.sectionView.translatesAutoresizingMaskIntoConstraints = false

            // Setup constraints
            let views = ["section": section.sectionView]

            let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[section]|", options: [], metrics: nil, views: views)

            let top = NSLayoutConstraint(item: section.sectionView, attribute: .Top, relatedBy: .Equal, toItem: previousView, attribute: previousView == self.sectionContainerView ? .Top : .Bottom, multiplier: 1.0, constant: 0)


            self.sectionContainerView.addConstraints(horizontal)
            self.sectionContainerView.addConstraint(top)

            self.addChildViewController(section.viewController)

            previousView = section.sectionView
        }

        // Add final bottom constraint
        let lastSection = sections.last

        let bottom = NSLayoutConstraint(item: lastSection!.sectionView, attribute: .Bottom, relatedBy: .Equal, toItem: self.sectionContainerView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        self.sectionContainerView.addConstraint(bottom)

        self.view.setNeedsLayout()
    }

    // Removes all the current sections from the view
    private func removeCurrentSections()
    {
        for childView in self.sectionContainerView.subviews 
        {
            childView.removeFromSuperview()
        }

        for childVC in self.childViewControllers 
        {
            childVC.removeFromParentViewController()
        }
    }


    // Get the ALAccordionSection object that a given view controller is associated with
    public func sectionIndexForViewController(viewController: UIViewController) -> Int?
    {
        for (idx, section) in self.sections.enumerate()
        {
            if section.viewController == viewController
            {
                return idx
            }
        }

        return nil
    }

    // MARK: - Open 'n' Close Methods

    public func openSectionAtIndex(index: Int, animated: Bool)
    {
        assert(index >= 0 && index < self.sections.count, "Section index (\(index)) out of bounds. There are only \(self.sections.count) sections")

        // Get the section at this index
        let section = self.sections[index]
        self.openSection(section, animated: true)
    }

    public func closeSectionAtIndex(index: Int, animated: Bool)
    {
        assert(index >= 0 && index < self.sections.count, "Section index (\(index)) out of bounds. There are only \(self.sections.count) sections")

        // Get the section at this index
        let section = self.sections[index]
        self.closeSection(section, animated: animated)
    }

    public func closeAllSections(animated: Bool)
    {
        for section in self.sections
        {
            self.closeSection(section, animated: animated)
        }
    }

    func openSection(section: ALAccordionSection, animated: Bool)
    {
        // Dont open again
        if section.open == true
        {
            return
        }

        // Close all the sections first
        self.closeAllSections(animated)

        let viewController = section.viewController as? ALAccordionSectionDelegate

        // Tell the view controller that it's about to open
        viewController?.sectionWillOpen?(animated: animated)

        // Open up the section to full screen

        // Remove previous top/bottom constraints on section and add them to the current section
        if let top = self.sectionTopConstraint
        {
            self.view.removeConstraint(top)
        }

        if let bottom = self.sectionBottomConstraint
        {
            self.view.removeConstraint(bottom)
        }

        section.activateOpenConstraints()

        // Create the top & bottom constraints to pull the section to full screen
        self.sectionTopConstraint = NSLayoutConstraint(item: section.sectionView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0)
        self.sectionBottomConstraint = NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: .Bottom, relatedBy: .Equal, toItem: section.sectionView, attribute: .Bottom, multiplier: 1.0, constant: 0)

        self.view.addConstraints([self.sectionTopConstraint!, self.sectionBottomConstraint!])

        // Tell system to update the layout
        let duration = animated ? self.animationDuration : 0

        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations:
        {
            // Hide header & footer
            self.headerContainerView.alpha = 0
            self.footerContainerView.alpha = 0

            // Hide other sections
            for s in self.sections
            {
                if s != section
                {
                    s.sectionView.alpha = 0
                }
            }
            
            self.view.layoutIfNeeded()
        },
        completion:
        {
            (finished: Bool) in

            // Tell the view controller that it just opened
            viewController?.sectionDidOpen?()
        })
    }

    func closeSection(section: ALAccordionSection, animated: Bool)
    {
        let viewController = section.viewController as? ALAccordionSectionDelegate

        // Tell the view controller delegate that it's about to close
        viewController?.sectionWillClose?(animated: animated)


        // We need to break the top and bottom constraints (if full screen mode is enabled)
        if let top = self.sectionTopConstraint
        {
            self.view.removeConstraint(top)
        }

        if let bottom = self.sectionBottomConstraint
        {
            self.view.removeConstraint(bottom)
        }

        section.activateCloseConstraints()

        // Tell system to update the layout
        let duration = animated ? self.animationDuration : 0
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations:
        {
            // Show header & footer
            self.headerContainerView.alpha = 1.0
            self.footerContainerView.alpha = 1.0

            // Show all sections
            for s in self.sections
            {
                s.sectionView.alpha = 1.0
            }

            self.view.layoutIfNeeded()
        },
        completion:
        {
            (finished: Bool) in

            // Tell the view controller that it just closed
            viewController?.sectionDidClose?()
        })
    }
}
