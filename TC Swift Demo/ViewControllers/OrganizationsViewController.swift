//
//  OrganizationsViewController.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

class OrganizationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var resultsController: NSFetchedResultsController!
    
    @IBAction func onCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsController = TTKit.sharedInstance().organizationsFetchControllerWithDelegate(self)
        self.tableView.registerNib(UINib.init(nibName: String(OrganizationCell), bundle: nil), forCellReuseIdentifier: String(OrganizationCell))
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        self.tableView.reloadData()
    }
    
    func configureCell(cell: OrganizationCell, indexPath: NSIndexPath) {
        let organization = self.resultsController.objectAtIndexPath(indexPath)
        cell.item = organization as? TTOrganization
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.resultsController.fetchedObjects?.count
        return count!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return OrganizationCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(OrganizationCell)) as! OrganizationCell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let organization = self.resultsController.objectAtIndexPath(indexPath) as? TTOrganization
        TTKit.sharedInstance().setCurrentOrganization(organization)
        self.onCloseButton(self)
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}