//
//  BecomeAsellerPaymentVC.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 18/09/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "BecomeAsellerPaymentVC.h"
#import "BecomeAsellerPaymentTVCell.h"



#define CURRENCY_TYPE           @"USD"
#define SHORT_DESCRIPTION       @"Credit Money"
#define isTRANSACTION_BECOME_SELLER             @"ispaid"
#define TRANSACTION_DETAIL_BECOME_SELLER        @"becomeaseller"



// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.

#define kPayPalEnvironment PayPalEnvironmentProduction

#define PAYPAL_TRANSACTION_MEMBER_ID            @"member"
#define PAYPAL_TRANSACTION_CURRENCY             @"currency"
#define PAYPAL_TRANSACTION_ID                   @"txn_id"
#define PAYPAL_TRANSACTION_TYPE                 @"transaction_type"
#define PAYPAL_TRANSACTION_AMOUNT               @"transaction_amount"
#define PAYPAL_TRANSACTION_STATUS               @"transaction_status"
#define PAYPAL_TRANSACTION_CARD                 @"transaction_card"
#define PAYPAL_TRANSACTION_BILLING_FIRST_NAME   @"billing_firstName"
#define PAYPAL_TRANSACTION_BILLING_LAST_NAME    @"billing_lastName"
#define PAYPAL_TRANSACTION_BILLING_ADDRESS      @"billing_address"
#define PAYPAL_TRANSACTION_BILLING_CITY         @"billing_city"
#define PAYPAL_TRANSACTION_BILLING_STATE        @"billing_state"
#define PAYPAL_TRANSACTION_BILLING_POST_CODE    @"billing_post_code"
#define PAYPAL_TRANSACTION_BILLING_COUNTRY      @"billing_country"
#define PAYPAL_TRANSACTION_DESCRIPTION          @"description"
#define PAYPAL_TRANSACTION_TIME                 @"added_on"
//#define PAYPAL_TRANSACTION_METHOD               @"transaction_method"
#define PAYPAL_TRANSACTION_METHOD               @"transaction_method"





@interface BecomeAsellerPaymentVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PayPalPaymentDelegate,
PayPalFuturePaymentDelegate,
PayPalProfileSharingDelegate>

{
        UIActivityIndicatorView *activityIndicator;
        BOOL isBasicMemberShip;
        
        NSDictionary* dicResult;
        NSMutableDictionary *dicCouponInfo;
        NSString *strValidatedCouponAmount;
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *successView;


@end

@implementation BecomeAsellerPaymentVC

static NSString *CellIdentifier1 = @"Cell1";

- (void)viewDidLoad {
        
    [super viewDidLoad];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.estimatedRowHeight = 50.0f;
        
        [self cellRegister];
        [self setLogoImage];
        [self setNav];
        strValidatedCouponAmount = @"0";
}


-(void)cellRegister {
        
        [self.tableView registerClass:[BecomeAsellerPaymentTVCell class] forCellReuseIdentifier:CellIdentifier1];
       
        
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"BecomeAsellerPaymentTVCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
     
}

-(void)setLogoImage {
        
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
}

-(void)setNav {
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}


-(void)setActivityIndicator {
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-15,
                                             [UIScreen mainScreen].bounds.size.height/3-15,
                                             30,
                                             30);
        [activityIndicator startAnimating];
        
        
        [activityIndicator removeFromSuperview];
        [self.view addSubview:activityIndicator];
        //[self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
}

-(void)setBackgroundLabel {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data found";
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:18];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



-(void)removeBackgroundLabel {
        
        self.tableView.backgroundView = nil;
}

-(void)removeActivityIndicator {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
        
    [super didReceiveMemoryWarning];
}

#pragma mark - TextField Delegate Method -

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
        [textField resignFirstResponder];

        return YES;
}

