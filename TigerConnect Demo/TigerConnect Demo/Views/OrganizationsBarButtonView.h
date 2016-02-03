//
//  OrganizationsBarButtonView.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrganizationsBarButtonViewDelegate;

/**
 @abstract `OrganizationsBarButtonView` displays the organization icon and a red dot to signal unread messages in other organizaitions.
 */
@interface OrganizationsBarButtonView : UIView

@property (nonatomic) id<OrganizationsBarButtonViewDelegate> delegate;

+ (instancetype)barView;

@end

@protocol OrganizationsBarButtonViewDelegate <NSObject>

- (void)organizationBarButtonPressed:(id)sender;


@end
