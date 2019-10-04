//
//  AuctionDetailTableViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 17/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerDetail;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lblArtName;
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lblAutherName;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;

@property (strong, nonatomic) IBOutlet UILabel *lblSeparartorLine;
@end
