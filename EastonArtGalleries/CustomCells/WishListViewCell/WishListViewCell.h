//
//  WishListViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 23/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *viContainerCell;

@property (strong, nonatomic) IBOutlet UIImageView *imgPic;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSize;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@property (strong, nonatomic) IBOutlet UIView *viContainerRemove;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnRemove;

@end
