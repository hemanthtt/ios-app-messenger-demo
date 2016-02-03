//
//  ConversationViewController.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationBackView.h"
#import "LoadMoreMessagesHeaderView.h"
#import "OutgoingMessageCell.h"
#import "IncomingMessageCell.h"

NSString *const OutgoingMessageCellIdentifier = @"OutgoingMessageCell";
NSString *const IncomingMessageCellIdentifier = @"IncomingMessageCell";

const NSUInteger kMessageTimeToLive = 30*60*24; //30 days
const BOOL kDeleteOnRead = NO;

const BOOL SupportPagination = YES; // We highly recommend to use pagination to improve loading performance.
const NSUInteger MessagesPerPage = 30;

@interface ConversationViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, LoadMoreMessagesHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSFetchedResultsController *resultsController;
@property (nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL tableManuallyUpdated;

// Conversation pagination
@property (nonatomic) BOOL hasMoreMessages;
@property (nonatomic) NSUInteger messagesBatchSize;
@property (nonatomic) NSUInteger messagesFetchOffset;

// Load more messages header view
@property (nonatomic) LoadMoreMessagesHeaderView *loadMoreMessagesHeaderView;

@property (weak, nonatomic) IBOutlet UIView *messageInputView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *inputMessageTextView;

@end

@implementation ConversationViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUser:(TTUser *)user
{
    _user = user;
    TTRosterEntry *entryForUser = [[TTKit sharedInstance] rosterEntryForUser:_user];
    self.rosterEntry = entryForUser;
}

- (void)reloadConversationWithRosterEntry:(TTRosterEntry *)rosterEntry
{
    self.rosterEntry = rosterEntry;
    [self resetFetchController];
    [self.tableView reloadData];
}

- (void)setViewControllerTitle
{
    if (self.rosterEntry) {
        self.title = self.rosterEntry.target.displayName;
    }  else if (self.user) {
        self.title = self.user.displayName;
    }
}

#pragma mark - Life cycle

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(markAllUnreadMessagesAsRead)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(markAllUnreadMessagesAsRead)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rosterEntryDeleted:)
                                                 name:kTTKitRosterEntryWillDeleteNotification
                                               object:nil];
    
    [self becomeFirstResponder];
}

// Making sure we mark all unread messages in the conversation
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self markAllUnreadMessagesAsRead];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self markAllUnreadMessagesAsRead];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewControllerTitle];
    [self resetFetchController];
    
    self.hasMoreMessages = NO;
    
    // TableView setup
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.tableView registerNib:[UINib nibWithNibName:OutgoingMessageCellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OutgoingMessageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:IncomingMessageCellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:IncomingMessageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(LoadMoreMessagesHeaderView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(LoadMoreMessagesHeaderView.class)];
    [self.tableView reloadData];
    
    [self setBackButton];
    
    // Adjusting the tableView insets according to the message input position
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:self.messageInputView.height];
    self.tableView.contentInset = insets;
    
    // Making sure the table will scroll to bottom after the user open's the conversation
    [self scrollToBottomAnimated:NO];
}

// Setting up the back button view, this view will also display an unread messages count in the application excluding the current unread count in this conversation
- (void)setBackButton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-15];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:[ConversationBackView conversationBackViewWithConversationHash:self.rosterEntry.conversationHash]];
    self.navigationItem.leftBarButtonItems =  @[negativeSpacer, backItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)createFetchedResultsContorller:(NSString *)conversationHash
{
    NSFetchedResultsController *contorller = nil;
    if (SupportPagination) {
        self.messagesFetchOffset = 0;
        self.messagesBatchSize = MessagesPerPage;
        // Using a conversation fetched results contorller with batching, this will enable faster loading of messages for a given batch size
        contorller = [[TTKit sharedInstance] conversationFetchControllerWithConversationHash:conversationHash fetchLimit:self.messagesBatchSize batchSize:self.messagesBatchSize includeBangs:NO offset:self.messagesFetchOffset delegate:self];
    }
    else {
        // This conversation fetched results controller will load all messages without pagination
        contorller = [[TTKit sharedInstance] conversationFetchControllerWithConversationHash:self.rosterEntry.conversationHash includeBangs:NO delegate:self];
    }
    return contorller;
}

// Reseting the conversation fetched results controller
- (void)resetFetchController
{
    if (self.rosterEntry) {
        self.resultsController = [self createFetchedResultsContorller:self.rosterEntry.conversationHash];
        
        if (self.resultsController.fetchedObjects.count >= MessagesPerPage) {
            // If the current page results is bigger or equal to the max number of messages per page we set the load more button as a table header
            self.tableView.tableHeaderView = self.loadMoreMessagesHeaderView;
        } else {
            self.tableView.tableHeaderView = nil;
        }
        
        [self loadMessages:self.resultsController.fetchedObjects];
    }
}

#pragma mark - Messages Pagination