#pragma mark -
#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        
        return UITableViewAutomaticDimension;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        BecomeAsellerPaymentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textFieldCouponCode.delegate  = self;

        
        if(indexPath.row == 0){
                
                cell.labelDescription.text = @"BASIC MEMBERSHIP $39.99/month, ($119 to start, includes 3 free months) Full Access to Easton Art Galleries website Add Unlimited Works of Art Full social media integration between the artist's pages and their social media outlets, including Facebook, Twitter and Instagram";
                cell.labelPaymentType.text = @"Bsic Membership ($119)";
                cell.buttonApplyCoupon.tag = 100;
                cell.buttonMemerShipTapped.tag = 200;
                cell.textFieldCouponCode.tag = 300;
              //  cell.textFieldCouponCode.text = @"1221212hgg";
                [cell.buttonMemerShipTapped setTitle:@"Basic Membership ($119)" forState:UIControlStateNormal];
                
        } else if (indexPath.row == 1) {
        
                cell.labelDescription.text = @"DELUXE MEMBERSHIP $500/year In addition to the above features, the prepair annual membership includes Free support assistance in migrating existing artwork images from the artist's website to the Easton Art Galleries website< Inclusion in our Art Placement Program, in which we work with our corporate and business clients to get your artwork placed in physical locations for display and sales";
                cell.labelPaymentType.text = @"Bsic Membership ($500)";
                cell.buttonApplyCoupon.tag = 101;
                cell.buttonMemerShipTapped.tag = 201;
                cell.textFieldCouponCode.tag = 301;

                [cell.buttonMemerShipTapped setTitle:@"Deluxe Membership ($500)" forState:UIControlStateNormal];

        }
        
        [cell.buttonApplyCoupon addTarget:self action:@selector(buttonApplyCouponTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonMemerShipTapped addTarget:self action:@selector(buttonMembershipTapped:) forControlEvents:UIControlEventTouchUpInside];
        

        
        return cell;
}

-(void)buttonApplyCouponTapped:(UIButton *)button {
        
        UITextField *textField = [self.tableView viewWithTag:button.tag + 200];
        if(IS_EMPTY(textField.text))
        {
                [Alert alertWithMessage:@"Field can't be empty !"
                             navigation:self.navigationController
                               gotoBack:NO animation:YES second:2.0];
                return;
        }
        //        {"coupon":"1221212hgg","user":"193"}
        
        dicCouponInfo =[NSMutableDictionary dictionary];
        if([[EAGallery sharedClass] isLogin])
                [dicCouponInfo setObject:[[EAGallery sharedClass] memberID]       forKey:@"user"];
        [dicCouponInfo setObject:textField.text forKey:@"coupon"];
        
        
        [self validateCouponCodeWebService:[dicCouponInfo mutableCopy]];
}

-(void)buttonMembershipTapped: (UIButton  *)button {

        //Paypal open
        if (button.tag == 200) {
                
                isBasicMemberShip = YES;
        } else {
                isBasicMemberShip = NO;
        }
        
        dicResult = [self.dicParam mutableCopy];
        
        [self openPayPalView];
        
}

#pragma mark -
#pragma mark - Web Api method -

-(void)validateCouponCodeWebService:(NSDictionary*)dic {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl,[[EAGallery sharedClass] isLogin] ? kURL_ValidateCouponCode : kURL_ValidateCouponCodeWithoutUser);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:postString
                                                                       urlString:urlString
                                                                      methodType:REQUEST_METHOD_TYPE_POST
                                                                          images:nil];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:3.0];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:3.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                        NSDictionary*resPonsedata = (NSDictionary*)[result valueForKey:@"data"];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                
                                                strValidatedCouponAmount = [resPonsedata objectForKey:@"amount"];
                                                /*
                                                NSIndexPath *indexPath = [Alert getIndexPathWithButton:applyButton table:self.tableView];
                                                NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                                NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                                
                                                NSMutableDictionary* dic=[arrData objectAtIndex:applyButton.tag+(indexPath.section==2 ? (row+row1) : 0)];
                                                
                                                [dic setObject:[resPonsedata objectForKey:@"amount"]
                                                        forKey:@"amount"];
                                                
                                                //NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                
                                                //                                                [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                               
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        [UIView transitionWithView:self.tableView
                                                                          duration:0.3
                                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                         
                                                                        animations:nil
                                                                        completion:nil];
                                                        
                                                        
                                                        
                                                        [self.tableView reloadData];
                                                        
                                                });
                                                 */
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        
                                        strValidatedCouponAmount = @"0";
                                }
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}


