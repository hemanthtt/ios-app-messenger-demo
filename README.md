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

## Send a Message

If you have completed sending a TigerText message to Echobot, you should be able to see the conversation and send another message via the iOS SDK demo app. There are several ways to send a message. The following snippet is one way to send a message that has a lifetime of 60 minutes.

First Create a TTMessageRequest object
```objc

TTMessageRequest *messageRequest = [[TTMessageRequest alloc] initWithRecipientToken:self.rosterEntry.target.token];
messageRequest.messageText = text;
messageRequest.timeToLive = kMessageTimeToLive;
messageRequest.deleteOnRead = kDeleteOnRead;
```
Then Request TTKit to Process the Request
```objc

[[TTKit sharedInstance] sendMessageWithRequest:messageRequest
completion:^(TTMessage *message, NSError *error) {

}];

```
To send a message with attachments, please specify the mime type.

You can pass an NSData object or a file path to the data you wish to upload as the attachment (using the file path for larger files).  The max attachment size is currently 10MB.

```objc
messageRequest.attachmentData = data;
messageRequest.attachmentMimeType = @"image/jpeg";

messageRequest.attachmentFilePath = @"attachment_file_path";
messageRequest.attachmentMimeType = @"image/jpeg";
```

