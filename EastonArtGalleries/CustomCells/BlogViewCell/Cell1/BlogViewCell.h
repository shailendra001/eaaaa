//
//  BlogViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 09/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viContainerDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;
@end
