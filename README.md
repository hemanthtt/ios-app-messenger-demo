# iOS Demo Messenger App

This repository contains binary distributions of the iOS SDK demo app released by TigerConnect.

This demo app supports the Login, Inbox, Organizations and Conversation view modules.

If you have any questions, comments, or issues related to this repository then please contact the team by emailing tigerconnect@tigertext.com.

## Installation
________________________________________
Import the the TTKit library header in your AppDelegate.m.

```objc
#import <TTKit/TTKit.h> 
```

Initialize the SDK in your AppDelegate’s application:

```objc
 [[TTKit sharedInstance] initializeWithAgent:"your_tigertext_agent" environment:TTKitEnvironmentProduction];
```

Please validate TTKit is connected using the following command:

```objc
[[TTKit sharedInstance] isUserConnected]
```

## Login

When you launch the iOS SDK demo app, you’ll be presented with a TigerTest login screen. The following code authenticates the user and effectively logs them in.

```objc
[[TTKit sharedInstance] loginWithUserId:@"username" password:@"password" 

  success:^(TTUser *user) { 
    // Handle login. 
  } failure:^(NSError *error) { 
    // Handle failure. 
  }];
```
## Logout

To logout from TTKit and deauthenticate the user, please use the following command:

```objc
[[TTKit sharedInstance] logout]
```

Logging out of TTKit will delete all local data including message and attachments, it will also deauthenticate the user's key/secret pair.

## NS Notifications 

Applications are notified of typing indicator events via NSNotification objects broadcast via the default NSNotificationCenter. 

Applications should register as an observer of the LYRConversationDidReceiveTypingIndicatorNotification notification to be notified when another user is typing.

```objc
kTTKitUnreadMessagesCountChangedNotification
kTTKitWillLogoutNotification
kTTKitDidReceiveRemoteLogoutNotification

[[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(refreshUnreadCount:)

name:kTTKitUnreadMessagesCountChangedNotification
object:nil];
    
[[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(didLogout)
name:kTTKitWillLogoutNotification
object:nil];
    
[[NSNotificationCenter defaultCenter] addObserver:self

selector:@selector(didReceiveRemoteLogoutNotification)

name:kTTKitDidReceiveRemoteLogoutNotification
object:nil];

```

## Getting Recent Conversations

After authenticating, the SDK will fetch all the recent conversations associated with the user and persist them in our local datastore. We use NSFetchResultsControllers to get your messages and register for any changes.

For example, if you take a look at the iOS demo app, we use the following

NSFetchResultsController for conversations:
```objc
NSFetchResultsController  *fetchController = [[TTKit sharedInstance] rosterFetchControllerWithDelegate:self]; 
NSArray *conversationObjects = [fetchController fetchedObjects];
```

To receive updates from the fetchController, be sure to implement the following methods:
```objc
(void)controllerDidChangeContent:(NSFetchedResultsController *) controller 

(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject 
  atIndexPath:(NSIndexPath *)indexPath 
  forChangeType:(NSFetchedResultsChangeType)type 
  newIndexPath:(NSIndexPath *)newIndexPath
```

For accounts with a large number of messages, it may take a little time to download and process these messages after authenticating. We have provided a simple progress bar in the iOS SDK demo app which you can choose to use inside your own app.

## Send a Message

If you have completed sending a TigerText message to Echobot, you should be able to see the conversation and send another message via the iOS SDK demo app. There are several ways to send a message. The following snippet is one way to send a message that has a lifetime of 60 minutes.

```objc
[[TTKit sharedInstance] sendMessage:message 
  rosterEntry:rosterEntry 
  lifetime:60 
  deleteOnRead:NO 
  success:nil 
  failure:nil];
 ```
 
To send a message with attachments, please specify the mime type.

You can pass an NSData object or a file path to the data you wish to upload as the attachment (using the file path for larger files).  The max attachment size is currently 10MB.

```objc
[[TTKit sharedInstance] sendMessage:message 
  rosterEntry:rosterEntry 
  lifetime:60 
  deleteOnRead:NO
  attachmentPath:"attachment_path_name"
  attachmentMimeType:"attachment_mime_type"
  success:nil 
  failure:nil];

[[TTKit sharedInstance] sendMessage:message 
  rosterEntry:rosterEntry 
  lifetime:60 
  deleteOnRead:NO
  attachmentData:"your_tigertext_agent"
  attachmentData:(NSData *)attachmentData
  success:nil 
  failure:nil];
```
