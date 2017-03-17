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
    var resultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    @IBAction func onCloseButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let organizationsCellIdentifier = "OrganizationCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsController = TTKit.sharedInstance().organizationsFetchController(with: self)
        self.tableView.register(UINib(nibName: organizationsCellIdentifier, bundle: nil), forCellReuseIdentifier: organizationsCellIdentifier)
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.reloadData()
    }
    
    func configureCell(_ cell: OrganizationCell, indexPath: IndexPath) {
        let organization = self.resultsController.object(at: indexPath)
        cell.item = organization as? TTOrganization
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.resultsController.fetchedObjects?.count
        return count!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrganizationCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: organizationsCellIdentifier)) as! OrganizationCell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let organization = self.resultsController.object(at: indexPath) as? TTOrganization
        TTKit.sharedInstance().setCurrentOrganization(organization)
        self.onCloseButton(self)
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
