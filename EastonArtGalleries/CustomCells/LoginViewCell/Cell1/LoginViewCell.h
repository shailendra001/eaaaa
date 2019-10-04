//
//  LoginViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 07/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewCell : UITableViewCell


//Login
@property (strong, nonatomic) IBOutlet UIView *viContainerLogin;
@property (strong, nonatomic) IBOutlet UILabel *lblLogin;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnLogin;

//Facebook
@property (strong, nonatomic) IBOutlet UIView *viContainerFacebook;
@property (strong, nonatomic) IBOutlet UIImageView *lblFacebook;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnFacebook;

//Google Plus
@property (strong, nonatomic) IBOutlet UIView *viContainerGoogle;
@property (strong, nonatomic) IBOutlet UIImageView *lblGoogle;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnGoogle;

@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;

@end
