//
//  InboxViewController.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

#import <TTKit/TTKit.h>

#import "InboxViewController.h"
#import "AppDelegate.h"
#import "ConversationCell.h"
#import "OrganizationsBarButtonView.h"
#import "OrganizationsViewController.h"
#import "ConversationViewController.h"

#import "UIHelpers.h"

@interface InboxViewController () <NSFetchedResultsControllerDelegate, OrganizationsBarButtonViewDelegate>

@property (nonatomic) NSFetchedResultsController *inboxFetchedResultsController;
@property (nonatomic) OrganizationsBarButtonView *organizationsBarButtonView;
@property (nonatomic) BOOL shouldReloadTable;

@end

@implementation InboxViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentOrganizationChanged:)
                                                 name:kTTKitCurrentOrganizationChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(organizationUpdated:)
                                                 name:kTTKitOrganizationsDidUpdateNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(ConversationCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(ConversationCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = [[[TTKit sharedInstance] currentOrganization] name];
    [self resetResultsController];
    [self.tableView reloadData];
    [self setOrganizationsBarButton];
}

- (void)setOrganizationsBarButton
{
    self.organizationsBarButtonView = [OrganizationsBarButtonView barView];
    self.organizationsBarButtonView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.organizationsBarButtonView];
}

- (void)resetResultsController
{
    self.inboxFetchedResultsController = [[TTKit sharedInstance] rosterFetchControllerWithDelegate:self];
    self.navigationItem.title = [[[TTKit sharedInstance] currentOrganization] name];
}

- (void)currentOrganizationChanged:(NSNotification *)notification
{
    [self resetResultsController];
    [self.tableView reloadData];
}

- (IBAction)onLogoutButtonPressed:(id)sender
{
    UIAlertController *logoutAlert = [UIHelpers alertControllerWithTitle:@"Logout" message:@"Are you sure you want to log out?" buttonTitles:@[@"Yes"] completion:^(NSString *selectedButtonTitle) {
        
        if ([selectedButtonTitle isEqualToString:@"Yes"]) {
            // Logout of TTKit
            [[TTKit sharedInstance] logout];
        }
    }];
    [self presentViewController:logoutAlert animated:YES completion:nil];
}

- (void)organizationUpdated:(NSNotification *)notification
{
    self.navigationItem.title = [[[TTKit sharedInstance] currentOrganization] name];
}

- (TTRosterEntry *)rosterEntryAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.inboxFetchedResultsController objectAtIndexPath:indexPath];
}

- (void)configureCell:(ConversationCell *)cell rosterEntry:(TTRosterEntry *)rosterEntry
{
    cell.item = rosterEntry;
}

- (void)didSelectRosterEntry:(TTRosterEntry *)rosterEntry atIndexPath:(NSIndexPath *)indexPath
{
    ConversationViewController *conversation =  [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
    conversation.rosterEntry = rosterEntry;
    [self.navigationController pushViewController:conversation animated:YES];
}

#pragma mark - TableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    TTRosterEntry *entry = [self.inboxFetchedResultsController objectAtIndexPath:indexPath];
    if ([entry.target isKindOfClass:[TTUser class]]) {
        title = @"Delete";
    } else if ([entry.target isKindOfClass:[TTGroup class]]) {
        title = @"Leave";
    }
    return title;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *alertTitle = nil;
    NSString *alertMessage = nil;
    TTRosterEntry *entry = [self.inboxFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([entry.target isKindOfClass:[TTGroup class]]) {
        TTGroup *group = (TTGroup *)entry.target;
        alertTitle = group.isPublic.boolValue ? @"Leave Room?" : @"Leave Group?";
        alertMessage = [NSString stringWithFormat:@"Are you sure you want to leave %@?", entry.target.displayName];
    }else if ([entry.target isKindOfClass:[TTUser class]]) {
        alertTitle = @"Delete Conversation?";
        alertMessage = [NSString stringWithFormat:@"Are you sure you want to delete your conversation with %@?",entry.target.displayName];
    }
    
    UIAlertController *alertController = [UIHelpers alertControllerWithTitle:alertTitle message:alertMessage buttonTitles:@[@"Yes"] completion:^(NSString *selectedButtonTitle) {
        if ([selectedButtonTitle isEqualToString:@"Yes"]) {
            [[TTKit sharedInstance] deleteRosterEntry:entry];
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTRosterEntry *entry = [self rosterEntryAtIndexPath:indexPath];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self didSelectRosterEntry:entry atIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inboxFetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationCell *cell = (ConversationCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ConversationCell.class)];
    TTRosterEntry *entry = [self rosterEntryAtIndexPath:indexPath];
    [self configureCell:cell rosterEntry:entry];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ConversationCell cellHeight];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.shouldReloadTable = !(self.isViewLoaded && self.view.window);
    
    if (!self.shouldReloadTable) {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.shouldReloadTable) {
        return;
    }
    
    TTRosterEntry *rosterEntry = (TTRosterEntry *)anObject;
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            if (indexPath.row == newIndexPath.row && indexPath.section == newIndexPath.section) {
                ConversationCell *cell = (ConversationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [self configureCell:cell rosterEntry:rosterEntry];
                break;
            }
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            ConversationCell *cell = (ConversationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell rosterEntry:rosterEntry];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.shouldReloadTable) {
        [self.tableView reloadData];
    }
    else {
        [self.tableView endUpdates];
    }
}

#pragma mark - OrganizationsBarButtonViewDelegate

- (void)organizationBarButtonPressed:(id)sender
{
    OrganizationsViewController *organizationsViewController = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"OrganizationsViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:organizationsViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
