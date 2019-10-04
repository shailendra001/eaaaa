//
//  RegistrationViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController
@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *viContainerBottom;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;


@property (strong, nonatomic) IBOutlet UIView *viContainerAlreadyRegistered;

@property (strong, nonatomic) IBOutlet UILabel *lblLogin;
@property (strong, nonatomic) IBOutlet UIImageView *imgForwordDirection;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnLogin;

- (IBAction)login:(id)sender;
@end
