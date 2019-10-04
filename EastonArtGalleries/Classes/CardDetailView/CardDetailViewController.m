//
//  CardDetailViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 29/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "CardDetailViewController.h"
#import "CartViewCell1.h"
#import "CartViewCell2.h"
#import "CartViewCell3.h"
#import "CartViewCell4.h"
#import "AddAddressViewController.h"

#define COLOR_CELL_BACKGROUND           @"#DEDEDD"
#define COLOR_CELL_TEXT                 @"#575656"
#define COLOR_CELL_CONTENT_BORRDER      @"#CBC9C9"
#define COLOR_CELL_TEXT_PLACEHOLDER     @"#8E8E8E"
#define COLOR_CELL_HEADER               @"#3C3A3A"
#define COLOR_BOTTOM_VIEW               @"#2E6D00"



#define CURRENCY_TYPE           @"USD"
#define SHORT_DESCRIPTION       @"Credit Money"
#define ADDRESS_FISRT_NAME      @"firstname"
#define ADDRESS_LAST_NAME       @"lastname"
#define ADDRESS_EMAIL           @"email"
#define ADDRESS_PHONE           @"phonenumber"
#define ADDRESS_CITY            @"city"
#define ADDRESS_STATE           @"county_or_State"
#define ADDRESS_COUNTRY         @"country"
#define ADDRESS_LINE1           @"address1"
#define ADDRESS_LINE2           @"address2"
#define ADDRESS_PIN_CODE        @"postcode"
#define ADDRESS_PRODUCTS_ID     @"pid"
#define ADDRESS_PRODUCTS_QUANTITY       @"quantity"
#define ADDRESS_PRODUCTS_ORDER_ID       @"orderid"


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
#define PAYPAL_TRANSACTION_METHOD               @"transaction_method"

@interface CardDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UITextViewDelegate,
PayPalPaymentDelegate,
PayPalFuturePaymentDelegate,
PayPalProfileSharingDelegate>
{
        NSMutableArray *data;
        NSMutableArray *arrReview;
        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        BOOL isReview;
        NSArray* arrResultPaypalItems;
        NSString* orderID;
        NSMutableDictionary *dicCheckoutData;
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;





@end

@implementation CardDetailViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";


#pragma mark - View controller life cycle


- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self loadCartData];
        
        //[self removeAddress];
        
        [self setEditLabel];
    
        [self config];
        
        
        [self configPayPal];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        dicCheckoutData = [NSMutableDictionary dictionary];
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        [self loadCardCount];
        
        [self loadTable];
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

