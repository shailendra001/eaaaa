//
//  CurrentBidderTableViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 19/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentBidderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerHeader;
@property (strong, nonatomic) IBOutlet UIStackView *stackHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblBidderName;
@property (strong, nonatomic) IBOutlet UILabel *lblBidderDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBidderAmount;


@end
