//
//  OrganizationCell.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 11/20/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

/**
 @abstract `OrganizationCell` presents and manages the presentation of `TTOrganization` objects
 */
@interface OrganizationCell : UITableViewCell

/**
 @abstract The TTOrganization to be displayed.
 */
@property (nonatomic) TTOrganization *item;

/**
 @abstract returns the cell height.
 */
+ (CGFloat)cellHeight;

@end