- (void)loadAdditionalMessages
{
    NSFetchedResultsController *contorller = [[TTKit sharedInstance] conversationFetchControllerWithConversationHash:self.rosterEntry.conversationHash fetchLimit:self.messagesBatchSize batchSize:self.messagesBatchSize includeBangs:NO offset:self.messages.count delegate:nil];
    
    if (contorller.fetchedObjects.count >= MessagesPerPage) {
        if (!self.tableView.tableHeaderView) {
            self.tableView.tableHeaderView = self.loadMoreMessagesHeaderView;
        }
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
    NSIndexPath *indexPathToScrollAfterPagination = [self addPaginatedMessages:contorller.fetchedObjects];
    [self.tableView reloadData];
    if (indexPathToScrollAfterPagination) {
        [self.tableView scrollToRowAtIndexPath:indexPathToScrollAfterPagination atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (NSIndexPath *)addPaginatedMessages:(NSArray *)additionalMessages
{
    self.hasMoreMessages = NO;
    if (additionalMessages.count >= self.messagesBatchSize) {
        self.hasMoreMessages = YES;
    }
    
    NSArray *reverseAdditionalMessagesArray = [[additionalMessages reverseObjectEnumerator] allObjects];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, additionalMessages.count)];
    [self.messages insertObjects:reverseAdditionalMessagesArray atIndexes:indexSet];
    NSIndexPath *indexPathToScrollToAfterPagination = nil;
    if (additionalMessages.count < self.messages.count) {
        indexPathToScrollToAfterPagination = [NSIndexPath indexPathForRow:additionalMessages.count inSection:0];
    }
    return indexPathToScrollToAfterPagination;
}

// Load TTMessage objects into the messages array, messages come in a reverse order so we need to make sure we reverse them before adding them to the array
- (void)loadMessages:(NSArray *)inMessages
{
    self.hasMoreMessages = NO;
    if (inMessages.count > MessagesPerPage) {
        self.hasMoreMessages = YES;
    }
    self.messages = [NSMutableArray arrayWithArray:[[inMessages reverseObjectEnumerator] allObjects]];
}

- (IBAction)onSendButtonPressed:(id)sender
{
    NSString *text = [self.inputMessageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0) {
        return;
    }
    
    [[TTKit sharedInstance] sendMessage:text
                            rosterEntry:self.rosterEntry
                               lifetime:kMessageTimeToLive
                           deleteOnRead:kDeleteOnRead
                         attachmentData:nil
                     attachmentMimeType:nil
                                success:^(TTMessage *newMessage) {

                                }
                                failure:^(NSError *error) {

                                }];
    
    self.inputMessageTextView.text = @"";
}

#pragma mark - Table View delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.messages.count) {
        return nil;
    }
    
    TTMessage *message = [self.messages objectAtIndex:indexPath.row];
    NSString *reuseIdentifier = [self reuseIdentifierForMessage:message];
    UITableViewCell<MessageLoading> *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [self configureCell:cell forMessage:message];
    return cell;
}

- (void)configureCell:(UITableViewCell<MessageLoading> *)cell forMessage:(TTMessage *)message
{
    [cell loadMessage:message];
}

- (NSString *)reuseIdentifierForMessage:(TTMessage *)message
{
    NSString *reuseIdentifier;
    if ([[TTKit sharedInstance] isUserLocalUser:(TTUser *)message.sender]) {
        reuseIdentifier = OutgoingMessageCellIdentifier;
    }else {
        reuseIdentifier = IncomingMessageCellIdentifier;
    }
    return reuseIdentifier;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
        {
            // If the newly inserted message is an incoming message (not sent by the local user) we mark it as Read
            TTMessage *message = (TTMessage *)anObject;
            if ([message isKindOfClass:[TTMessage class]]) {
                if (![message.sender.token isEqualToString:[[TTKit sharedInstance] userToken]]) {
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        [self markMessageAsRead:message];
                    }
                }
            }
            
            // Scrolling to the bottom of the table view once a new message is inserted
            if (self.isViewLoaded && self.view.window) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollAnimatedDelayed) object:nil];
                self.messagesBatchSize++;
                [self performSelector:@selector(scrollAnimatedDelayed) withObject:nil afterDelay:0.1];
            }
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            // Removing the deleted message object from the messages array and removing the corresponding cell
            self.tableManuallyUpdated = YES;
            self.messagesBatchSize--;
            
            TTMessage *deletedMessage = (TTMessage *)anObject;
            int index = 0;
            TTMessage *deletedItem = nil;
            for (TTMessage *item in self.messages) {
                if (deletedMessage == item) {
                    deletedItem = item;
                    break;
                }
                index++;
            }
            
            if (!deletedItem)  {
                self.tableManuallyUpdated = NO;
                return;
            }
            
            NSUInteger row = [self.messages indexOfObject:deletedItem];
            NSIndexPath *correctedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.messages removeObject:deletedItem];
            
            if ([[UIMenuController sharedMenuController] isMenuVisible]) {
                [[UIMenuController sharedMenuController] setMenuVisible:NO];
            }
            
            MessageCell *messageCell = (MessageCell *)[self.tableView cellForRowAtIndexPath:correctedIndexPath];
            if ([messageCell isKindOfClass:[MessageCell class]]) {
                // Must make sure the message textview resigns first responder before delete it otherwise it will cause a crash.
                [messageCell resignFirstResponder];
            }
            
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:correctedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            
            break;
        }
        default:
            break;
    }
}

