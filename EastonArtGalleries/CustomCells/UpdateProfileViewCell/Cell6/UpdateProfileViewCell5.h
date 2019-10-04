//
//  UpdateProfileViewCell5.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/01/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewCell5 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerVideoPart;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnOpenMedia;

@property (strong, nonatomic) IBOutlet UIView *viContainerRemove;
@property (strong, nonatomic) IBOutlet UIImageView *imgRemove;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnRemove;
@property (strong, nonatomic) IBOutlet UIView *viContainerVideoLink;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtField;



@end
