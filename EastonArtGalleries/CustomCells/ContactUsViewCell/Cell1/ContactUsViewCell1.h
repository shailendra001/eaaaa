//
//  ContactUsViewCell1.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 31/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

//Address

@interface ContactUsViewCell1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viContainerAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imgAddress;

//Phone

@property (strong, nonatomic) IBOutlet UIView *viContainerPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePhone;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhone;

//Email

@property (strong, nonatomic) IBOutlet UIView *viContainerEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmail;

@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;
@end