-(void)submitWebService:(NSDictionary*)dic {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, [[EAGallery sharedClass] isLogin] ? kURL_ArtistAdd : kURL_BecomeASeller);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:postString
                                                                       urlString:urlString
                                                                      methodType:REQUEST_METHOD_TYPE_POST
                                                                          images:nil];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:3.0];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:5.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                        //NSString* sellerStatus=[result objectForKey:@"sellerStatus"];
                                        if([[EAGallery sharedClass] isLogin])
                                                [EAGallery sharedClass].roleType        =[[EAGallery sharedClass] getRoleType:[[result objectForKey:LOGIN_ROLE_TYPE] intValue]];
                                        else{
                                             //   [self loadData];
                                        }
                                        
                                        //Removing Payment details from local
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:isTRANSACTION_BECOME_SELLER];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TRANSACTION_DETAIL_BECOME_SELLER];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                
                                                
                                                [UIView transitionWithView:self.tableView
                                                                  duration:0.3
                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                 
                                                                animations:nil
                                                                completion:nil];
                                                
                                                
                                                
                                                [self.tableView reloadData];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateView" object:self];
                                                
                                                if(![[EAGallery sharedClass] isLogin])
                                                        MOVE_VIEW_CONTROLLER_VIEW_DECK(GET_VIEW_CONTROLLER(kViewController));
                                                
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                else{
                                }
                                
                        }
                        
                }
                
        });
        
}

#pragma mark -
#pragma mark - PayPal Payment gateway -

-(void)updateAmountFromPayPalToServer {
        
        self.transactionDetails=nil;
        
        //    [self resetTransactionDetail];
        [[SharedClass sharedObject] hudeHide];
        
        BOOL tran = [[NSUserDefaults standardUserDefaults] boolForKey:isTRANSACTION_BECOME_SELLER];
        
        if( tran)
        {
                self.transactionDetails=[[NSUserDefaults standardUserDefaults] objectForKey:TRANSACTION_DETAIL_BECOME_SELLER];
                self.transactionDetails=self.transactionDetails ? self.transactionDetails :nil;
                
        }
        
        if(self.transactionDetails!=nil)
        {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                //[[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                
                //[[self appDelegate] callUpdateTransactionDetailWS];
                //                });
                //{"order_id":"184","txn_id":"sss","quantity":[344,344,345]}
                
                
                NSLog(@"Transaction detail send to the server successfully");
                
                
                
                /*
                NSMutableDictionary* data = [arrData objectAtIndex:17];
                NSMutableDictionary* dic = [self.dicParam mutableCopy];
                
                [dic setObject:@"2"
                        forKey:@"membershipType"];
                [dic setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_AMOUNT]
                        forKey:@"txn_amt"];
                [dic setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_ID]
                        forKey:PAYPAL_TRANSACTION_ID];
                [dic setObject:[dicCouponInfo objectForKey:@"value"]
                        forKey:@"coupon"];
                
                [self submitWebService:[dic mutableCopy]];
                */
                
                
                [self.dicParam setObject:@"2"
                        forKey:@"membershipType"];
                [self.dicParam setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_AMOUNT]
                        forKey:@"txn_amt"];
                [self.dicParam setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_ID]
                        forKey:PAYPAL_TRANSACTION_ID];
                [self.dicParam setObject:[dicCouponInfo objectForKey:@"value"]
                        forKey:@"coupon"];
                
                [self submitWebService:[self.dicParam mutableCopy]];
                
                
        }
        else{
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                //                [[SharedClass sharedObject] hudeHide];
                //                });
                NSLog(@"No Transaction detail Exist locally");
        }
}

