//
//  UpdateProfileViewCell3.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 15/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewCell3 : UITableViewCell

@property (nonatomic)BOOL isRectangular;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *viContainerImage;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnSelect;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;
@end