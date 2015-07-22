//
//  MainTableViewController.swift
//  SDKDemo
//
//  Created by Sean Ooi on 6/11/15.
//  Copyright (c) 2015 Yella Inc. All rights reserved.
//

import UIKit
import RaySDK

let notificationRefreshKey = "NotificationRefreshKey"

class MainTableViewController: UITableViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ray SDK"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshView", name: notificationRefreshKey, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refreshView() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.items.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let dict = appDelegate.items[indexPath.row]
        if let beacon = dict["beacon"] as? RSDKBeacon {
            cell.textLabel?.text = "\(beacon.major)-\(beacon.minor)"
            cell.detailTextLabel?.text = "RSSI: \(beacon.rssi)"
        }
        else {
            cell.textLabel?.text = "Some beacon"
            cell.detailTextLabel?.text = "RSSI: I have no idea"
        }

        return cell
    }

}