- (void)delayedDidFinish:(PayPalPayment *)completedPayment {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //                {
        //                        client =     {
        //                                environment = sandbox;
        //                                "paypal_sdk_version" = "2.12.7";
        //                                platform = iOS;
        //                                "product_name" = "PayPal iOS SDK";
        //                        };
        //                        response =     {
        //                                "create_time" = "2015-12-05T10:05:56Z";
        //                                id = "PAY-6NJ65006RK451445LKZRLN7I";
        //                                intent = sale;
        //                                state = approved;
        //                        };
        //                        "response_type" = payment;
        //                }
        
        dispatch_async(dispatch_get_main_queue(), ^{
                // NSDictionary* addressDic=[self getAddress];
                
                //PayPalItem *item1=completedPayment.items[0];
                //PayPalShippingAddress*shippingAddress=completedPayment.shippingAddress;
                
                //NSString* address=[NSString stringWithFormat:@"%@, \n%@",shippingAddress.line1,shippingAddress.line2];
                
                
                NSDictionary* paymentDescription=[completedPayment.confirmation mutableCopy];
                
                NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
                [mutDictTransactionDetails setObject:[[EAGallery sharedClass]isLogin] ? [[EAGallery sharedClass] memberID] :@""
                                              forKey:PAYPAL_TRANSACTION_MEMBER_ID];
                
                [mutDictTransactionDetails setObject:completedPayment.currencyCode
                                              forKey:PAYPAL_TRANSACTION_CURRENCY];
                
                [mutDictTransactionDetails setObject:[[paymentDescription objectForKey:@"response"] objectForKey:@"id"]
                                              forKey:PAYPAL_TRANSACTION_ID];
                
                [mutDictTransactionDetails setObject:@"credit"
                                              forKey:PAYPAL_TRANSACTION_TYPE];
                
                [mutDictTransactionDetails setObject:[completedPayment.amount stringValue]
                                              forKey:PAYPAL_TRANSACTION_AMOUNT];
                
                [mutDictTransactionDetails setObject:@"completed"
                                              forKey:PAYPAL_TRANSACTION_STATUS];
                
                [mutDictTransactionDetails setObject:@""        forKey:PAYPAL_TRANSACTION_CARD];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_FIRST_NAME];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_LAST_NAME];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_ADDRESS];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_CITY];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_STATE];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_POST_CODE];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_COUNTRY];
                
                [mutDictTransactionDetails setObject:[SHORT_DESCRIPTION lowercaseString]
                                              forKey:PAYPAL_TRANSACTION_DESCRIPTION];
                
                [mutDictTransactionDetails setObject:[[paymentDescription objectForKey:@"response"] objectForKey:@"create_time"]
                                              forKey:PAYPAL_TRANSACTION_TIME];
                
                [mutDictTransactionDetails setObject:@"credit_card"
                                              forKey:PAYPAL_TRANSACTION_METHOD];
                
                
                //[mutDictTransactionDetails setObject:@""        forKey:@""];
                [self navigateToPaymentStatusScreen:mutDictTransactionDetails];
        });
}

- (void)navigateToPaymentStatusScreen: (NSMutableDictionary *)mutDictTransactionDetails {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isTRANSACTION_BECOME_SELLER ];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutDictTransactionDetails  forKey:TRANSACTION_DETAIL_BECOME_SELLER];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        //        });
}

#pragma mark -PayPal

-(void)configPayPal {
        
   //     self.title = @"PayPal";
        
        // Set up payPalConfig
        _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
        _payPalConfig.acceptCreditCards = YES;
#else
        _payPalConfig.acceptCreditCards = YES;
#endif
        _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
        
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.successView.hidden = YES;
        
        // use default environment, should be Production in real life
        self.environment = kPayPalEnvironment;
        
        [PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
        
        NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}

- (BOOL)acceptCreditCards {
        return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
        self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)setPayPalEnvironment:(NSString *)environment {
        
        self.environment = environment;
        [PayPalMobile preconnectWithEnvironment:environment];
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
        NSLog(@"PayPal Payment Success!");
        
        //        [self performSelector:@selector(delayedDidFinish:) withObject:completedPayment afterDelay:0.0];
        
        [self delayedDidFinish:completedPayment];
        
        self.resultText = [completedPayment description];
        
        
        
        
        [self showSuccess];
        
        [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                //Set Transaction detail on Local server
                [self updateAmountFromPayPalToServer];
                
        });
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
        NSLog(@"PayPal Payment Canceled");
        self.resultText = nil;
        self.successView.hidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
        
        // TODO: Send completedPayment.confirmation to server
        NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - PayPalProfileSharingDelegate methods -


- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
        
        NSLog(@"PayPal Profile Sharing Authorization Success!");
        self.resultText = [profileSharingAuthorization description];
        [self showSuccess];
        
        [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
        
        NSLog(@"PayPal Profile Sharing Authorization Canceled");
        self.successView.hidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
        
        // TODO: Send authorization to server
        NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}


#pragma mark - Helpers

- (void)showSuccess {
        
        self.successView.hidden = NO;
        self.successView.alpha = 1.0f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:2.0];
        self.successView.alpha = 0.0f;
        [UIView commitAnimations];
}

