//
//  BecomeAsellerPaymentVC.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 18/09/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BecomeAsellerPaymentVC : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dicParam;
//vc.titleString=@"Order Details";
//vc.from=@"back";
//vc.fromVC=kBecomeAsellerPaymentVC;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *fromVC;


// Paypal 

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (nonatomic, strong) NSMutableDictionary *transactionDetails;

@end