// Reloading the messages after the fetched results controller is updated
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self loadMessages:self.resultsController.fetchedObjects];
    if (!self.tableManuallyUpdated) {
        [self.tableView reloadData];
    }
    self.tableManuallyUpdated = NO;
}

#pragma mark - Read Messages

- (void)markMessageAsRead:(TTMessage *)message
{
    if (!message || [message.status isEqualToString:kTTKitMessageStatusRead]) return;
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) return;
    if (!(self.isViewLoaded && self.view.window)) return;
    [[TTKit sharedInstance] markMessageAsRead:message];
}

// Marking all unread messages in the conversation as Read, performing this in a background thread to improve performance when opening the conversation screen
- (void)markAllUnreadMessagesAsRead
{
    if (!(self.isViewLoaded && self.view.window)) return;
    
    NSString *conversationHash = _rosterEntry.conversationHash;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (_rosterEntry) {
            BOOL isGroup = [_rosterEntry.target isKindOfClass:[TTGroup class]];
            [[TTKit sharedInstance] markAllUnreadMessagesAsReadForConversationHash:conversationHash isGroup:isGroup success:nil failure:nil];
        }
    });
}

#pragma mark - ScrollView

- (void)scrollAnimatedDelayed
{
    self.tableView.tableFooterView = nil;
    [self scrollToBottomAnimated:YES];
}

// Scroll the table to the bottom
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        CGFloat totalContentHeight = _tableView.contentSize.height;
        CGFloat heightOfOneView = _tableView.bounds.size.height - _tableView.contentInset.bottom;
        
        if (totalContentHeight + _tableView.contentInset.top > heightOfOneView) {
            if (_tableView.contentOffset.y == totalContentHeight - heightOfOneView) return;
            
            void (^updates)() = ^{
                _tableView.contentOffset = CGPointMake(0, totalContentHeight - heightOfOneView);
            };
            
            if (animated) {
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:updates
                                 completion:nil];
            }
            else {
                updates();
            }
        }
    }
}

#pragma mark - Message Input View

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIView *)inputAccessoryView
{
    if (self.messageInputView.superview == self.view) {
        [self.messageInputView removeFromSuperview];
    }
    return self.messageInputView;
}

#pragma mark - Table View Insets

// Updating the table view insets based on the message input view position
- (void)updateTableViewInsets
{
    CGRect keyboardRect = [self.view convertRect:self.inputAccessoryView.superview.frame fromView:nil];
    CGFloat bottom = self.view.height - CGRectGetMinY(keyboardRect);
    [self updateTableViewInsetsWithBottomValue:bottom];
}

- (void)updateTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, bottom, 0.0);
    
    CGFloat visibleArea = self.tableView.height - insets.top - insets.bottom;
    
    if (visibleArea < 50) {
        insets.top = [self standardTopInset];
    }
    return insets;
}

- (CGFloat)standardTopInset
{
    return self.navigationController.navigationBar.bottom;
}

#pragma mark - LoadMoreMessagesHeaderViewDelegate

// Loading next page of messages
- (void)didPressedLoadMoreMessages:(LoadMoreMessagesHeaderView *)sender
{
    [self loadAdditionalMessages];
}

- (LoadMoreMessagesHeaderView *)loadMoreMessagesHeaderView
{
    if (!_loadMoreMessagesHeaderView) {
        _loadMoreMessagesHeaderView = [LoadMoreMessagesHeaderView viewFromNib];
        _loadMoreMessagesHeaderView.delegate = self;;
    }
    return _loadMoreMessagesHeaderView;
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    [self animateScrollViewWithKeyboardNotification:notification];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    [self animateScrollViewWithKeyboardNotification:notification];
}

// Animating the table view bottom insets according to the keyboard's position
- (void)animateScrollViewWithKeyboardNotification:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardTop = CGRectGetMinY([self.view convertRect:keyboardRect fromView:nil]);
    CGFloat bottomInset = MAX(0, self.view.height - keyboardTop);

    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | (curve << 16);
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         [self updateTableViewInsetsWithBottomValue:bottomInset];
                         [self scrollToBottomAnimated:NO];
                     }
                     completion:nil];
}

#pragma mark - Notifications

// Pop the view controller if the current conversation TTRosterEntry object is being deleted
- (void)rosterEntryDeleted:(NSNotification *)notification
{
    NSDictionary *params = notification.userInfo;
    if (!params) return;
    
    NSString *conversationHash = params[@"conversationHash"];
    if (conversationHash.length == 0) return;
    
    if ([self.rosterEntry.conversationHash isEqualToString:conversationHash]) {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
