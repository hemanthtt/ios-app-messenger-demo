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
    var inboxFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var shouldReloadTable = false
    var organizationBarButtonView: OrganizationsBarButtonView!
    
    let conversationCellIdentifier = "ConversationCell"
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(InboxViewController.currentOrganizationChanged(_:)), name: NSNotification.Name.ttKitCurrentOrganizationChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InboxViewController.organizationUpdated(_:)), name: NSNotification.Name.ttKitOrganizationsDidUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetFetchedResultsController()

        self.tableView.register(UINib.init(nibName: conversationCellIdentifier, bundle: nil), forCellReuseIdentifier: conversationCellIdentifier)
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.navigationItem.title = ttKit?.currentOrganizationName()
        self.tableView.reloadData()
        setOrganizationBarButton()
    }
    
    @IBAction func onLogoutButtonPressed(_ sender: AnyObject) {
        let yesString = "Yes"
        let alertController = UIHelpers.alertControllerWithTitle("Logout", message: "Are you sure you want to log out?", buttonTitles: [yesString]) { (selectedButtonTitle) -> Void in
            if selectedButtonTitle == yesString {
                TTKit.sharedInstance().logout()
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetFetchedResultsController() {
        self.inboxFetchedResultsController = ttKit?.rosterFetchController(with: self)
        self.navigationItem.title = ttKit?.currentOrganizationName()        
    }
    
    func setOrganizationBarButton() {
        self.organizationBarButtonView = OrganizationsBarButtonView.barView()
        self.organizationBarButtonView.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.organizationBarButtonView)
    }
    
    func rosterEntryAtIndexPath(_ indexPath: IndexPath) -> TTRosterEntry? {
        return self.inboxFetchedResultsController?.object(at: indexPath) as? TTRosterEntry
    }
    
    func configureCell(_ cell: ConversationCell!, rosterEntry: TTRosterEntry?) {
        cell.item = rosterEntry
    }
    
    func didSelectRosterEntry(_ rosterEntry: TTRosterEntry, indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let conversationViewController = appDelegate.storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        conversationViewController.rosterEntry = rosterEntry
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let count = self.inboxFetchedResultsController.fetchedObjects?.count
        return count!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: conversationCellIdentifier) as! ConversationCell
        let rosterEntry = rosterEntryAtIndexPath(indexPath)
        configureCell(cell,rosterEntry: rosterEntry)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConversationCell.cellHeight()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.shouldReloadTable = !(self.isViewLoaded && self.view.window != nil)
        
        if (!self.shouldReloadTable) {
            self.tableView.beginUpdates()
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if (self.shouldReloadTable) {
            self.tableView.reloadData()
        } else {
            self.tableView.endUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (self.shouldReloadTable) {
            return
        }
        
        let rosterEntry = anObject as! TTRosterEntry
        
        switch (type) {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        case .move:
            if indexPath == nil {
                break;
            }
            
            if (indexPath?.row == newIndexPath?.row && indexPath?.section == newIndexPath?.section) {
                let cell = tableView.cellForRow(at: indexPath!) as? ConversationCell
                if cell != nil {
                    configureCell(cell, rosterEntry: rosterEntry)                    
                }
                break
            }
            
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! ConversationCell
            configureCell(cell, rosterEntry: rosterEntry)
        }
    }
    
    //MARK: OrganizationsBarButtonViewDelegate
    func organizationBarButtonPressed(_ sender: OrganizationsBarButtonView!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let organizationsViewController = appDelegate.storyboard?.instantiateViewController(withIdentifier: "OrganizationsViewController")
        let nav = UINavigationController.init(rootViewController: organizationsViewController!)
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK: NSNotifications
    @objc func currentOrganizationChanged(_ notification: Notification) {
        resetFetchedResultsController()
        self.tableView.reloadData()
    }
    
    @objc func organizationUpdated(_ notification: Notification) {
        self.navigationItem.title = ttKit?.currentOrganizationName()
    }
}
