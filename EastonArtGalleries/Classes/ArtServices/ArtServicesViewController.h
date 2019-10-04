//
//  ArtServicesViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 01/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtServicesViewController : UIViewController
@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *viewPopUp;
@property (strong, nonatomic) IBOutlet UIView *viewPoupInner;

@end
