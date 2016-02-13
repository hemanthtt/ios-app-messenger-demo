//
//  InboxViewController.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/11/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import UIKit

class InboxViewController: UITableViewController, NSFetchedResultsControllerDelegate, OrganizationsBarButtonViewDelegate {
    
    var ttKit = TTKit.sharedInstance()
    var inboxFetchedResultsController: NSFetchedResultsController!
    var shouldReloadTable = false
    var organizationBarButtonView: OrganizationsBarButtonView!
    
    let conversationCellIdentifier = String(ConversationCell)
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("currentOrganizationChanged:"), name: kTTKitCurrentOrganizationChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("organizationUpdated:"), name: kTTKitOrganizationsDidUpdateNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetFetchedResultsController()

        self.tableView.registerNib(UINib.init(nibName: conversationCellIdentifier, bundle: nil), forCellReuseIdentifier: conversationCellIdentifier)
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        self.navigationItem.title = ttKit.currentOrganizationName()
        self.tableView.reloadData()
        setOrganizationBarButton()
    }
    
    @IBAction func onLogoutButtonPressed(sender: AnyObject) {
        let yesString = "Yes"
        let alertController = UIHelpers.alertControllerWithTitle("Logout", message: "Are you sure you want to log out?", buttonTitles: [yesString]) { (selectedButtonTitle) -> Void in
            if selectedButtonTitle == yesString {
                TTKit.sharedInstance().logout()
            }
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func resetFetchedResultsController() {
        self.inboxFetchedResultsController = ttKit.rosterFetchControllerWithDelegate(self)
        self.navigationItem.title = ttKit.currentOrganizationName()        
    }
    
    func setOrganizationBarButton() {
        self.organizationBarButtonView = OrganizationsBarButtonView.barView()
        self.organizationBarButtonView.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.organizationBarButtonView)
    }
    
    func rosterEntryAtIndexPath(indexPath: NSIndexPath) -> TTRosterEntry? {
        return self.inboxFetchedResultsController?.objectAtIndexPath(indexPath) as? TTRosterEntry
    }
    
    func configureCell(cell: ConversationCell!, rosterEntry: TTRosterEntry?) {
        cell.item = rosterEntry
    }
    
    func didSelectRosterEntry(rosterEntry: TTRosterEntry, indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let conversationViewController = appDelegate.storyboard?.instantiateViewControllerWithIdentifier("ConversationViewController") as! ConversationViewController
        conversationViewController.rosterEntry = rosterEntry
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let count = self.inboxFetchedResultsController.fetchedObjects?.count
        return count!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(conversationCellIdentifier) as! ConversationCell
        let rosterEntry = rosterEntryAtIndexPath(indexPath)
        configureCell(cell,rosterEntry: rosterEntry)
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ConversationCell.cellHeight()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.shouldReloadTable = !(self.isViewLoaded() && self.view.window != nil)
        
        if (!self.shouldReloadTable) {
            self.tableView.beginUpdates()
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if (self.shouldReloadTable) {
            self.tableView.reloadData()
        } else {
            self.tableView.endUpdates()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if (self.shouldReloadTable) {
            return
        }
        
        let rosterEntry = anObject as! TTRosterEntry
        
        switch (type) {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            
        case .Move:
            if indexPath == nil {
                break;
            }
            
            if (indexPath?.row == newIndexPath?.row && indexPath?.section == newIndexPath?.section) {
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as? ConversationCell
                if cell != nil {
                    configureCell(cell, rosterEntry: rosterEntry)                    
                }
                break
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ConversationCell
            configureCell(cell, rosterEntry: rosterEntry)
        }
    }
    
    //MARK: OrganizationsBarButtonViewDelegate
    func organizationBarButtonPressed(sender: OrganizationsBarButtonView!) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let organizationsViewController = appDelegate.storyboard?.instantiateViewControllerWithIdentifier("OrganizationsViewController")
        let nav = UINavigationController.init(rootViewController: organizationsViewController!)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: NSNotifications
    @objc func currentOrganizationChanged(notification: NSNotification) {
        resetFetchedResultsController()
        self.tableView.reloadData()
    }
    
    @objc func organizationUpdated(notification: NSNotification) {
        self.navigationItem.title = ttKit.currentOrganizationName()
    }
}
