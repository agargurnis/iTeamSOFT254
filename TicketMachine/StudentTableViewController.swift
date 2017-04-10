//
//  StudentTableViewController.swift
//  TicketMachine
//
//  Created by Arvids Gargurnis on 06/04/2017.
//  Copyright © 2017 Arvids Gargurnis. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

class StudentTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    var sessions = [CKRecord]()
    var refresh:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to load qustions")
        refresh.addTarget(self, action: #selector(StudentTableViewController.loadData), for: .valueChanged)
        self.tableView.addSubview(refresh)
        
        DispatchQueue.main.async { () -> Void in
            NotificationCenter.default.addObserver(self, selector: #selector(StudentTableViewController.loadData), name: NSNotification.Name(rawValue: "performReload"), object: nil)
        }
        
        setupCloudKitSubscription()
        loadData()
    }
    
    func setupCloudKitSubscription() {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "subscribed") == false {
            let predicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)
            let subscription = CKQuerySubscription(recordType: "Session", predicate: predicate, options: CKQuerySubscriptionOptions.firesOnRecordCreation)
            let notificationInfo = CKNotificationInfo()
            notificationInfo.alertLocalizationKey = "New Session"
            notificationInfo.shouldBadge = true
            
            subscription.notificationInfo = notificationInfo
            
            let publicData = CKContainer.default().publicCloudDatabase
            
            publicData.save(subscription) { (subscription:CKSubscription?, error:Error?) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    userDefaults.set(true, forKey: "subscribed")
                    userDefaults.synchronize()
                }
            }
        }
        
    }
    
    func loadData() {
        sessions = [CKRecord]()
        
        let publicData = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Session", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        publicData.perform(query, inZoneWith: nil) { (results:[CKRecord]?, error:Error?) in
            if let sessions = results {
                self.sessions = sessions
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                    self.view.layoutSubviews()
                })
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
        let destination = segue.destination as! PasscodeViewController
        
        let selectRecord = sessions[indexPath.row]
        
        let Passcode = selectRecord.object(forKey: "Passcode") as? Int
        
        destination.sessionPass = Passcode!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)
        
        if sessions.count == 0 {
            return cell
        }
        
        let session = sessions[indexPath.row]
        
        if let sessionName = session["Name"] as? String {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy/MM/dd HH:mm"
            let dateString = dateFormat.string(from: session.creationDate!)
            
            cell.textLabel?.text = sessionName
            cell.detailTextLabel?.text = dateString
        }
        
        return cell
    }

}