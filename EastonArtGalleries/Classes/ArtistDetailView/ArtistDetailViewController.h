//
//  ArtistDetailViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 30/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistDetailViewController : UIViewController

@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSArray* arrArtistDetail;
@property (strong, nonatomic) NSString* artUserName;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;

@property (strong, nonatomic) IBOutlet UIView *viContainerEmail;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnEmail;

@property (strong, nonatomic) IBOutlet UIView *viContainerInstagram;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnInstagram;

@property (strong, nonatomic) IBOutlet UIView *viContainerFB;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnFB;

@property (strong, nonatomic) IBOutlet UIView *viContainerTW;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnTW;

@property (strong, nonatomic) IBOutlet UIView *viContainerGooglePlus;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnGooglePlus;

@end
