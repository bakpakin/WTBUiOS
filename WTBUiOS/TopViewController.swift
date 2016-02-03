//
//  TopViewController.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 1/27/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let daysOfWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    @IBAction func segmentSwitch(sender: AnyObject) {
        let selectedSegment = segmentedControl.selectedSegmentIndex
        if selectedSegment==0{
            scheduleTableView.hidden = false
        }else{
            scheduleTableView.hidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         print("A")
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
         print("B")
    }
    
    override func viewDidAppear(animated: Bool) {
        print("C")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleCell")
        cell!.textLabel!.text = daysOfWeek[indexPath.row]
        cell?.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.7)
        return cell!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
