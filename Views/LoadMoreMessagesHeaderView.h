//
//  LoadMoreMessagesHeaderView.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 12/10/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadMoreMessagesHeaderViewDelegate;

@interface LoadMoreMessagesHeaderView : UITableViewHeaderFooterView

@property (nonatomic) id<LoadMoreMessagesHeaderViewDelegate> delegate;

+ (CGFloat)headerHeight;
- (void)setLoadMoreLabelText:(NSString *)text;

@end

@protocol LoadMoreMessagesHeaderViewDelegate <NSObject>

- (void)didPressedLoadMoreMessages:(LoadMoreMessagesHeaderView *)sender;

@end
