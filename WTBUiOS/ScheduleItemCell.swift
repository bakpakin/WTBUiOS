//
//  ScheduleItemCell.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit
import MGSwipeTableCell

class ScheduleItemCell : MGSwipeTableCell {
    
    var show: Show?
    var period: TimePeriod?
    let favoriteButton: MGSwipeButton
    let infoButton: MGSwipeButton
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemeted.")
    }
    
    func dataUpdated() {
        setup(show, period: period)
    }
    
    func setup(show: Show?, period: TimePeriod?) {
        self.show = show
        self.period = period
        detailTextLabel!.text = period?.getHourlyShorthand() ?? ""
        textLabel!.text = show?.name ?? ""
        if (show != nil && show!.favorited) {
            textLabel!.text = "\(textLabel!.text!) ⭐️"
            favoriteButton.setTitle("Unfollow", forState: .Normal)
        } else {
            favoriteButton.setTitle("Follow", forState: .Normal)
        }
        favoriteButton.layoutIfNeeded()
    }
    
    init(reuseIdentifier: String) {
        infoButton = MGSwipeButton(title: "Info", backgroundColor: UIColor.darkGrayColor())!
        // Set start text to "Unfollow" because it is longer and will make the cell the right width
        favoriteButton = MGSwipeButton(title: "Unfollow", backgroundColor: UIColor.lightGrayColor())!
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        rightButtons = [infoButton, favoriteButton]
        rightSwipeSettings.transition = .Drag
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        textLabel?.textColor = UIColor.whiteColor()
        detailTextLabel?.textColor = UIColor.whiteColor()
    }
    
}