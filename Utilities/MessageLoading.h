//
//  MessageLoading.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/24/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageLoading <NSObject>

- (void)loadMessage:(TTMessage *)message;

@end
