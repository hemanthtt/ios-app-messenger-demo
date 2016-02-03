
//
//  LoadMoreMessagesHeaderView.m
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 12/10/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "LoadMoreMessagesHeaderView.h"

@interface LoadMoreMessagesHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *loadMoreMessageLabel;

@end

@implementation LoadMoreMessagesHeaderView

+ (CGFloat)headerHeight
{
    return 50.0;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.loadMoreMessageLabel.textColor = leadingColor();
}

- (IBAction)onLoadMoreButtonPressed:(id)sender
{
    [self.delegate didPressedLoadMoreMessages:self];
}

- (void)setLoadMoreLabelText:(NSString *)text
{
    self.loadMoreMessageLabel.text = text;
}

@end
