//
//  UpdateProfileViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 15/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerText;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;

@end
