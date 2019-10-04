//
//  ValuationOfArtViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 01/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuationOfArtViewController : UIViewController <PayPalPaymentDelegate,
PayPalFuturePaymentDelegate,
PayPalProfileSharingDelegate,
UIPopoverControllerDelegate>

@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imgStep;
@property (strong, nonatomic) IBOutlet UITableView *tableView;



@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (nonatomic, strong) NSMutableDictionary *transactionDetails;

@property (nonatomic, strong) NSString *strTxnId;
@property (nonatomic, strong) NSString *strPaymentStatus;
@property (nonatomic, strong) NSString *strAmount;
@property (nonatomic, strong) NSString *strPaymentType;
@property (strong, nonatomic) IBOutlet UIView *viewPopup;
@property (strong, nonatomic) IBOutlet UIView *viewPopupInner;
@property (strong, nonatomic) IBOutlet UITextView *textViewPopupDesc;

- (IBAction)buttonHidePopupTapped:(id)sender;

// By Chandra

//@property (nonatomic, strong) NSString *strArtistName;
//@property (nonatomic, strong) NSString *strArtWorkSize;
//@property (nonatomic, strong) NSString *strArtworkMedium;
//@property (nonatomic, strong) NSString *strDateArtWorkCompleted;
@property (nonatomic, strong) NSString *strPurchaseTime;
@property (nonatomic, strong) NSString *strPurchasePlace;
@property (nonatomic, strong) NSString *strPurchasePrice;


@property (nonatomic, strong) NSString *strDateStartAsAnArtist;
@property (nonatomic, strong) NSString *strCurrentPriceOfArtwork;
@property (nonatomic, strong) NSString *strPicesYouSold;
@property (nonatomic, strong) NSString *strOnlineSourcesDoYouUse;


@property (nonatomic, strong) NSString *strByWhome;
@property (nonatomic, strong) NSString *strByDate;


@property (nonatomic, strong) NSString *strGalleryThatSellYourWork;
@property (nonatomic, strong) NSString *strWhereYouExhibited;

@property (strong, nonatomic) NSString *strTermsOfServices;
@property (strong, nonatomic) NSString *strTermsOfServicesPremium;
@property (strong, nonatomic) NSString *strTermsOfServicesNonPremium;


@end