-(void)config{
        

        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        self.view.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        
        [Alert setShadowOnViewAtTop:self.viContainerEdit];
        [Alert setShadowOnViewAtTop:self.viContainerContinue];
        [Alert setShadowOnViewAtTop:self.lblSeparatorVirticalLine];
        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
#endif
        
        
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

-(void)cellRegister {
        
        [self.tableView registerClass:[CartViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[CartViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[CartViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[CartViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"CartViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];

        UINib *contantsCellNib2 = [UINib nibWithNibName:@"CartViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];

        UINib *contantsCellNib3 = [UINib nibWithNibName:@"CartViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"CartViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        
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
        [self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
}

-(void)removeActivityIndicator {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

-(void)setBackgroundLabel {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        NSString* msg=isReview ? @"Item not available at this time" : @"Your cart is empty !";
        
        messageLabel.text = msg;
        messageLabel.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:18];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)removeBackgroundLabel {
        
        self.tableView.backgroundView = nil;
}

-(void)rightNavBarConfiguration{
        
        //Search icon
        UIImageView*searchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        searchImageView.image=[UIImage imageNamed:@"search_icon.png"];
        
        UIButton*searchButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        searchButton.frame = CGRectMake(0, 0, 30, 30);
        searchButton.layer.cornerRadius=searchButton.frame.size.width/2;
        [searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* searchView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
        searchView.backgroundColor=[UIColor clearColor];
        [searchView addSubview:searchImageView];
        [searchView addSubview:searchButton];
        
        //User icon
        
        UIImageView* userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        userImageView.image=[UIImage imageNamed:@"user_icon.png"];
        
        
        UIButton * userButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        userButton.frame = CGRectMake(0, 0, 30, 30);
        userButton.layer.cornerRadius=userButton.frame.size.width/2;
        [userButton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* userView=[[UIView alloc]initWithFrame:CGRectMake(30, 5, 30, 30)];
        userView.backgroundColor=[UIColor clearColor];
        [userView addSubview:userImageView];
        [userView addSubview:userButton];
        
        //Card icon
        UIImageView* cardImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        cardImageView.image=[UIImage imageNamed:@"cart_icon.png"];
        
        
        UIButton * cardButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        cardButton.frame = CGRectMake(0, 0, 30, 30);
        cardButton.layer.cornerRadius=cardButton.frame.size.width/2;
        [cardButton addTarget:self action:@selector(card:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* cardView=[[UIView alloc]initWithFrame:CGRectMake(60, 5, 30, 30)];
        cardView.backgroundColor=[UIColor clearColor];
        [cardView addSubview:cardImageView];
        [cardView addSubview:cardButton];
        [cardView insertSubview:cardImageView atIndex:0];
        [cardView insertSubview:cardButton atIndex:2];
        
        cardViewGlobal=cardView;
        
        
        //Card icon
        UIImageView* dotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 6, 3, 20)];
        dotImageView.image=[UIImage imageNamed:@"dotted_menu_icon.png"];
        
        
        UIButton * dotButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        dotButton.frame = CGRectMake(0, 0, 30, 30);
        dotButton.layer.cornerRadius=cardButton.frame.size.width/2;
        [dotButton addTarget:self action:@selector(dot:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* dotView=[[UIView alloc]initWithFrame:CGRectMake(90, 5, 30, 30)];
        dotView.backgroundColor=[UIColor clearColor];
        [dotView addSubview:dotImageView];
        [dotView addSubview:dotButton];
        
        
        
        UIView* rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        rightView.backgroundColor=[UIColor clearColor];
        
        [rightView addSubview:searchView];
        [rightView addSubview:userView];
        [rightView addSubview:cardView];
        [rightView addSubview:dotView];
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        [rightView alignmentRectInsets];
        
        
        //        UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        //
        //        UIBarButtonItem *sortBarItem = [[UIBarButtonItem alloc] initWithCustomView:sortButton];
        
        
        self.navigationItem.rightBarButtonItem = rightBarItem;//@[closeBarItem,sortBarItem];
}

-(NSInteger)getCardCount{
        
        NSArray* arrCard=[dataManager getCardDetails];
        
        return  arrCard ? arrCard.count : 0;
}

-(void)loadCardCount{
        
        [self removeCardCount];
        
        NSInteger count=[self getCardCount];
        
        UIView* cardCountView=[[UIView alloc]initWithFrame:CGRectMake(cardViewGlobal.frame.size.width-17,
                                                                      2,
                                                                      15,
                                                                      15)];
        UILabel* lblcount=[[UILabel alloc]initWithFrame:cardCountView.bounds];
        lblcount.text = [NSString stringWithFormat:@"%lu",(long)count];
        lblcount.textColor = [UIColor whiteColor];
        lblcount.backgroundColor = [UIColor clearColor];
        lblcount.numberOfLines = 0;
        lblcount.textAlignment = NSTextAlignmentCenter;
        lblcount.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_MEDIUM size:9];
        
        [cardCountView addSubview:lblcount];
        
        cardCountView.backgroundColor=[UIColor redColor];
        cardCountView.layer.cornerRadius=cardCountView.frame.size.width/2;
        cardCountView.layer.borderWidth=1.5;
        cardCountView.layer.borderColor=[UIColor whiteColor].CGColor;
        cardCountView.layer.masksToBounds=YES;
        cardCountView.hidden=count ? NO: YES;
        cardCountViewGlobal=cardCountView;
        [cardViewGlobal addSubview:cardCountView];
        [cardViewGlobal insertSubview:cardCountView atIndex:1];
        
        
}

-(void)removeCardCount {
        
        for (id view in cardViewGlobal.subviews) {
                
                if(![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UIButton class]] )
                        [view removeFromSuperview];
        }
}

-(void)loadCartData {
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        data = [[dataManager getCardDetails] mutableCopy];
        data = [[Alert getSortedList:data key:@"SORT" ascending:YES] mutableCopy];
        
        for (CardDetailModel* cart in data) {
                cart.TOTAL_SUM=[cart.ART_SIZE intValue];
        }
        
        
        if(data.count){
                self.viContainerEdit.hidden=self.viContainerContinue.hidden=self.lblSeparatorVirticalLine.hidden=NO;
                [self removeBackgroundLabel];
                
        }
        else{
                self.viContainerEdit.hidden=self.viContainerContinue.hidden=self.lblSeparatorVirticalLine.hidden=YES;
                [self setBackgroundLabel];
        }

}

-(void)loadTable{
        
        self.lblContinue.text=isReview ? @"PLACE ORDER" : @"CHECKOUT";
        
        [UIView transitionWithView:self.tableView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
         
                        animations:nil
                        completion:nil];
        
        
        
        [self.tableView reloadData];
}

-(void)removeAllCartItemsFromDatabase{
        
        NSString* IDs=[[[self getAllCartItemIDsWithList:arrResultPaypalItems] valueForKey:@"ID"] componentsJoinedByString:@","];
        [dataManager executeQuery:[NSString stringWithFormat:@"delete from CardDetail where id IN (%@)",IDs]];
        
        [data removeObjectsInArray:[self getAllCartItemIDsWithList:arrResultPaypalItems]];
        
        
        NSLog(@"Cart Removed successfully");
        
}

-(void)setEditLabel {
        
        NSArray* arr = isReview ? arrReview : data;
        
        /*
         NSNumber* sum = [arr valueForKeyPath: @"@sum.TOTAL_SUM"];
         NSString* formatedPrice = [Alert getFormatedNumber:[sum stringValue]];
         self.lblEdit.text = isReview ? @"EDIT" :[@"$" stringByAppendingString:formatedPrice];
         
         self.btnEdit.enabled = isReview? YES : NO;
        */
        
#warning Set 7% of Taxes there
       
        float totalPrice;//=[card.PRICE longLongValue]*card.QUANTITY;
        CardDetailModel* card;
        for (int i = 0; i< arr.count; i++) {
                
                card = [isReview ? arrReview : data objectAtIndex:i];
//                card.QUANTITY = isReview ? card.QUANTITY : 1;

                NSLog(@"%d", card.QUANTITY);
                NSLog(@"%lld", [card.PRICE longLongValue] * card.QUANTITY);
                totalPrice = totalPrice + [card.PRICE longLongValue] * card.QUANTITY;
        }
        
        totalPrice = totalPrice > 0 ? totalPrice + totalPrice * 7 /100 : 0;
        
        NSString* formatedPrice=[Alert getFormatedNumber:[@(totalPrice)stringValue]];
        self.lblEdit.text = isReview ? @"EDIT" :[@"$" stringByAppendingString:formatedPrice];

        
//        card.TOTAL_SUM =(card.isValidateCheck && card.QUANTITY<=card.STOCK)|| (!card.isValidateCheck) ? (int)totalPrice : 0;
//        
//        
//        NSNumber* sum = [arr valueForKeyPath: @"@sum.TOTAL_SUM"];
//        float sumWithTaxes = [sum floatValue];
//        sumWithTaxes = sumWithTaxes > 0 ? sumWithTaxes + sumWithTaxes * 7 /100 : 0;
//        NSString* formatedPrice = [NSString stringWithFormat:@"%.2f", sumWithTaxes];
//        self.lblEdit.text = isReview ? @"EDIT" :[@"$" stringByAppendingString:formatedPrice];
        
        self.btnEdit.enabled = isReview? YES : NO;
       
        
        
}

-(NSArray *)validateOrderList:(NSArray*)orderList{
        
        for (CardDetailModel* cart in data) {
                
                cart.isValidateCheck=YES;
//                cart.isValiate=[self matchOrderWithArray:orderList ID:(int)cart.ID quantity:(int)cart.QUANTITY].count ? YES : NO;
                NSArray* arr=[self matchOrderWithArray:orderList ID:(int)cart.ID];
                NSDictionary* dic=arr.count ? arr[0]: nil;
                
                if(dic){
                        cart.STOCK=[[dic objectForKey:@"quantity"] intValue];
                }
                
        }
       
        
        return data;
}

-(void)removeValidateOrderList{
        
        
        for (CardDetailModel* cart in data) {
                
                cart.isValidateCheck=NO;
                cart.STOCK=0;
                
                
        }
}

-(NSDictionary*)getAddress{
        
        NSDictionary* dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
        return dic ? dic : nil;
}

-(void)removeAddress {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"address"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray*)matchOrderWithArray:(NSArray*)list ID:(int)ID quantity:(int)quantity{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id.intValue == %d AND quantity.intValue>=%d", ID ,quantity];
        NSArray *matchingObjs = [list filteredArrayUsingPredicate:predicate];
        
        if ([matchingObjs count] == 0)
        {
                //NSLog(@"No match");
                return nil;
        }
        else
        {
                //NSLog(@"Matched");
                return matchingObjs;
        }
}

-(NSArray*)matchOrderWithArray:(NSArray*)list ID:(int)ID{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id.intValue == %d", ID ];
        NSArray *matchingObjs = [list filteredArrayUsingPredicate:predicate];
        
        if ([matchingObjs count] == 0)
        {
                //NSLog(@"No match");
                return nil;
        }
        else
        {
                //NSLog(@"Matched");
                return matchingObjs;
        }
}

-(NSArray*)matchNameWithArray:(NSArray*)list name:(NSString*)name{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ART_NAME == %@ ", name];
        NSArray *matchingObjs = [list filteredArrayUsingPredicate:predicate];
        
        if ([matchingObjs count] == 0)
        {
                //NSLog(@"No match");
                return nil;
        }
        else
        {
                //NSLog(@"Matched");
                return matchingObjs;
        }
}

-(NSArray*)getAllCartItemIDsWithList:(NSArray*)list{
        
        NSMutableArray* result=[[NSMutableArray alloc]init];
        
        for (PayPalItem* item in list) {
                
                NSArray* arr=[self matchNameWithArray:arrReview name:item.name];
                
                CardDetailModel* cart=arr.count ? arr[0] : nil;
                if(arr.count)
                   [result addObject:cart];
        }
        
        return result.count ? result : nil;
}

#pragma mark -Get Action from right nav buttons

-(IBAction)search:(id)sender{
        
        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        [dic setObject:@"artist" forKey:@"page"];
        
        BestSellingArtistsViewController* vc=GET_VIEW_CONTROLLER(kBestSellingArtistsViewController);
        vc.urlString=urlString;
        vc.urlData=[dic mutableCopy];
        vc.dataAccesskey=@"Artist";
        vc.titleString=@"Search Your Favorite Artist";
        vc.isSearchArtist=YES;
        vc.from=@"back";
        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
        
}

-(IBAction)user:(id)sender{
        
        if([[EAGallery sharedClass]isLogin]){
                if([self.navigationController.visibleViewController isKindOfClass:[DashboardViewController class]]) return;
                
                DashboardViewController*vc=GET_VIEW_CONTROLLER(kDashboardViewController);
                vc.titleString=@"Dashboard";
                
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                
        }
        else{
                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                
                LoginViewController*vc=GET_VIEW_CONTROLLER(kLoginViewController);
                vc.titleString=@"Login";
                
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
        }
        
}

-(IBAction)card:(id)sender{
        
        
        if([self.navigationController.visibleViewController isKindOfClass:[CardDetailViewController class]]) return;        
        
        CardDetailViewController*vc=GET_VIEW_CONTROLLER(kCardDetailViewController);
        vc.titleString=@"Your Cart";
        vc.from=@"back";
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
}

-(IBAction)dot:(id)sender{
        
        UIButton* button=(UIButton*)sender;
        
        [[EAGallery sharedClass]popover:button vc:self];
        
}

-(UIImage*)setNavBarImage{
        
        UIImage* result;
        UIImage* image=[Alert imageFromColor:[UIColor blackColor]];
        
        
        if (IS_IPHONE_4){
                
                
                CGRect rect = CGRectMake(0,0,320,44);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        else{
                CGRect rect = CGRectMake(0,0,320,88);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        
        return result;
        
}

#pragma Mark Navigation Bar Configuration Code

-(void)navigationBarConfiguration{
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setBackgroundImage:[self setNavBarImage]
                                                      forBarMetrics:UIBarMetricsDefault];
        UIButton * menuButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        menuButton.frame = CGRectMake(8, 20, 24, 18);
        [menuButton setBackgroundImage:[UIImage imageNamed:MENU_IMAGE] forState:UIControlStateNormal];
        
        //    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *accountBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        self.navigationItem.leftBarButtonItem = accountBarItem;
        //[self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


#pragma mark - Validate Order List WebService -

-(void)validateOrderListWebService:(NSDictionary*)dic {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ValidateOrderList);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                NSLog(@" tempURL :%@---",urlString);
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:postString
                                                                       urlString:urlString
                                                                      methodType:@"POST"
                                                                          images:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES second:3.0];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
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
                                
                                if (success.boolValue) {
                                        NSArray*resPonsedata = (NSArray*)[result valueForKey:@"data"];
                                        

                                        arrReview=[[self validateOrderList:[resPonsedata mutableCopy]] mutableCopy];
                                        

                                        isReview=YES;
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                //                                                if(!arrReview.count)    [self setBackgroundLabel];
                                                //                                                else                    [self removeBackgroundLabel];
                                                //
                                                //                                                 [self loadTable];
                                                //
                                                //                                                [self setEditLabel];
                                                
                                                

                                                
                                                
                                                NSMutableDictionary* addDic=[[self getAddress] mutableCopy];
                                                

                                                NSArray* products=[arrReview valueForKeyPath:@"ID"];
                                                NSArray* quantity=[self getProductIDsFromCartItems:data];
                                                
                                                [addDic setObject:[products mutableCopy]                forKey:ADDRESS_PRODUCTS_ID];
                                                [addDic setObject:[quantity mutableCopy]                forKey:ADDRESS_PRODUCTS_QUANTITY];
                                                [addDic setObject:[[EAGallery sharedClass] memberID]    forKey:@"memberid"];
                                                
                                                isReview=NO;
                                                
                                                [self checkoutOrderWebService:[addDic mutableCopy]];
                                                
                                                
                                                
                                                
                                                
                                        });
                                        
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        
                                }
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

#pragma mark -Check WebService

-(void)checkoutOrderWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Checkout);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                NSLog(@" tempURL :%@---",urlString);
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:postString
                                                                       urlString:urlString
                                                                      methodType:@"POST"
                                                                          images:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES second:3.0];
                                
                        });
                        
                        
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
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
                                orderID  = [result valueForKey:ADDRESS_PRODUCTS_ORDER_ID];
                                
                                if (success.boolValue) {
                                       

                                        isReview=YES;
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                if(!arrReview.count)    [self setBackgroundLabel];
                                                else                    [self removeBackgroundLabel];
                                                
                                                [self loadTable];
                                                
                                                [self setEditLabel];
                                                
                                        });
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        
                                }
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

#pragma mark - Payment for order list WebService -

-(void)paymentOrderListWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_PaymentForOrder);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                NSLog(@" tempURL :%@---",urlString);
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:postString
                                                                       urlString:urlString
                                                                      methodType:@"POST"
                                                                          images:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES second:3.0];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
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
                                
                                if (success.boolValue) {
                                        
                                        
                                        [self removeAllCartItemsFromDatabase];
                                        
                                        //[self removeAddress];
                                        
                                        [self removeValidateOrderList];
                                        
//                                        arrReview=data=nil;
                                        
                                        isReview=NO;
                                        arrResultPaypalItems=nil;
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                if(!data.count){
                                                        self.viContainerEdit.hidden=self.viContainerContinue.hidden=self.lblSeparatorVirticalLine.hidden=YES;
                                                        
                                                        [self setBackgroundLabel];
                                                }
                                                
                                                [self loadCardCount];
                                                
                                                [self setEditLabel];
                                                
                                                [self loadTable];
                                                
                                                [Alert alertWithMessage:@"Thank you for your order for more details check your email."
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:5.0];
                                                
                                                
                                        });
                                        
                                        //Write code here for Move to order list to show status of puchased items
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        
                                }
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        
        switch (section) {
                case 0:
                        rows=isReview ? arrReview.count : data.count;
                        break;
                case 1:
                        rows=(isReview ? arrReview.count : data.count) ? 1  : 0;
                        break;
                        
                case 2:
                        rows=(isReview ? arrReview.count : data.count) ? 1 :0;
                        break;
                default:
                        break;
        }
        
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        float finalHeight=0.0f;
        
        switch (indexPath.section) {
                case 0:
                        finalHeight=167.0f;
                        break;
                case 1:
                        {
                                
                                NSDictionary* dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
                                if(dic==nil) finalHeight=55.0f;
                                else{
                                        
                                        float defaultHeight=21.0f,y=8.0f,bottom=52.0f;
                                        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.tableView.frame.size.width-16, 20)];
                                        label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:11];
                                        
                                        NSString* address=[NSString stringWithFormat:@"%@\n%@-%@\n\n%@",[dic objectForKey:ADDRESS_LINE1],[dic objectForKey:ADDRESS_CITY],[dic objectForKey:ADDRESS_PIN_CODE],[dic objectForKey:ADDRESS_PHONE]];
                                        
                                        label.text=address;
                                        label.numberOfLines=4;
                                        label.textAlignment=NSTextAlignmentLeft;
                                        label.backgroundColor=[UIColor clearColor];
                                        float height=[Alert getLabelHeight:label];
                                        
                                        finalHeight=MAX(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                }

                        }

                        break;
                case 2:
                        finalHeight = 170.0f;
                        break;
                default:
                        break;
        }
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        //        NSDictionary* data = [self.arrArtCategoryList objectAtIndex:indexPath.row];
        
        if(indexPath.section==0) {
                
                CartViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                CardDetailModel* card=[isReview ? arrReview : data objectAtIndex:indexPath.row];
                
                
                
                if(isReview) {
                        
                        cell.lblMessage.hidden=NO;
                        cell.viContainerRemove.hidden=YES;
                        
                        
                        cell.lblMessage.textColor=card.QUANTITY<=card.STOCK ? [Alert colorFromHexString:COLOR_BOTTOM_VIEW] : [UIColor redColor] ;
                        
                        //                        if(card.STOCK<1)
                        //                                @"Out of stock";
                        //                        else if(card.QUANTITY<card.STOCK)
                        //                                @"Available";
                        //                        else    [NSString stringWithFormat:@"Only %lu items are left in stock",card.STOCK];
                        cell.lblMessage.text = card.STOCK<1 ? @"Out of stock" : (card.QUANTITY<=card.STOCK ? @"Available" : [NSString stringWithFormat:@"Only %d items are left in stock",card.STOCK]);
                        
                        if(card.QUANTITY>card.STOCK)
                                card.QUANTITY = card.QUANTITY-1;
                        
                        
                }
                else{
                        cell.lblMessage.hidden=YES;
                        cell.viContainerRemove.hidden=NO;
                }
                
                
                
                
                NSURL* url=[NSURL URLWithString:card.ART_URL];
                
                for (id view in cell.contentView.subviews) {
                        
                        if([view isKindOfClass:[UIActivityIndicatorView class]])
                                [view removeFromSuperview];
                }
                
                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator1.frame = CGRectMake(cell.imgPic.frame.size.width/2-15,
                                                      cell.imgPic.frame.size.height/2-15,
                                                      30,
                                                      30);
                [activityIndicator1 startAnimating];
                activityIndicator1.tag=indexPath.row;
                
                [activityIndicator1 removeFromSuperview];
                [cell.contentView addSubview:activityIndicator1];
                [cell.contentView insertSubview:activityIndicator1 aboveSubview:cell.imgPic];
                
                
                cell.imgPic.backgroundColor=[UIColor whiteColor];
                
                UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
                
                __weak UIImageView *weakImgPic = cell.imgPic;
                [cell.imgPic setImageWithURL:url
                            placeholderImage:imgPlaceHolder
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                 {
                         [activityIndicator1 stopAnimating];
                         [activityIndicator1 removeFromSuperview];
                         
                         UIImageView *strongImgPic = weakImgPic;
                         if (!strongImgPic) return;
                         
                         [UIView transitionWithView:strongImgPic
                                           duration:0.3
                                            options:UIViewAnimationOptionTransitionCrossDissolve
                          
                                         animations:^{
                                                  strongImgPic.image=image;
                                                 
                                         }
                                         completion:NULL];
                         
                 } failure:NULL];
                
                cell.backgroundColor=[UIColor clearColor];
                cell.contentView.backgroundColor=[UIColor clearColor];
                card.QUANTITY = isReview ? card.QUANTITY : 1;
                long totalPrice=[card.PRICE longLongValue]*card.QUANTITY;
                NSString* formatedPrice=[Alert getFormatedNumber:[@(totalPrice)stringValue]];
                
                
                cell.lblName.text=card.ART_NAME;
                cell.lblSize.text=card.ART_SIZE;
                cell.lblType.text=[NSString stringWithFormat:@"%@ By %@",card.ART_CATEGORY,card.ARTIST_NAME];
                cell.lblPrice.text=[@"$" stringByAppendingString:formatedPrice];
                cell.lblQuantity.text=[NSString stringWithFormat:@"%d",card.QUANTITY];
                
                cell.btnRemove.tag=
                cell.btnMinus.tag=
                cell.btnPlus.tag = indexPath.row;
                [cell.btnMinus addTarget:self action:@selector(minusQuantity:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnPlus addTarget:self action:@selector(plusQuantity:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnRemove addTarget:self action:@selector(removeCart:) forControlEvents:UIControlEventTouchUpInside];
                card.TOTAL_SUM =(card.isValidateCheck && card.QUANTITY<=card.STOCK)|| (!card.isValidateCheck) ? (int)totalPrice : 0;
                
                NSDictionary * linkAttributes = @{
                                                  NSForegroundColorAttributeName:cell.btnRemove.titleLabel.textColor,
                                                  NSFontAttributeName           :[UIFont fontWithName:FONT_DOSIS_REGULAR size:10.0f],
                                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                                  };
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.btnRemove.titleLabel.text attributes:linkAttributes];
                [cell.btnRemove.titleLabel setAttributedText:attributedString];
                
                /*
                if(isReview){
                        cell.lblMessage.hidden=NO;
                        cell.viContainerRemove.hidden=YES;
                        
                        
                        cell.lblMessage.textColor=card.QUANTITY<=card.STOCK ? [Alert colorFromHexString:COLOR_BOTTOM_VIEW] : [UIColor redColor] ;
                        
//                        if(card.STOCK<1)
//                                @"Out of stock";
//                        else if(card.QUANTITY<card.STOCK)
//                                @"Available";
//                        else    [NSString stringWithFormat:@"Only %lu items are left in stock",card.STOCK];
                        cell.lblMessage.text=card.STOCK<1 ? @"Out of stock" : (card.QUANTITY<=card.STOCK ? @"Available" : [NSString stringWithFormat:@"Only %d items are left in stock",card.STOCK]);
                        
                        
                        // Chandra Code
                        
                      
                }
                else{
                        cell.lblMessage.hidden=YES;
                        cell.viContainerRemove.hidden=NO;
                }
                */
                
                return cell;
        }
        else if(indexPath.section==1) {
                
                NSDictionary* dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
                if(dic==nil) {
                        
                        CartViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.btnAddAddress.tag=indexPath.row;
                        [cell.btnAddAddress addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
                        
                        NSDictionary * linkAttributes = @{
                                                          NSForegroundColorAttributeName:cell.btnAddAddress.titleLabel.textColor,
                                                          NSFontAttributeName           :[UIFont fontWithName:FONT_DOSIS_LIGHT size:10.0f],
                                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                                          };
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.btnAddAddress.titleLabel.text attributes:linkAttributes];
                        [cell.btnAddAddress.titleLabel setAttributedText:attributedString];
                        

                        
                        
                        return cell;
                        
                }
                else {
                        CartViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.viContainerCell.translatesAutoresizingMaskIntoConstraints=
                        cell.lblDesc.translatesAutoresizingMaskIntoConstraints=
                        cell.viContainerEdit.translatesAutoresizingMaskIntoConstraints=YES;
                        
//                        cell.viContainerCell.backgroundColor=[UIColor darkGrayColor];
//                        cell.lblDesc.backgroundColor=[UIColor yellowColor];
//                        cell.viContainerEdit.backgroundColor=[UIColor greenColor];
                        
                        NSString* address=[NSString stringWithFormat:@"%@\n%@-%@\n\n%@",[dic objectForKey:ADDRESS_LINE1],[dic objectForKey:ADDRESS_CITY],[dic objectForKey:ADDRESS_PIN_CODE],[dic objectForKey:ADDRESS_PHONE]];
                        
                        cell.lblDesc.text=address;
                        cell.lblDesc.numberOfLines=4;
                        
                        
                        
                        float height=[Alert getLabelHeight:cell.lblDesc];
                        
                        float defaultHeight=21;
                        
                        float finalHeight=MAX(height, defaultHeight);
                        
                        //llbDesc
                        CGRect descFrame=cell.lblDesc.frame;
                        descFrame.size.height=finalHeight;
                        cell.lblDesc.frame=descFrame;
                        
                        //viContainerEdit
                        CGRect editFrame=cell.viContainerEdit.frame;
                        editFrame.origin.y=descFrame.origin.y+descFrame.size.height+8;
                        cell.viContainerEdit.frame=editFrame;
                        
                        //viContainerCell
                        CGRect cellFrame=cell.viContainerCell.frame;
                        cellFrame.size.height=editFrame.origin.y+editFrame.size.height;
                        cell.viContainerCell.frame=cellFrame;
                        
                        
                        
                        cell.btnEdit.tag=indexPath.row;
                        [cell.btnEdit addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
                        
                        NSDictionary * linkAttributes = @{
                                                          NSForegroundColorAttributeName:cell.btnEdit.titleLabel.textColor,
                                                          NSFontAttributeName           :[UIFont fontWithName:FONT_DOSIS_LIGHT size:09.0f],
                                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                                          };
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.btnEdit.titleLabel.text attributes:linkAttributes];
                        [cell.btnEdit.titleLabel setAttributedText:attributedString];
                        
                        
                        return cell;
                        
                }
        }
        else if(indexPath.section==2) {
                
                CartViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray* arr = isReview ? arrReview : data;
                
                unsigned long sumPrice = 0;
                
                for (CardDetailModel *obj in arr) {
                        
                        sumPrice = sumPrice + [obj.PRICE longLongValue]*obj.QUANTITY;
                }
                NSLog(@"%ld", sumPrice);
                
                //                NSString* formatedPrice = [Alert getFormatedNumber:[sum stringValue]];
                //                cell.lblTotalPrice.text=[@"$" stringByAppendingString:formatedPrice];
                //
                //                // Add 7 % taxes on new label
                //
                //                float sumWithTaxes = [sum floatValue];
                //                sumWithTaxes = sumWithTaxes > 0 ? sumWithTaxes + sumWithTaxes * 7 /100 : 0;
                //                NSString* strPriceWithAllTaxes = [NSString stringWithFormat:@"%.2f", sumWithTaxes];
                //                cell.lblPriceWithAllTaxes.text = [@"$" stringByAppendingString:strPriceWithAllTaxes];
                
                
                NSString* formatedPrice = [NSString stringWithFormat:@"%ld", sumPrice];
                
                cell.lblTotalPrice.text=[@"$" stringByAppendingString:formatedPrice];
                
                float sumWithTaxes = (float) sumPrice;
                sumWithTaxes = sumWithTaxes > 0 ? sumWithTaxes + sumWithTaxes * 7 /100 : 0;
                NSString* strPriceWithAllTaxes = [NSString stringWithFormat:@"%.2f", sumWithTaxes];
                cell.lblPriceWithAllTaxes.text = [@"$" stringByAppendingString:strPriceWithAllTaxes];
                
                [self setEditLabel];
                
                
                return cell;
        }
        
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        //        NSDictionary *sectionData = [arrHeaderTitle objectAtIndex:section];
        NSString *header = @"";
        
        switch (section) {
                        
                case 0:
                        header= @"";
                        break;
                case 1:
                        {
                                NSDictionary* dic=[self getAddress];
                                NSString* name=[NSString stringWithFormat:@"Shipped to %@ %@",[dic objectForKey:ADDRESS_FISRT_NAME],[dic objectForKey:ADDRESS_LAST_NAME]];
                                header= (dic!=nil) ? name : @"";
                        }
                        break;
                case 2:
                        header= @"";
                        break;
                        
                default:
                        break;
        }
        return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        //Header View
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
//        headerView.backgroundColor=[UIColor clearColor];
        
        //Header Title
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(8, 16, tableView.frame.size.width-16, 20);
        myLabel.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:15];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textAlignment=NSTextAlignmentCenter;
        myLabel.textColor=[Alert colorFromHexString:COLOR_CELL_HEADER];
        myLabel.backgroundColor=[UIColor clearColor];
        [headerView addSubview:myLabel];
        
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        NSInteger height=0;
        switch (section) {
                case 0:
                        height= 0;
                        break;
                case 1:
                        {
                                height= ([self getAddress]!=nil && (isReview ? arrReview.count : data.count)) ? 36.0f :0;
                        }
                        break;
                case 2:
                        height= 0;
                        break;
                        
                default:
                        break;
        }
        
        
        return height;
}


