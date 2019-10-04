//
//  ManageArtCollectionViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 20/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageArtCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgSold;


@property (strong, nonatomic) IBOutlet UIView *viContainerDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblAutherName;
@property (strong, nonatomic) IBOutlet UILabel *lblSize;
@property (strong, nonatomic) IBOutlet UIView *viContainerLeftButtons;
@property (strong, nonatomic) IBOutlet UIView *viContainerEdit;
@property (strong, nonatomic) IBOutlet UIImageView *imgEdit;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIView *viContainerDelete;
@property (strong, nonatomic) IBOutlet UIImageView *imgDelete;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnDelete;

@property (strong, nonatomic) IBOutlet UIView *viContainerRightButtons;

@property (strong, nonatomic) IBOutlet UIView *viContainerLive;
@property (strong, nonatomic) IBOutlet UIImageView *imgSend;
@property (strong, nonatomic) IBOutlet UILabel *lblLive;
@property (strong, nonatomic) IBOutlet UILabel *lblPending;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnLive;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnSold;


@end