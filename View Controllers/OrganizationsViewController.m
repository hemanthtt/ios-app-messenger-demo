//
//  OrganizationsViewController.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

#import "OrganizationsViewController.h"
#import "OrganizationCell.h"

@interface OrganizationsViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation OrganizationsViewController

// Handling close button press
- (IBAction)onCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Loading the organization fetched results controller to display and monitor all organizations
    self.resultsController = [[TTKit sharedInstance] organizationsFetchControllerWithDelegate:self];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(OrganizationCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(OrganizationCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsController.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrganizationCell cellHeight];
}

- (void)configureCell:(OrganizationCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTOrganization *organization = [self.resultsController objectAtIndexPath:indexPath];
    cell.item = organization;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationCell *cell = (OrganizationCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OrganizationCell.class)];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTOrganization *organization = [self.resultsController objectAtIndexPath:indexPath];
    [[TTKit sharedInstance] setCurrentOrganization:organization];
    [self onCloseButton:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate

// Refreshing the table view after any update to the organizations
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
