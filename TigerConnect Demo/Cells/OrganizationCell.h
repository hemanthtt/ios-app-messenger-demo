//
//  OrganizationCell.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/20/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

/**
 @abstract `OrganizationCell` presents and manages the presentation of `TTOrganization` objects
 @discussion If you wish to change the default fonts and colors of this cell please refer to `OrganizationCell.xib` or refer to `AppearanceUtilities`
 */
@interface OrganizationCell : UITableViewCell

/**
 @abstract The TTOrganization to be displayed.
 */
@property (nonatomic) TTOrganization *item;

/**
 @abstract Organization name label text color.
 */
@property (nonatomic) UIColor *organizationNameLabelColor UI_APPEARANCE_SELECTOR;

/**
 @abstract Organization name label font.
 */
@property (nonatomic) UIFont  *organizationNameLabelFont UI_APPEARANCE_SELECTOR;

/**
 @abstract Selected organization name label color.
 */
@property (nonatomic) UIColor *selectedOrganizationNameLabelColor UI_APPEARANCE_SELECTOR;

/**
 @abstract Selected organization name label font.
 */
@property (nonatomic) UIFont  *selectedOrganizationNameLabelFont UI_APPEARANCE_SELECTOR;

/**
 @abstract Selected cell background color.
 */
@property (nonatomic) UIColor *selectedCellBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 @abstract Selected indicator color.
 */
@property (nonatomic) UIColor *selectedIndicatorViewColor UI_APPEARANCE_SELECTOR;

/**
 @abstract returns the cell height.
 */
+ (CGFloat)cellHeight;

@end
