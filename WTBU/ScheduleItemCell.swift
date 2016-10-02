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
        setup(show: show, period: period)
    }
    
    func setup(show: Show?, period: TimePeriod?) {
        self.show = show
        self.period = period
        detailTextLabel!.text = period?.getHourlyShorthand() ?? ""
        textLabel!.text = show?.name ?? ""
        if (show != nil && show!.favorited) {
            textLabel!.text = "\(textLabel!.text!) ⭐️"
            favoriteButton.setTitle("Unfollow", for: .normal)
        } else {
            favoriteButton.setTitle("Follow", for: .normal)
        }
        favoriteButton.layoutIfNeeded()
    }
    
    init(reuseIdentifier: String) {
        infoButton = MGSwipeButton(title: "Info", backgroundColor: UIColor.darkGray)
        // Set start text to "Unfollow" because it is longer and will make the cell the right width
        favoriteButton = MGSwipeButton(title: "Unfollow", backgroundColor: UIColor.lightGray)
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        // Disable info for now
        //rightButtons = [infoButton, favoriteButton]
        
        rightButtons = [favoriteButton]
        rightSwipeSettings.transition = .drag
        selectionStyle = .none
        backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont(name: "Gill Sans",
                                 size: 17.0)
        detailTextLabel?.textColor = UIColor.white
    }
    
}