#pragma mark - Flipside View Controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([[segue identifier] isEqualToString:@"pushSettings"]) {
                [[segue destinationViewController] setDelegate:(id)self];
        }
}


#pragma mark - Open PayPal view -

-(void)openPayPalView {
        
        // Remove our last completed payment, just for demo purposes.
        //        self.resultText = nil;
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        
        
        //        NSNumber* sum = [data valueForKeyPath: @"@sum.TOTAL_SUM"];//Total amount from all cart items
        //        NSString* amountString=[sum stringValue];
        //        NSDecimalNumber *amount = [[NSDecimalNumber alloc] initWithString:amountString];
        
//        NSMutableDictionary* dic = [arrData objectAtIndex:17];
//        NSString* amountCoupon= [dic objectForKey:@"amount"];
        
        NSString* totalAmount = isBasicMemberShip ? @"119" : @"500";

        NSString* amount=[@(totalAmount.intValue-strValidatedCouponAmount.intValue) stringValue];
        
        // Optional: include multiple items
        
        PayPalItem *item1 = [PayPalItem itemWithName:@"Easton Art Gallery"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:amount]
                                        withCurrency:CURRENCY_TYPE
                                             withSku:[NSString stringWithFormat:@"EastonArtGallery-%@",amount]];
        /*
         PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
         withQuantity:1
         withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
         withCurrency:@"USD"
         withSku:@"Hip-00066"];
         PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
         withQuantity:1
         withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
         withCurrency:@"USD"
         withSku:@"Hip-00291"];
         NSArray *items = @[item1, item2, item3];
         */
        
        /*
         //        NSArray *items =[[self getPayPalItemsFromCartItems:[data mutableCopy]] mutableCopy];
         //
         //        arrResultPaypalItems=items;
         //
         //        // Optional: include payment details
         //        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
         //        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
         //        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
         //        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
         //                                                                                   withShipping:shipping
         //                                                                                        withTax:tax];
         
         //Total price of all cart items
         //NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
         
         
         //Optional : include shipping address
         //        NSDictionary* addressDic=[self getAddress];
         //
         //        NSString* name=[NSString stringWithFormat:@"%@ %@",[addressDic objectForKey:ADDRESS_FISRT_NAME],[addressDic objectForKey:ADDRESS_LAST_NAME]];
         //        NSString* state=[NSString stringWithFormat:@"%@, %@",[addressDic objectForKey:ADDRESS_STATE],[addressDic objectForKey:ADDRESS_COUNTRY]];
         //
         //        PayPalShippingAddress*shippingAddress=
         //        [PayPalShippingAddress shippingAddressWithRecipientName:name
         //                                                      withLine1:[addressDic objectForKey:ADDRESS_LINE1]
         //                                                      withLine2:@""
         //                                                       withCity:[addressDic objectForKey:ADDRESS_CITY]
         //                                                      withState:state
         //                                                 withPostalCode:[addressDic objectForKey:ADDRESS_PIN_CODE]
         //                                                withCountryCode:@"91"];
         
         */
        
        NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:amount];
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = total;//amount;
        payment.currencyCode = CURRENCY_TYPE;
        payment.shortDescription = SHORT_DESCRIPTION;
        payment.items = @[item1];  // if not including multiple items, then leave payment.items as nil
        payment.paymentDetails = nil; // if not including payment details, then leave payment.paymentDetails as nil
        
        payment.shippingAddress= nil; // if not including payment shippingAddress, then leave payment.shippingAddress as nil
        
        if (!payment.processable) {
                // This particular payment will always be processable. If, for
                // example, the amount was negative or the shortDescription was
                // empty, this payment wouldn't be processable, and you'd want
                // to handle that here.
        }
        
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc]
                                                              initWithPayment:payment
                                                              configuration:self.payPalConfig
                                                              delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];
        //amount=nil;
        payment=nil;
        // paymentDetails=nil;
        // shippingAddress=nil;
        //        item1=nil;
        //amountString=nil;
}








@end
