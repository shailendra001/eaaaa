//
//  OrderDetailViewCell1.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerCell;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic) IBOutlet UILabel *lblArtName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblArtSize;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;

@property (strong, nonatomic) IBOutlet UIView *viContainerReview;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnReview;

@property (strong, nonatomic) IBOutlet UIView *viContainerCancel;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnCancel;
@end
