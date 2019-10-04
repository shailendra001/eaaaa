//
//  ByCertificateVC.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 15/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCertificateVC : UIViewController  <PayPalPaymentDelegate,
PayPalFuturePaymentDelegate,
UIPopoverControllerDelegate>

@property (strong, nonatomic) NSString *strFrom;
@property (strong, nonatomic) NSString *strRegId;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewTableFooter;
@property (strong, nonatomic) IBOutlet UIImageView *imageCertificate;
@property (strong, nonatomic) IBOutlet UIButton *buttonSubmit;


@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (nonatomic, strong) NSMutableDictionary *transactionDetails;

@end
