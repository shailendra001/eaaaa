//
//  ArtRegistrationViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 05/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtRegistrationViewController : UIViewController

@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imgStep;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *textFieldCertificateNo;
@property (strong, nonatomic) IBOutlet UIButton *buttonDownload;

@property (nonatomic, strong) NSString *strPaymentType;
@property (nonatomic, strong) NSString *strTxnId;
@property (nonatomic, strong) NSString *strPaymentStatus;
@property (nonatomic, strong) NSString *strAmount;

- (IBAction)buttonDownloadTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewDownloadcertificate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintLevelViewTop;


@property (strong, nonatomic) NSString* dataAccesskey;
@property (strong, nonatomic) NSArray* arrArtCategoryList;

@end