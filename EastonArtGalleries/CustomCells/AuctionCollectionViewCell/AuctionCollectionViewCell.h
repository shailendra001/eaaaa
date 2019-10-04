//
//  AuctionCollectionViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 17/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet MZTimerLabel *lblTime;



@property (strong, nonatomic) IBOutlet UIView *viContainerDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblAutherName;
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UILabel *lblBid;

@end
