//
//  RegistrationViewCell2.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewCell2 : UITableViewCell
//Register
@property (strong, nonatomic) IBOutlet UIView *viContainerRegister;
@property (strong, nonatomic) IBOutlet UILabel *lblRegister;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnRegister;

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
