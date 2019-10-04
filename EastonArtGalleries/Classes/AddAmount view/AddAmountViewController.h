//
//  AddAmountViewController.h
//  Talk2Good
//
//  Created by Sandeep Kumar on 15/09/15.
//  Copyright (c) 2015 InfoiconTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAmountViewController : UITableViewController
<PayPalPaymentDelegate,
PayPalFuturePaymentDelegate,
PayPalProfileSharingDelegate,
UIPopoverControllerDelegate>

@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) id pageData;

@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UIButton *btnPayPal;

@property (strong, nonatomic) IBOutlet UIButton *btnUpdateTransaction;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@property (nonatomic, strong) NSMutableDictionary *transactionDetails;



- (IBAction)paypal:(id)sender;
- (IBAction)updateTransaction:(id)sender;

@end