#pragma mark PayPal Payment gateway

-(void)updateAmountFromPayPalToServer{
        
        self.transactionDetails=nil;
        
        //    [self resetTransactionDetail];
        [[SharedClass sharedObject] hudeHide];
        
        BOOL tran = [[NSUserDefaults standardUserDefaults] boolForKey:isTRANSACTION];
        
        if( tran)
        {
                self.transactionDetails=[[NSUserDefaults standardUserDefaults] objectForKey:TRANSACTION_DETAIL];
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
                
                //NSDictionary* addressDic=[self getAddress];
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                NSArray* quantity=[self getProductIDsFromPaypalItems:arrResultPaypalItems];
                
                [dic setObject:orderID  forKey:@"order_id"];
                [dic setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_ID]
                        forKey:PAYPAL_TRANSACTION_ID];
                [dic setObject:quantity forKey:ADDRESS_PRODUCTS_QUANTITY];
                
                [self paymentOrderListWebService:[dic mutableCopy]];
                
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
                PayPalShippingAddress*shippingAddress=completedPayment.shippingAddress;
                
                NSString* address=[NSString stringWithFormat:@"%@, \n%@",shippingAddress.line1,shippingAddress.line2];
                
                
                NSDictionary* paymentDescription=[completedPayment.confirmation mutableCopy];
                
                NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
                [mutDictTransactionDetails setObject:[[EAGallery sharedClass] memberID]
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
                
                [mutDictTransactionDetails setObject:[Alert getFirstName:shippingAddress.recipientName]
                                              forKey:PAYPAL_TRANSACTION_BILLING_FIRST_NAME];
                
                [mutDictTransactionDetails setObject:[Alert getLastName:shippingAddress.recipientName]
                                              forKey:PAYPAL_TRANSACTION_BILLING_LAST_NAME];
                
                [mutDictTransactionDetails setObject:address
                                              forKey:PAYPAL_TRANSACTION_BILLING_ADDRESS];
                
                [mutDictTransactionDetails setObject:shippingAddress.city
                                              forKey:PAYPAL_TRANSACTION_BILLING_CITY];
                
                [mutDictTransactionDetails setObject:shippingAddress.state
                                              forKey:PAYPAL_TRANSACTION_BILLING_STATE];
                
                [mutDictTransactionDetails setObject:shippingAddress.postalCode
                                              forKey:PAYPAL_TRANSACTION_BILLING_POST_CODE];
                
                [mutDictTransactionDetails setObject:shippingAddress.state
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
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isTRANSACTION ];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutDictTransactionDetails  forKey:TRANSACTION_DETAIL];
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
        [self setPayPalEnvironment:kPayPalEnvironment];
//        self.environment = kPayPalEnvironment;
        
//        [PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
        
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

#pragma mark PayPalProfileSharingDelegate methods

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

-(NSArray*)getPayPalItemsFromCartItems:(NSArray*)arrCartItem{
        
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        
        for (CardDetailModel* card in arrCartItem) {
                
        
                PayPalItem *item = [PayPalItem itemWithName:card.ART_NAME
                                                withQuantity:card.QUANTITY
                                                   withPrice:[NSDecimalNumber decimalNumberWithString:card.PRICE]
                                                withCurrency:CURRENCY_TYPE
                                                     withSku:[NSString stringWithFormat:@"EastonArtGalleries-%d",card.ID]];
                
                if(card.QUANTITY<=card.STOCK)
                        [arrResult addObject:item];
        }
        
        return arrResult.count ? arrResult : nil;
}

-(NSArray*)getProductIDsFromPaypalItems:(NSArray*)items{
        
        
        NSMutableArray* result=[[NSMutableArray alloc]init];
        
        for (PayPalItem* item in items) {
                
                NSArray* arr=[self matchNameWithArray:arrReview name:item.name];
                
                CardDetailModel* cart=arr.count ? arr[0] : nil;
                if(cart){
                        
                        for (int i=0; i<item.quantity; i++) {
                                
                                [result addObject:[NSNumber numberWithInt:cart.ID]];
                        }
                }
                
        }
        
        return result.count ? result :  nil;
}


-(NSArray*)getProductIDsFromCartItems:(NSArray*)items{
        
        
        NSMutableArray* result=[[NSMutableArray alloc]init];
        
        for (CardDetailModel* cart in items) {
                
                for (int i=0; i<cart.QUANTITY; i++) {
                        
                        [result addObject:[NSNumber numberWithInt:cart.ID]];
                }
        }
        
        return result.count ? result :  nil;
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
        
        // Optional: include multiple items
        /*
        PayPalItem *item1 = [PayPalItem itemWithName:@"Talk2Good Money"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:amountString]
                                        withCurrency:@"USD"
                                             withSku:@"Talk2Good-Sku"];
        
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
        NSArray *items =[[self getPayPalItemsFromCartItems:[data mutableCopy]] mutableCopy];
        
        arrResultPaypalItems=items;
         
         // Optional: include payment details
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
//        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
        
        // Calculate 7% Taxes
        float taxes = [subtotal floatValue];
        taxes = subtotal > 0 ?  [subtotal floatValue] * 7 /100 : 0;
        NSString* strPriceWithAllTaxes = [NSString stringWithFormat:@"%.2f", taxes];
        
        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:strPriceWithAllTaxes];

        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                                   withShipping:shipping
                                                                                        withTax:tax];
        
        //Total price of all cart items
         NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        
        
        //Optional : include shipping address
        NSDictionary* addressDic = [self getAddress];
        
        NSString* name=[NSString stringWithFormat:@"%@ %@",[addressDic objectForKey:ADDRESS_FISRT_NAME],[addressDic objectForKey:ADDRESS_LAST_NAME]];
        NSString* state=[NSString stringWithFormat:@"%@, %@",[addressDic objectForKey:ADDRESS_STATE],[addressDic objectForKey:ADDRESS_COUNTRY]];
        
        PayPalShippingAddress*shippingAddress=
        [PayPalShippingAddress shippingAddressWithRecipientName:name
                                                      withLine1:[addressDic objectForKey:ADDRESS_LINE1]
                                                      withLine2:@""
                                                       withCity:[addressDic objectForKey:ADDRESS_CITY]
                                                      withState:state
                                                 withPostalCode:[addressDic objectForKey:ADDRESS_PIN_CODE]
                                                withCountryCode:@"91"];
        
        
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = total;//amount;
        payment.currencyCode = CURRENCY_TYPE;
        payment.shortDescription = SHORT_DESCRIPTION;
        payment.items = items;  // if not including multiple items, then leave payment.items as nil
        payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
        
        payment.shippingAddress= shippingAddress; // if not including payment shippingAddress, then leave payment.shippingAddress as nil
        
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
        paymentDetails=nil;
        shippingAddress=nil;
//        item1=nil;
        //amountString=nil;
}



#pragma mark - Target Methods

-(IBAction)minusQuantity:(UIButton*)sender{
        
        CardDetailModel* cart = [isReview ? arrReview : data objectAtIndex:sender.tag];
        [Alert performBlockWithInterval:0.1 completion:^{
                if(cart.QUANTITY > 1){
                        cart.QUANTITY -= 1;
//                        [data replaceObjectAtIndex:sender.tag withObject:cart];
//                        [self.tableView beginUpdates];
//                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0],[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
//                        [self.tableView endUpdates];
                        
                        NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                        
                        [dic setObject:[isReview ? arrReview : data valueForKeyPath:@"ID"] forKey:@"id"];
                        
                        [self validateOrderListWebService:dic];
                        
              //          [self setEditLabel];
                }
                
                
        }];
        
}

-(IBAction)plusQuantity:(UIButton*)sender {
        
        CardDetailModel * cart = [isReview ? arrReview : data objectAtIndex:sender.tag];
        [Alert performBlockWithInterval:0.1 completion:^{
        
                cart.QUANTITY += 1;
//                [self.tableView beginUpdates];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0],[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
//                [self.tableView endUpdates];
                
                
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                
                [dic setObject:[isReview ? arrReview : data valueForKeyPath:@"ID"] forKey:@"id"];
                [self validateOrderListWebService:dic];
                
                
            //    [self setEditLabel];
//                 [self.tableView reloadData];
        }];
}

-(IBAction)removeCart:(UIButton*)sender {
        
        CardDetailModel* card=[data objectAtIndex:sender.tag];
        
        [dataManager executeQuery:[NSString stringWithFormat:@"delete from CardDetail where id=%d",card.ID]];
        
        [self loadCardCount];
        
        [data removeObjectAtIndex:sender.tag];
        
        [Alert alertWithMessage:[NSString stringWithFormat:@"Successfully removed %@ from your cart",card.ART_NAME]
                     navigation:self.navigationController
                       gotoBack:NO animation:YES second:2.0];
        
        if(!data.count)
        
        [UIView transitionWithView:self.viContainerContinue
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
         
                        animations:nil
                        completion:^(BOOL finished){
                                
                                self.viContainerEdit.hidden=self.viContainerContinue.hidden=self.lblSeparatorVirticalLine.hidden=YES;
                                [self setBackgroundLabel];
                                [self.tableView reloadData];
                                
                        }];
        
        
        else{
                self.viContainerEdit.hidden=self.viContainerContinue.hidden=self.lblSeparatorVirticalLine.hidden=NO;
                [self removeBackgroundLabel];
                [UIView transitionWithView:self.tableView
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:^(BOOL finished){
                                        
                                        [self.tableView reloadData];
                                        
                                        
                                }];

        }
        
        [Alert performBlockWithInterval:0.05 completion:^{
                
                [[EAGallery sharedClass] flipView:cardCountViewGlobal];
        }];
        
}

-(IBAction)addAddress:(UIButton*)sender{
        
        
        NSDictionary* dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
        
        
        AddAddressViewController* vc=GET_VIEW_CONTROLLER(kAddAddressViewController);
        vc.titleString=@"Add New Address";
        vc.from=@"back";
        vc.address=(dic!=nil) ? dic : nil;
//        vc.arrProducts=[isReview ? arrReview : data valueForKeyPath:@"ID"];
//        vc.arrQuantity=[self getProductIDsFromCartItems:isReview ? arrReview : data];
        
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);


}


#pragma mark - Action Methods

- (IBAction)edit:(id)sender {
        
        [self removeValidateOrderList];
        
        isReview = NO;
        arrReview=nil;
        orderID=nil;
        self.lblContinue.text=@"CHECKOUT";
        
        [self loadTable];
        
        [self setEditLabel];
        
        
        
}


-(IBAction)placeOrder:(id)sender {
        
      
        
        if(![[EAGallery sharedClass]isLogin]){
                
                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                
                LoginViewController*vc=GET_VIEW_CONTROLLER(kLoginViewController);
                vc.titleString=@"Login";
                
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                
                return;
        }
        
        if(![self getAddress]){
                
                [Alert alertWithMessage:@"Please first add shipping address !"
                             navigation:self.navigationController gotoBack:NO animation:YES second:2.0];
        }
        else if(!isReview && !orderID){
//                [self openPayPalView];
                
                NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                
                [dic setObject:[data valueForKeyPath:@"ID"] forKey:@"id"];
                
                [self validateOrderListWebService:dic];
        }
        else{
                
                NSNumber* sum = [arrReview valueForKeyPath: @"@sum.TOTAL_SUM"];
                
                if([sum intValue]>0)
                        [self openPayPalView];
//                        [self removeAllCartItemsFromDatabase];
                else{
                        
                        [Alert alertWithMessage:@"Please add another item into cart !"
                                     navigation:self.navigationController gotoBack:NO animation:YES second:2.0];
                }
        }
        
        
}


-(void)openPayPalForPayment {

        if(![[EAGallery sharedClass]isLogin]) {
                
                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                
                LoginViewController*vc=GET_VIEW_CONTROLLER(kLoginViewController);
                vc.titleString=@"Login";
                
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                
                return;
        }
        
        if(![self getAddress]) {
                
                [Alert alertWithMessage:@"Please first add shipping address !"
                             navigation:self.navigationController gotoBack:NO animation:YES second:2.0];
        }
        else if(!isReview && !orderID) {
                
                NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                
                [dic setObject:[data valueForKeyPath:@"ID"] forKey:@"id"];
                
                [self validateOrderListWebService:dic];
        }
        else {
                
                NSNumber* sum = [arrReview valueForKeyPath: @"@sum.TOTAL_SUM"];
                
                if([sum intValue]>0)
                        [self openPayPalView];
                //                        [self removeAllCartItemsFromDatabase];
                else{
                        
                        [Alert alertWithMessage:@"Please add another item into cart !"
                                     navigation:self.navigationController gotoBack:NO animation:YES second:2.0];
                }
        }
}

@end
