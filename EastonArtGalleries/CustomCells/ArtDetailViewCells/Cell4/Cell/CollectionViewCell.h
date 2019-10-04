//
//  CollectionViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *viContainerCell;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnOpenMedia;

@property (strong, nonatomic) IBOutlet UIView *viContainerRemove;
@property (strong, nonatomic) IBOutlet UIImageView *imgRemove;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnRemove;

@end