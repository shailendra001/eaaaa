//
//  AddAddressViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 01/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressViewController : UIViewController

@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) NSDictionary* address;
@property (strong, nonatomic) NSArray* arrProducts;
@property (strong, nonatomic) NSArray* arrQuantity;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viContainerCancel;
@property (strong, nonatomic) IBOutlet UIView *viContainerSave;

@property (strong, nonatomic) IBOutlet ZFRippleButton *btnCancel;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnSave;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLineVirtical;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end