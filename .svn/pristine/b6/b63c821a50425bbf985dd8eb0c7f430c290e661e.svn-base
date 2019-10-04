//
//  CardDetailViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 29/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDetailViewController : UIViewController
@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viContainerEdit;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit;

@property (strong, nonatomic) IBOutlet UIView *viContainerContinue;
@property (strong, nonatomic) IBOutlet UILabel *lblContinue;

@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorVirticalLine;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (nonatomic, strong) NSMutableDictionary *transactionDetails;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnEdit;

- (IBAction)edit:(id)sender;

- (IBAction)placeOrder:(id)sender;
@end
