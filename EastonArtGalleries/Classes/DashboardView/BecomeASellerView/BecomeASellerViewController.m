//
//  BecomeASellerViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "BecomeASellerViewController.h"
#import "BecomeASellerViewCell1.h"
#import "BecomeASellerViewCell2.h"
#import "BecomeASellerViewCell3.h"
#import "BecomeASellerViewCell4.h"
#import "BecomeASellerViewCell5.h"
#import "BecomeASellerViewCell6.h"
#import "UpdateProfileViewCell4.h"
#import "BecomeASellerViewCell7.h"

#import "TermsOfUseBecomeAsellerVC.h"
#import "BecomeAsellerPaymentVC.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"

#define ENTER_PHONE_TEXT                @"* Phone"
#define ENTER_PASSWORD_TEXT             @"* Password"
#define ENTER_CONFIRM_PASSWORD_TEXT     @"* Confirm Password"

#define ENTER_NAME_TEXT         @"* Name"
#define ENTER_EMAIL_TEXT        @"* Email"
#define SELECT_OPTION           @"* Select"
#define WEBSITE_TEXT            @"http://www.example.com"
#define FACEBOOK_PAGE_TEXT      @"http://www.facebook.com/pages/fan_page"




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
#define PAYPAL_TRANSACTION_METHOD               @"transaction_method"



@interface BecomeASellerViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
PickerViewDelegate,
UITextViewDelegate,
TTTAttributedLabelDelegate,
PayPalPaymentDelegate,
PayPalFuturePaymentDelegate,
PayPalProfileSharingDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSMutableArray* arrData;
        NSString* baseURL;
        NSMutableArray* arrHeaderTitle;
        NSMutableArray* arrHearAbout;
        NSArray* arrCountryList;
        NSMutableArray* arrSellingCurrency;
        BOOL isUpdateHeight;
        
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        NSString* selectedCountry;
        id countrySender;
        UIButton* applyButton;
        
        NSDictionary* dicResult;
        
        
        NSMutableDictionary *dicRequestParam;
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;



@end

@implementation BecomeASellerViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";
static NSString *CellIdentifier5 = @"Cell5";
static NSString *CellIdentifier6 = @"Cell6";
static NSString *CellIdentifier7 = @"Cell7";
static NSString *CellIdentifier8 = @"Cell8";


#pragma mark - View controller life cicle


- (void)viewDidLoad {
        
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self setLogoImage];
        
        [self loadData];
        
        [self countryList];
        
        //   [self config];
        
        [self configPayPal];
        
        [self rightNavBarConfiguration];
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
        
        
}

-(void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        [self config];
        
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - THSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
        return self.viewTitle ? self.viewTitle : self.title;
}

#pragma mark - Custom Methods

-(void)config {
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.translatesAutoresizingMaskIntoConstraints=YES;
        
        float height=0;
        
        if([self.from isEqualToString:@"popup"])
                height=self.view.frame.size.height;
        else
                height=self.view.frame.size.height-64-50;
        
        self.tableView.frame=CGRectMake(self.tableView.frame.origin.x,
                                        self.tableView.frame.origin.y,
                                        self.tableView.frame.size.width,
                                        height);
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        //        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        
}

-(void)loadData {
        
        //Header
        {
                arrHeaderTitle=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle addObject:@"ACCOUNT DETAILS"];
                [arrHeaderTitle addObject:@"ARTIST DETAILS"];
                [arrHeaderTitle addObject:@"SHIPPING AND CURRENCY"];
                [arrHeaderTitle addObject:@"ARTIST PRESENCE"];
                [arrHeaderTitle addObject:@""];
                [arrHeaderTitle addObject:@""];
                
        }
        
        //init data
        {
                arrData = [[NSMutableArray alloc]init];
                for (int i=0; i<15; i++) {
                        
                        NSString* value=@"";
                        NSString* text=@"";
                        NSString* msg=@"";
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        switch (i) {
                                        
                                {
                                        
                                case 0:
                                        text=@"Name";
                                        value=@"";
                                        msg=ENTER_NAME_TEXT;
                                        break;
                                case 1:
                                        text=@"Email";
                                        value=@"";
                                        msg=ENTER_EMAIL_TEXT;
                                        break;
                                        
                                case 2:
                                        text=@"Phone";
                                        value=@"";
                                        msg=ENTER_PHONE_TEXT;
                                        break;
                                case 3:
                                        text=@"Password";
                                        value=@"";
                                        msg=ENTER_PASSWORD_TEXT;
                                        break;
                                        
                                case 4:
                                        text=@"Confirm Password";
                                        value=@"";
                                        msg=ENTER_CONFIRM_PASSWORD_TEXT;
                                        break;
                                case 5:
                                        text=@"Are you represented by a gallery?";
                                        value=@"0" ;
                                        break;
                                case 6:
                                        text=@"Where did you hear about Eastonartgalleries?";
                                        value=@"";
                                        msg=SELECT_OPTION ;
                                        break;
                                case 7:
                                        text=@"Artworks shipping from";
                                        value=@"";
                                        msg=SELECT_OPTION ;
                                        break;
                                case 8:
                                        text=@"Selling in Currency";
                                        value=@"";
                                        msg=SELECT_OPTION;
                                        break;
                                case 9:
                                        text=@"Have you sold online before?";
                                        value=@"0" ;
                                        break;
                                case 10:
                                        text=@"Website address";
                                        value=@"";
                                        msg=WEBSITE_TEXT;
                                        break;
                                case 11:
                                        text=@"Facebook fan page";
                                        value=@"";
                                        msg=FACEBOOK_PAGE_TEXT ;
                                        break;
                                case 12:
                                        text=@"Twitter account name";
                                        value=@"" ;
                                        break;
                                        
                                case 13:
                                        text=@"Let us know what drives you to create art, and why you want to sell it on Eastonartgalleries";
                                        value=@"" ;
                                        break;
                                case 14:
                                        text=@"I Agree To Terms of Service ";
                                        value=@"0" ;
                                        break;
                                default:
                                        text=@"";
                                        value=@"";
                                        break;
                                }
                                        
                                        /*
                                         case 0:
                                         text=@"Name";
                                         value=@"";
                                         msg=ENTER_NAME_TEXT;
                                         break;
                                         case 1:
                                         text=@"Email";
                                         value=@"";
                                         msg=ENTER_EMAIL_TEXT;
                                         break;
                                         
                                         case 2:
                                         text=@"Phone";
                                         value=@"";
                                         msg=ENTER_PHONE_TEXT;
                                         break;
                                         case 3:
                                         text=@"Password";
                                         value=@"";
                                         msg=ENTER_PASSWORD_TEXT;
                                         break;
                                         
                                         case 4:
                                         text=@"Confirm Password";
                                         value=@"";
                                         msg=ENTER_CONFIRM_PASSWORD_TEXT;
                                         break;
                                         case 5:
                                         text=@"Are you selling original, signed artworks?";
                                         value=@"0";
                                         break;
                                         
                                         case 6:
                                         text=@"Are you selling hand-made signed and numbered limited edition artworks?";
                                         value=@"0";
                                         break;
                                         case 7:
                                         text=@"Are you selling signed and numbered limited edition photography or digitally created artworks?";
                                         value=@"0";
                                         break;
                                         
                                         case 8:
                                         text=@"Are you represented by a gallery?";
                                         value=@"0" ;
                                         break;
                                         case 9:
                                         text=@"Where did you hear about Eastonartgalleries?";
                                         value=@"";
                                         msg=SELECT_OPTION ;
                                         break;
                                         case 10:
                                         text=@"Artworks shipping from";
                                         value=@"";
                                         msg=SELECT_OPTION ;
                                         break;
                                         case 11:
                                         text=@"Selling in Currency";
                                         value=@"";
                                         msg=SELECT_OPTION;
                                         break;
                                         case 12:
                                         text=@"Have you sold online before?";
                                         value=@"0" ;
                                         break;
                                         case 13:
                                         text=@"Website address";
                                         value=@"";
                                         msg=WEBSITE_TEXT;
                                         break;
                                         case 14:
                                         text=@"Facebook fan page";
                                         value=@"";
                                         msg=FACEBOOK_PAGE_TEXT ;
                                         break;
                                         case 15:
                                         text=@"Twitter account name";
                                         value=@"" ;
                                         break;
                                         case 16:
                                         text=@"Plan";
                                         value=@"1" ;
                                         break;
                                         case 17:
                                         text=@"Plan Amount $300";
                                         value=@"" ;
                                         msg=@"Enter coupon code";
                                         break;
                                         case 18:
                                         text=@"Let us know what drives you to create art, and why you want to sell it on Eastonartgalleries";
                                         value=@"" ;
                                         break;
                                         default:
                                         text=@"";
                                         value=@"";
                                         break;
                                         */
                                        
                        }
                        
                        [dic setObject:value forKey:@"value"];
                        [dic setObject:text forKey:@"text"];
                        [dic setObject:msg forKey:@"msg"];
                        
                        [arrData addObject:dic];
                }
                
        }
        
        //Hear about
        {
                arrHearAbout=[[NSMutableArray alloc]init];
                
                [arrHearAbout addObject:@"Facebook"];
                [arrHearAbout addObject:@"Magazine article"];
                [arrHearAbout addObject:@"Newspaper story"];
                [arrHearAbout addObject:@"Search engine"];
                [arrHearAbout addObject:@"Twitter"];
                [arrHearAbout addObject:@"Word of mouth"];
                [arrHearAbout addObject:@"Other"];
        }
        //Selling in currency
        {
                arrSellingCurrency=[[NSMutableArray alloc]init];
                
                [arrSellingCurrency addObject:@"GBP £"];
                [arrSellingCurrency addObject:@"USD $"];
                [arrSellingCurrency addObject:@"EUR €"];
                
                
        }
        
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
        
        [self.tableView registerClass:[BecomeASellerViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[BecomeASellerViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[BecomeASellerViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[BecomeASellerViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        [self.tableView registerClass:[BecomeASellerViewCell5 class] forCellReuseIdentifier:CellIdentifier6];
        [self.tableView registerClass:[BecomeASellerViewCell6 class] forCellReuseIdentifier:CellIdentifier7];
        [self.tableView registerClass:[BecomeASellerViewCell7 class] forCellReuseIdentifier:CellIdentifier8];
        [self.tableView registerClass:[UpdateProfileViewCell4 class] forCellReuseIdentifier:CellIdentifier5];
        
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"BecomeASellerViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib2= [UINib nibWithNibName:@"BecomeASellerViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"BecomeASellerViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"BecomeASellerViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        
        
        UINib *contantsCellNib6 = [UINib nibWithNibName:@"BecomeASellerViewCell5" bundle:nil];
        [self.tableView registerNib:contantsCellNib6 forCellReuseIdentifier:CellIdentifier6];
        
        UINib *contantsCellNib7 = [UINib nibWithNibName:@"BecomeASellerViewCell6" bundle:nil];
        [self.tableView registerNib:contantsCellNib7 forCellReuseIdentifier:CellIdentifier7];
        
        UINib *contantsCellNib8 = [UINib nibWithNibName:@"BecomeASellerViewCell7" bundle:nil];
        [self.tableView registerNib:contantsCellNib8 forCellReuseIdentifier:CellIdentifier8];
        
        UINib *contantsCellNib5 = [UINib nibWithNibName:@"UpdateProfileViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib5 forCellReuseIdentifier:CellIdentifier5];
        
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

-(void)removeActivityIndicator {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

-(void)setBackgroundLabel {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data found";
        messageLabel.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
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

-(void)rightNavBarConfiguration {
        
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

-(void)createDatePicker:(BOOL)isList items:(NSArray*)list sender:(id)sender{
        
        cDatePicker=[[CustomDatePickerViewController alloc]initWithNibName:kCustomDatePickerViewController bundle:nil];
        
        cDatePicker.delegate=self;
        cDatePicker.isCustomList=isList;
        cDatePicker.arrItems= isList ? list :nil;
        cDatePicker.sender=sender;
        
        [cDatePicker setPickerList];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        
        fullScreen=[[UIView alloc]initWithFrame:screenRect];
        fullScreen.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [fullScreen addSubview:cDatePicker.view];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:fullScreen];
        
        //    [self.view addSubview:cDatePicker.view];
}

-(void)removeDatePicker{
        [fullScreen removeFromSuperview];
        [cDatePicker.view removeFromSuperview];
        fullScreen=nil;
        cDatePicker=nil;
        
        
}

-(void)countryList {
        
        //    arrCountryList=[[NSArray alloc]init];
        
        NSDictionary* country=[Alert getCountryFromServerData];
        if(country) {
                
                arrCountryList=[[country allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        
        
}


-(UIImage*)setNavBarImage {
        
        UIImage* result;
        UIImage* image=[Alert imageFromColor:[UIColor blackColor]];
        
        
        if (IS_IPHONE_4) {
                
                
                CGRect rect = CGRectMake(0,0,320,44);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        else {
                CGRect rect = CGRectMake(0,0,320,88);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        
        return result;
        
}
#pragma mark - Navigation Bar Configuration Code

-(void)navigationBarConfiguration {
        
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

#pragma mark - DatePicker Custom Delegate methods

-(void)selectDateFromDatePicker:(NSDate *)date sender:(id)sender{
        
        NSLog(@"Selected Date->%@",date);
        selectedDate=date;
        //        lblAge.text=[NSString stringWithFormat:@"+%d",[Alert calculateAge:date]];
        
        
        //        txtDOB.text=[Alert getDateWithString:[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date]
        //                                   getFormat:GET_FORMAT_TYPE
        //                                   setFormat:SET_FORMAT_TYPE1];
        
        
        
        [self removeDatePicker];
        
        //[txtCountry becomeFirstResponder];
}

-(void)cancelDateFromDatePicker:(id)sender{
        
        [self removeDatePicker];
        // [txtCountry becomeFirstResponder];
}

#pragma mark - Custom List Item Picker Delegate Methods

-(void)selectItemFromList:(NSString *)item sender:(id)sender{
        
        NSLog(@"Selected item->%@",item);
        UIButton* button=(UIButton*)sender;
        selectedCountry=item;
        
        [self removeDatePicker];
        
        
        
        NSLog(@"Country Key->[%@]",[Alert getSelectedCountryKeyWithValue:selectedCountry]);
        NSLog(@"Country Value->[%@]",[Alert getSelectedCountryValueWithKey:[Alert getSelectedCountryKeyWithValue:selectedCountry]]);
        
        
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        
        switch (indexPath.section) {
                case 1:
                {
                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag+row];
                        
                        [dic setObject:selectedCountry forKey:@"value"];
                }
                        break;
                case 2:
                {
                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag+row+row1];
                        
                        [dic setObject:selectedCountry forKey:@"value"];
                        
                }
                        break;
                        
                default:
                        break;
        }
        
        
        countrySender=nil;
        
        
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
}

-(void)cancelItemFromCustomList:(id)sender {
        
        [self removeDatePicker];
        countrySender=nil;
}

#pragma mark - Call WebService -

-(void)submitWebService:(NSDictionary*)dic{
        
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
                                                [self loadData];
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


-(void)getCountryListWebService {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_CountryList);
                //                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                NSLog(@" tempURL :%@---",urlString);
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:nil
                                                                       urlString:urlString
                                                                      methodType:@"GET"
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
                        countrySender=nil;
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
                                
                                countrySender=nil;
                        }
                        else
                        {
                                
                                //NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        NSDictionary*resPonsedata = (NSDictionary*)[result valueForKey:@"data"];
                                        
                                        [[NSUserDefaults standardUserDefaults]setObject:[resPonsedata objectForKey:COUNTRY_LIST] forKey:COUNTRY_LIST];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        [self countryList];
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                if(arrCountryList.count)
                                                        [self createDatePicker:YES items:arrCountryList sender:countrySender];
                                                
                                        });
                                        
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        countrySender=nil;
                                        
                                }
                                else{
                                        countrySender=nil;
                                }
                                
                                
                        }
                        
                }
                
        });
        
}


-(void)checkEmailExistanceInDataBaseWebService:(NSString  *)strEmail {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl,kURL_CHECK_EMAIL_EXISTANCE);

                NSMutableDictionary *dicParam = [[NSMutableDictionary alloc]init];
                [dicParam setObject:strEmail forKey:@"email"];
                
                NSString *postString =[Alert jsonStringWithDictionary:[dicParam mutableCopy]];
                
                
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
//
//                                dispatch_async(dispatch_get_main_queue(), ^{
                                
//                                });
                                
                                if (success.boolValue) {
                                        
                                        //  Go For Payment
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                BecomeAsellerPaymentVC* vc = GET_VIEW_CONTROLLER(kBecomeAsellerPaymentVC);
                                                vc.titleString = @"Order Details";
                                                vc.from = @"back";
                                                vc.fromVC = kBecomeAsellerPaymentVC;
                                                vc.dicParam = [dicRequestParam mutableCopy];
                                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                                                NSLog(@"Go to Payment screen");
                                                                                });
                                       
                                        
                                }
                                else if (!success.boolValue) {
                                        
                                        [Alert alertWithMessage:[result valueForKey:@"message"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:3.0];

                                }
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
        return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        NSInteger rows = 0;
        
        
        switch (section) {
                        
                case 0:
                        rows=[[EAGallery sharedClass] roleType]==NormalUser ? 5 : 0;
                        break;
                case 1:
                        rows=[[EAGallery sharedClass] roleType]==NormalUser ? 2 : 0;
                        break;
                case 2:
                        //                        rows=[[EAGallery sharedClass] roleType]==NormalUser ? 7 : 0;
                        rows=[[EAGallery sharedClass] roleType]==NormalUser ? 2 : 0;
                        
                        break;
                        
                case 3:
                        //         rows=[[EAGallery sharedClass] roleType]==NormalUser ? 1 : 0;
                        rows=[[EAGallery sharedClass] roleType]==NormalUser ? 6 : 0;
                        
                        break;
                case 4:
                        rows=[[EAGallery sharedClass] roleType]==BecomeAnArtistPending ? 0 : 1;
                        break;
                case 5:
                        rows=[[EAGallery sharedClass] roleType]==BecomeAnArtistPending ? 1 : 0;
                        break;
                        
                default:
                        break;
        }
        
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        float finalHeight = 0.0f;
        
        switch (indexPath.section) {
                        
                case 0:
                        switch (indexPath.row) {
                                case 0:
                                        finalHeight=44.0f;
                                        break;
                                case 1:
                                        finalHeight=44.0f;
                                        break;
                                case 2:
                                        finalHeight=[[EAGallery sharedClass] isLogin] ? 0 : 44.0f;
                                        break;
                                case 3:
                                        finalHeight=[[EAGallery sharedClass] isLogin] ? 0 : 44.0f;
                                        break;
                                case 4:
                                        finalHeight=[[EAGallery sharedClass] isLogin] ? 0 : 44.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                        break;
                case 1:
                        switch (indexPath.row) {
                                case 0: {
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        
                                        float defaultHeight=34.0f,
                                        y=8.0f,
                                        bottom=51.0f;
                                        
                                        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                        label.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        
                                        label.text = text;
                                        label.textAlignment = NSTextAlignmentLeft;
                                        label.backgroundColor = [UIColor yellowColor];
                                        float height=[Alert getLabelHeight:label];
                                        
                                        finalHeight=MIN(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                        
                                }
                                        break;
                                case 1: {
                                        
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        
                                        float defaultHeight=34.0f,
                                        y=8.0f,
                                        bottom=46.0f;
                                        
                                        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                        label.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        
                                        label.text = text;
                                        label.textAlignment=NSTextAlignmentLeft;
                                        label.backgroundColor=[UIColor yellowColor];
                                        float height=[Alert getLabelHeight:label];
                                        
                                        finalHeight=MIN(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                        
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (indexPath.row) {
                                case 0:
                                case 1:
                                {
                                        NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1 = [self tableView:self.tableView numberOfRowsInSection:1];
                                        NSDictionary* dic = [arrData objectAtIndex:indexPath.row+row+row1];
                                        
                                        NSString* text = [dic objectForKey:@"text"];
                                        
                                        float defaultHeight=34.0f,y=8.0f,bottom = 46.0f;
                                        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                        label.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:13];
                                        
                                        label.text = text;
                                        label.textAlignment = NSTextAlignmentLeft;
                                        label.backgroundColor=[UIColor yellowColor];
                                        float height = [Alert getLabelHeight:label];
                                        
                                        finalHeight = MIN(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                        
                                }
                                        break;
                                        
                                        /*
                                         case 2:
                                         {
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         
                                         float defaultHeight=34.0f,y=8.0f,bottom=51.0f;
                                         UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                         label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                         
                                         label.text=text;
                                         label.textAlignment=NSTextAlignmentLeft;
                                         label.backgroundColor=[UIColor yellowColor];
                                         float height=[Alert getLabelHeight:label];
                                         
                                         finalHeight=MIN(height, defaultHeight);
                                         
                                         finalHeight+=y+bottom;
                                         
                                         }
                                         break;
                                         
                                         case 3:
                                         case 4:
                                         case 5:
                                         finalHeight=44.0f;
                                         break;
                                         case 6:
                                         {
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         
                                         float defaultHeight=34.0f,y=8.0f,bottom=51.0f;
                                         UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                         label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                         
                                         label.text=text;
                                         label.textAlignment=NSTextAlignmentLeft;
                                         label.backgroundColor=[UIColor yellowColor];
                                         float height=[Alert getLabelHeight:label];
                                         
                                         finalHeight=MIN(height, defaultHeight);
                                         
                                         finalHeight+=y+bottom;
                                         
                                         }
                                         break;
                                         case 7:{
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         NSDictionary* dicLast=[arrData objectAtIndex:indexPath.row+row+row1-1];
                                         NSString* valueLast=[dicLast objectForKey:@"value"];
                                         if(valueLast.intValue==1){
                                         finalHeight=37.0f;
                                         }
                                         else if (valueLast.intValue==2){
                                         
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         finalHeight=[dic objectForKey:@"amount"] ? 147.0f: 103.0f;
                                         }
                                         
                                         }
                                         break;
                                         case 8:
                                         {
                                         
                                         //  Text View
                                         //   Let us know what drives ......
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         
                                         float defaultHeight=34.0f,y=8.0f,bottom=118.0f;
                                         UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                         label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                         
                                         label.text=text;
                                         label.textAlignment=NSTextAlignmentLeft;
                                         label.backgroundColor=[UIColor yellowColor];
                                         float height=[Alert getLabelHeight:label];
                                         
                                         finalHeight=MIN(height, defaultHeight);
                                         
                                         finalHeight+=y+bottom;
                                         
                                         }
                                         break;
                                         */
                                default:
                                        break;
                        }
                        break;
                        // Section 3 New Added
                case 3:
                        
                        switch (indexPath.row) {
                                        
                                case 0: {
                                        
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        
                                        float defaultHeight=34.0f,y=8.0f,bottom=51.0f;
                                        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                        label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                        
                                        label.text=text;
                                        label.textAlignment=NSTextAlignmentLeft;
                                        label.backgroundColor=[UIColor yellowColor];
                                        float height=[Alert getLabelHeight:label];
                                        
                                        finalHeight=MIN(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                }
                                        break;
                                case 1:
                                case 2:
                                case 3:
                                        
                                        return finalHeight = 44.0f;
                                        
                                        break;
                                        
                                case 4: {
                                        //  Text View
                                        //   Let us know what drives ......
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        
                                        float defaultHeight=34.0f,y=8.0f,bottom=118.0f;
                                        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                        label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                        
                                        label.text=text;
                                        label.textAlignment=NSTextAlignmentLeft;
                                        label.backgroundColor=[UIColor yellowColor];
                                        float height=[Alert getLabelHeight:label];
                                        
                                        finalHeight=MIN(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                        
                                        
                                        
                                        finalHeight = 160.0;
                                }
                                        
                                        break;
                                        
                                case 5: {
                                        
                                        // Terms Of Use
                                        return finalHeight = 70.0;
                                        
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 4:
                        
                        finalHeight = 40.0f;
                        
                        break;
                        
                case 5:
                        
                        finalHeight = 145.0f;
                        
                        break;
                        
                default:
                        break;
                        
                        
                        
                        //                case 3:
                        //                        finalHeight=40.0f;
                        //                        break;
                        //
                        //                case 4:
                        //                        finalHeight=143.0f;
                        //                        break;
                        //                default:
                        //                        break;
        }
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        switch (indexPath.section) {
                        
                case 0:
                {
                        
                        BecomeASellerViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        //                                CGRect contentFrame=cell.contentView.frame;
                        CGRect valueFrame=cell.viContainerValue.frame;
                        CGRect titleFrame=cell.lblTitle.frame;
                        CGRect textFieldFrame=cell.txtField.frame;
                        if(indexPath.row==2 | indexPath.row==3 || indexPath.row==4){
                                
                                
                                if([[EAGallery sharedClass] isLogin] && indexPath.section==0){
                                        //                                                cell.contentView.translatesAutoresizingMaskIntoConstraints=YES;
                                        cell.viContainerValue.translatesAutoresizingMaskIntoConstraints=YES;
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=YES;
                                        cell.txtField.translatesAutoresizingMaskIntoConstraints=YES;
                                        //                                                contentFrame.size.height=
                                        valueFrame.size.height=
                                        titleFrame.size.height=
                                        textFieldFrame.size.height=0;
                                }
                                
                        }
                        //                                cell.contentView.frame=contentFrame;
                        cell.viContainerValue.frame=valueFrame;
                        cell.lblTitle.frame=titleFrame;
                        cell.txtField.frame=textFieldFrame;
                        
                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row];
                        
                        NSString* text=[dic objectForKey:@"text"];
                        NSString* value=[dic objectForKey:@"value"];
                        NSString* msg=[dic objectForKey:@"msg"];
                        
                        
                        //                                        cell.contentView.backgroundColor=[UIColor yellowColor];
                        //Title
                        cell.lblTitle.text=text;
                        
                        cell.txtField.text=value;
                        
                        cell.txtField.tag=indexPath.row;
                        
                        cell.txtField.delegate=self;
                        
                        cell.txtField.autocapitalizationType =(indexPath.row==3) ? UITextAutocapitalizationTypeWords : UITextAutocapitalizationTypeNone;
                        [Alert attributedString:cell.txtField
                                            msg:msg
                                          color:cell.txtField.textColor];
                        cell.txtField.autocorrectionType=UITextAutocorrectionTypeNo;
                        [cell.txtField addTarget:self
                                          action:@selector(textFieldDidChange:)
                                forControlEvents:UIControlEventEditingChanged];
                        cell.txtField.tintColor=[UIColor blackColor];
                        
                        
                        cell.txtField.secureTextEntry=(indexPath.row==3 || indexPath.row==4) ? YES : NO;
                        //Add ' * '
                        NSString* readMore=@" *";
                        text=[text stringByAppendingString:readMore];
                        cell.lblTitle.text=text;
                        
                        cell.lblTitle.delegate=self;
                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                        
                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                        [cell.lblTitle addLinkToURL:url withRange:r];
                        
                        return cell;
                        
                        
                }
                        
                        break;
                case 1:
                        switch (indexPath.row) {
                                        
                                        // Are You repreented by gallery...
                                case 0: {
                                        BecomeASellerViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
                                        
                                        //                                        cell.contentView.hidden = indexPath.row == 3 ? NO:YES;
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        
                                        cell.lblName.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerOption.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        //                                        cell.lblName.backgroundColor=[UIColor yellowColor];
                                        //                                        cell.viContainerOption.backgroundColor=[UIColor greenColor];
                                        //Name
                                        cell.lblName.text=text;
                                        
                                        float height=[Alert getLabelHeight:cell.lblName];
                                        
                                        float defaultHeight=34;
                                        
                                        float finalHeight=MIN(height, defaultHeight);
                                        
                                        CGRect nameFrame=cell.lblName.frame;
                                        nameFrame.size.height=finalHeight;
                                        cell.lblName.frame=nameFrame;
                                        
                                        
                                        //Option
                                        CGRect optionFrame=cell.viContainerOption.frame;
                                        optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                        cell.viContainerOption.frame=optionFrame;
                                        
                                        //Image
                                        
                                        cell.imgYes.image=[UIImage imageNamed:(value.intValue==1) ? SELECT_RADIO: UNSELECT_RADIO];
                                        cell.imgNo.image=[UIImage imageNamed:(value.intValue==2) ? SELECT_RADIO: UNSELECT_RADIO];
                                        
                                        cell.lblYes.text=@"Yes";
                                        cell.lblNo.text=@"No";
                                        
                                        //Buttons
                                        cell.btnYes.tag=indexPath.row+row;
                                        cell.btnNo.tag=indexPath.row+row;
                                        
                                        [cell.btnYes addTarget:self action:@selector(optionOne:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnNo addTarget:self action:@selector(optionTwo:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        
                                        //Add ' * '
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblName.text=text;
                                        
                                        cell.lblName.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblName.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                        NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblName.text rangeOfString:readMore];
                                        [cell.lblName addLinkToURL:url withRange:r];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                        // By Cs Rai Start.....
                                        /*
                                         case 1:
                                         case 2:
                                         case 3:
                                         {
                                         BecomeASellerViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
                                         
                                         cell.contentView.hidden = indexPath.row == 3 ? NO:YES;
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         NSString* value=[dic objectForKey:@"value"];
                                         
                                         cell.lblName.translatesAutoresizingMaskIntoConstraints=
                                         cell.viContainerOption.translatesAutoresizingMaskIntoConstraints=YES;
                                         
                                         //                                        cell.lblName.backgroundColor=[UIColor yellowColor];
                                         //                                        cell.viContainerOption.backgroundColor=[UIColor greenColor];
                                         //Name
                                         cell.lblName.text=text;
                                         
                                         float height=[Alert getLabelHeight:cell.lblName];
                                         
                                         float defaultHeight=34;
                                         
                                         float finalHeight=MIN(height, defaultHeight);
                                         
                                         CGRect nameFrame=cell.lblName.frame;
                                         nameFrame.size.height=finalHeight;
                                         cell.lblName.frame=nameFrame;
                                         
                                         
                                         //Option
                                         CGRect optionFrame=cell.viContainerOption.frame;
                                         optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                         cell.viContainerOption.frame=optionFrame;
                                         
                                         //Image
                                         
                                         cell.imgYes.image=[UIImage imageNamed:(value.intValue==1) ? SELECT_RADIO: UNSELECT_RADIO];
                                         cell.imgNo.image=[UIImage imageNamed:(value.intValue==2) ? SELECT_RADIO: UNSELECT_RADIO];
                                         
                                         cell.lblYes.text=@"Yes";
                                         cell.lblNo.text=@"No";
                                         
                                         //Buttons
                                         cell.btnYes.tag=indexPath.row+row;
                                         cell.btnNo.tag=indexPath.row+row;
                                         
                                         [cell.btnYes addTarget:self action:@selector(optionOne:) forControlEvents:UIControlEventTouchUpInside];
                                         [cell.btnNo addTarget:self action:@selector(optionTwo:) forControlEvents:UIControlEventTouchUpInside];
                                         
                                         
                                         //Add ' * '
                                         NSString* readMore=@" *";
                                         text=[text stringByAppendingString:readMore];
                                         cell.lblName.text=text;
                                         
                                         cell.lblName.delegate=self;
                                         NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                         cell.lblName.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                         
                                         NSRange r = [cell.lblName.text rangeOfString:readMore];
                                         [cell.lblName addLinkToURL:url withRange:r];
                                         
                                         
                                         return cell;
                                         
                                         }
                                         break;
                                         
                                         */
                                        // By Cs Rai end
                                        /*
                                         case 3:
                                         case 4:
                                         {
                                         BecomeASellerViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         NSString* value=[dic objectForKey:@"value"];
                                         NSString* msg=[dic objectForKey:@"msg"];
                                         
                                         
                                         //                                        cell.contentView.backgroundColor=[UIColor yellowColor];
                                         //Title
                                         cell.lblTitle.text=text;
                                         
                                         cell.txtField.text=value;
                                         
                                         cell.txtField.tag=indexPath.row;
                                         
                                         cell.txtField.delegate=self;
                                         
                                         cell.txtField.autocapitalizationType =(indexPath.row==3) ? UITextAutocapitalizationTypeWords : UITextAutocapitalizationTypeNone;
                                         [Alert attributedString:cell.txtField
                                         msg:msg
                                         color:cell.txtField.textColor];
                                         cell.txtField.autocorrectionType=UITextAutocorrectionTypeNo;
                                         [cell.txtField addTarget:self
                                         action:@selector(textFieldDidChange:)
                                         forControlEvents:UIControlEventEditingChanged];
                                         cell.txtField.tintColor=[UIColor blackColor];
                                         
                                         //Add ' * '
                                         NSString* readMore=@" *";
                                         text=[text stringByAppendingString:readMore];
                                         cell.lblTitle.text=text;
                                         
                                         cell.lblTitle.delegate=self;
                                         NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                         
                                         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                         [cell.lblTitle addLinkToURL:url withRange:r];
                                         
                                         return cell;
                                         
                                         }
                                         break;
                                         */
                                        
                                        
                                        //By Cs rai start .....
                                        
                                        
                                case 1:
                                {
                                        BecomeASellerViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        NSString* msg=[dic objectForKey:@"msg"];
                                        
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerSelection.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        //                                        cell.lblTitle.backgroundColor=[UIColor yellowColor];
                                        //                                        cell.viContainerSelection.backgroundColor=[UIColor greenColor];
                                        //Name
                                        cell.lblTitle.text=text;
                                        
                                        float height=[Alert getLabelHeight:cell.lblTitle];
                                        
                                        float defaultHeight=34;
                                        
                                        float finalHeight=MIN(height, defaultHeight);
                                        
                                        CGRect nameFrame=cell.lblTitle.frame;
                                        nameFrame.size.height=finalHeight;
                                        cell.lblTitle.frame=nameFrame;
                                        
                                        
                                        //Option
                                        CGRect optionFrame=cell.viContainerSelection.frame;
                                        optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                        cell.viContainerSelection.frame=optionFrame;
                                        
                                        //Add Gradient color
                                        [Alert setGradientWithGrayColor:cell.viContainerSelection];
                                        
                                        
                                        //Selection
                                        
                                        cell.lblName.text=IS_EMPTY(value) ? msg : value;
                                        
                                        
                                        //Buttons
                                        cell.btnSelect.tag=indexPath.row;
                                        
                                        [cell.btnSelect addTarget:self action:@selector(selectOpt:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        //Add ' * '
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (indexPath.row) {
                                case 0:
                                case 1:
                                {
                                        BecomeASellerViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        NSString* msg=[dic objectForKey:@"msg"];
                                        
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerSelection.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        //                                        cell.lblTitle.backgroundColor=[UIColor yellowColor];
                                        //                                        cell.viContainerSelection.backgroundColor=[UIColor greenColor];
                                        //Name
                                        cell.lblTitle.text=text;
                                        
                                        float height=[Alert getLabelHeight:cell.lblTitle];
                                        
                                        float defaultHeight=34;
                                        
                                        float finalHeight=MIN(height, defaultHeight);
                                        
                                        CGRect nameFrame=cell.lblTitle.frame;
                                        nameFrame.size.height=finalHeight;
                                        cell.lblTitle.frame=nameFrame;
                                        
                                        
                                        //Option
                                        CGRect optionFrame=cell.viContainerSelection.frame;
                                        optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                        cell.viContainerSelection.frame=optionFrame;
                                        
                                        //Add Gradient color
                                        [Alert setGradientWithGrayColor:cell.viContainerSelection];
                                        
                                        
                                        //Selection
                                        
                                        cell.lblName.text=IS_EMPTY(value) ? msg : value;
                                        
                                        
                                        //Buttons
                                        cell.btnSelect.tag=indexPath.row;
                                        
                                        [cell.btnSelect addTarget:self action:@selector(selectOpt:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        //Add ' * '
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        // Start By Cs Rai......
                                        /*
                                         case 2:
                                         {
                                         BecomeASellerViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         NSString* value=[dic objectForKey:@"value"];
                                         
                                         cell.lblName.translatesAutoresizingMaskIntoConstraints=
                                         cell.viContainerOption.translatesAutoresizingMaskIntoConstraints=YES;
                                         
                                         //                                        cell.lblName.backgroundColor=[UIColor yellowColor];
                                         //                                        cell.viContainerOption.backgroundColor=[UIColor greenColor];
                                         //Name
                                         cell.lblName.text=text;
                                         
                                         float height=[Alert getLabelHeight:cell.lblName];
                                         
                                         float defaultHeight=34;
                                         
                                         float finalHeight=MIN(height, defaultHeight);
                                         
                                         CGRect nameFrame=cell.lblName.frame;
                                         nameFrame.size.height=finalHeight;
                                         cell.lblName.frame=nameFrame;
                                         
                                         
                                         //Option
                                         CGRect optionFrame=cell.viContainerOption.frame;
                                         optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                         cell.viContainerOption.frame=optionFrame;
                                         
                                         cell.lblYes.text=@"Yes";
                                         cell.lblNo.text=@"No";
                                         
                                         //Image
                                         
                                         cell.imgYes.image=[UIImage imageNamed:(value.intValue==1) ? SELECT_RADIO: UNSELECT_RADIO];
                                         cell.imgNo.image=[UIImage imageNamed:(value.intValue==2) ? SELECT_RADIO: UNSELECT_RADIO];
                                         
                                         
                                         //Buttons
                                         cell.btnYes.tag=indexPath.row;
                                         cell.btnNo.tag=indexPath.row;
                                         
                                         [cell.btnYes addTarget:self action:@selector(optionOne:) forControlEvents:UIControlEventTouchUpInside];
                                         [cell.btnNo addTarget:self action:@selector(optionTwo:) forControlEvents:UIControlEventTouchUpInside];
                                         
                                         //Add ' * '
                                         NSString* readMore=@" *";
                                         text=[text stringByAppendingString:readMore];
                                         cell.lblName.text=text;
                                         
                                         cell.lblName.delegate=self;
                                         NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                         cell.lblName.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                         
                                         NSRange r = [cell.lblName.text rangeOfString:readMore];
                                         [cell.lblName addLinkToURL:url withRange:r];
                                         
                                         
                                         return cell;
                                         
                                         }
                                         break;
                                         case 3:
                                         case 4:
                                         case 5:
                                         {
                                         BecomeASellerViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         
                                         //                                        cell.contentView.translatesAutoresizingMaskIntoConstraints=YES;
                                         cell.viContainerValue.translatesAutoresizingMaskIntoConstraints=NO;
                                         cell.lblTitle.translatesAutoresizingMaskIntoConstraints=NO;
                                         cell.txtField.translatesAutoresizingMaskIntoConstraints=NO;
                                         
                                         //                                        CGRect contentFrame=cell.contentView.frame;
                                         CGRect valueFrame=cell.viContainerValue.frame;
                                         CGRect titleFrame=cell.lblTitle.frame;
                                         CGRect textFieldFrame=cell.txtField.frame;
                                         
                                         //                                        contentFrame.size.height=43.0f;
                                         valueFrame.size.height=27.0f;
                                         titleFrame.size.height=21.0f;
                                         textFieldFrame.size.height=27.0f;
                                         
                                         
                                         //                                        cell.contentView.frame=contentFrame;
                                         cell.viContainerValue.frame=valueFrame;
                                         cell.lblTitle.frame=titleFrame;
                                         cell.txtField.frame=textFieldFrame;
                                         
                                         
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         NSString* value=[dic objectForKey:@"value"];
                                         NSString* msg=[dic objectForKey:@"msg"];
                                         
                                         //                                        cell.contentView.backgroundColor=[UIColor yellowColor];
                                         
                                         //Title
                                         cell.lblTitle.text=text;
                                         
                                         cell.txtField.text=value;
                                         
                                         cell.txtField.tag=indexPath.row;
                                         
                                         cell.txtField.delegate=self;
                                         
                                         [Alert attributedString:cell.txtField
                                         msg:msg
                                         color:cell.txtField.textColor];
                                         cell.txtField.autocorrectionType=UITextAutocorrectionTypeNo;
                                         [cell.txtField addTarget:self
                                         action:@selector(textFieldDidChange:)
                                         forControlEvents:UIControlEventEditingChanged];
                                         cell.txtField.tintColor=[UIColor blackColor];
                                         
                                         return cell;
                                         
                                         }
                                         break;
                                         */
                                        
                                        /*
                                         case 6:
                                         {
                                         BecomeASellerViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                         NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                         
                                         NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                         
                                         NSString* text=[dic objectForKey:@"text"];
                                         NSString* value=[dic objectForKey:@"value"];
                                         
                                         cell.lblName.translatesAutoresizingMaskIntoConstraints=
                                         cell.viContainerOption.translatesAutoresizingMaskIntoConstraints=YES;
                                         
                                         //                                        cell.lblName.backgroundColor=[UIColor yellowColor];
                                         //                                        cell.viContainerOption.backgroundColor=[UIColor greenColor];
                                         //Name
                                         cell.lblName.text=text;
                                         
                                         float height=[Alert getLabelHeight:cell.lblName];
                                         
                                         float defaultHeight=34;
                                         
                                         float finalHeight=MIN(height, defaultHeight);
                                         
                                         CGRect nameFrame=cell.lblName.frame;
                                         nameFrame.size.height=finalHeight;
                                         cell.lblName.frame=nameFrame;
                                         
                                         
                                         //Option
                                         CGRect optionFrame=cell.viContainerOption.frame;
                                         optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                         cell.viContainerOption.frame=optionFrame;
                                         
                                         cell.lblYes.text=@"Trial";
                                         cell.lblNo.text=@"Paid";
                                         
                                         //Image
                                         
                                         cell.imgYes.image=[UIImage imageNamed:(value.intValue==1) ? SELECT_RADIO: UNSELECT_RADIO];
                                         cell.imgNo.image=[UIImage imageNamed:(value.intValue==2) ? SELECT_RADIO: UNSELECT_RADIO];
                                         
                                         
                                         //Buttons
                                         cell.btnYes.tag=indexPath.row;
                                         cell.btnNo.tag=indexPath.row;
                                         
                                         [cell.btnYes addTarget:self action:@selector(optionOne:) forControlEvents:UIControlEventTouchUpInside];
                                         [cell.btnNo addTarget:self action:@selector(optionTwo:) forControlEvents:UIControlEventTouchUpInside];
                                         
                                         //Add ' * '
                                         NSString* readMore=@" *";
                                         text=[text stringByAppendingString:readMore];
                                         cell.lblName.text=text;
                                         
                                         cell.lblName.delegate=self;
                                         NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                         cell.lblName.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                         
                                         NSRange r = [cell.lblName.text rangeOfString:readMore];
                                         [cell.lblName addLinkToURL:url withRange:r];
                                         
                                         
                                         return cell;
                                         
                                         }
                                         
                                         break;
                                         
                                         */
                                        
                                case 7:
                                {
                                        BecomeASellerViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerCouponCode.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerApply.translatesAutoresizingMaskIntoConstraints=
                                        cell.lblCouponResult.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        
                                        
                                        
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        NSDictionary* dicLast=[arrData objectAtIndex:indexPath.row+row+row1-1];
                                        NSString* valueLast=[dicLast objectForKey:@"value"];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        NSString* msg=[dic objectForKey:@"msg"];
                                        
                                        if(valueLast.intValue==1){
                                                
                                                cell.lblTitle1.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:11];
                                                cell.lblTitle1.text=@"(Trial account will be valid for 10 days only from activation date)";
                                                
                                                cell.lblTitle1.textColor=[UIColor blackColor];
                                                
                                                CGRect titleFrame=cell.lblTitle.frame;
                                                titleFrame.size.height=0;
                                                cell.lblTitle.frame=titleFrame;
                                                
                                                CGRect couponResultFrame=cell.lblCouponResult.frame;
                                                couponResultFrame.size.height=0;
                                                cell.lblCouponResult.frame=couponResultFrame;
                                                
                                                CGRect couponFrame=cell.viContainerCouponCode.frame;
                                                couponFrame.size.height=0;
                                                cell.viContainerCouponCode.frame=couponFrame;
                                                
                                                CGRect applyFrame=cell.viContainerApply.frame;
                                                applyFrame.size.height=0;
                                                cell.viContainerApply.frame=applyFrame;
                                        }
                                        else if (valueLast.intValue==2){
                                                
                                                cell.lblTitle1.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                                cell.lblTitle1.text=text;
                                                cell.lblTitle1.textColor=[UIColor blackColor];
                                                
                                                CGRect titleFrame=cell.lblTitle.frame;
                                                titleFrame.size.height=21;
                                                cell.lblTitle.frame=titleFrame;
                                                
                                                
                                                
                                                CGRect couponFrame=cell.viContainerCouponCode.frame;
                                                couponFrame.size.height=30;
                                                cell.viContainerCouponCode.frame=couponFrame;
                                                
                                                CGRect applyFrame=cell.viContainerApply.frame;
                                                applyFrame.size.height=30;
                                                cell.viContainerApply.frame=applyFrame;
                                                
                                                NSString* amount=[dic objectForKey:@"amount"];
                                                NSString* couponText=@"";
                                                if(amount){
                                                        
                                                        CGRect couponResultFrame=cell.lblCouponResult.frame;
                                                        couponResultFrame.size.height=33;
                                                        couponResultFrame.origin.y=applyFrame.origin.y+applyFrame.size.height+8;
                                                        cell.lblCouponResult.frame=couponResultFrame;
                                                        
                                                        couponText=[NSString stringWithFormat:@"Coupon successfully applied and coupon amount is $%@ . You have to pay $%d",amount,(300-amount.intValue)];
                                                        
                                                }
                                                else{
                                                        
                                                        CGRect couponResultFrame=cell.lblCouponResult.frame;
                                                        couponResultFrame.size.height=0;
                                                        cell.lblCouponResult.frame=couponResultFrame;
                                                }
                                                
                                                cell.lblCouponResult.text=couponText;
                                                cell.lblCouponResult.textColor=[UIColor redColor];
                                                
                                        }
                                        
                                        
                                        cell.lblTitle.text=@"Coupon Code";
                                        
                                        
                                        cell.txtCouponCode.tag=indexPath.row;
                                        cell.txtCouponCode.text=value;
                                        cell.txtCouponCode.delegate=self;
                                        cell.txtCouponCode.autocorrectionType=UITextAutocorrectionTypeNo;
                                        [Alert attributedString:cell.txtCouponCode
                                                            msg:msg
                                                          color:cell.txtCouponCode.textColor];
                                        
                                        [cell.txtCouponCode addTarget:self
                                                               action:@selector(textFieldDidChange:)
                                                     forControlEvents:UIControlEventEditingChanged];
                                        
                                        
                                        
                                        cell.btnApply.tag=indexPath.row;
                                        [cell.btnApply addTarget:self action:@selector(applyCoupon:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        
                                        
                                        return cell;
                                }
                                        break;
                                        
                                case 8:
                                {
                                        BecomeASellerViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        
                                        
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerField.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        //                                        cell.contentView.backgroundColor=[UIColor grayColor];
                                        //                                        cell.lblTitle.backgroundColor=[UIColor yellowColor];
                                        //                                        cell.viContainerField.backgroundColor=[UIColor greenColor];
                                        //                                        cell.txtviField.backgroundColor=[UIColor blueColor];
                                        
                                        //Name
                                        cell.lblTitle.text=text;
                                        
                                        float height=[Alert getLabelHeight:cell.lblTitle];
                                        
                                        float defaultHeight=34;
                                        
                                        float finalHeight=MIN(height, defaultHeight);
                                        
                                        CGRect nameFrame=cell.lblTitle.frame;
                                        nameFrame.size.height=finalHeight;
                                        cell.lblTitle.frame=nameFrame;
                                        
                                        
                                        //Option
                                        CGRect optionFrame=cell.viContainerField.frame;
                                        optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                        cell.viContainerField.frame=optionFrame;
                                        
                                        
                                        cell.txtviField.text=value;
                                        cell.txtviField.tag=indexPath.row;
                                        cell.txtviField.delegate=self;
                                        
                                        //Add ' * '
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3: {
                        switch (indexPath.row) {
                                case 0:
                                {
                                        BecomeASellerViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        NSInteger row2=[self tableView:self.tableView numberOfRowsInSection:2];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1+row2];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        
                                        cell.lblName.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerOption.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        //                                        cell.lblName.backgroundColor=[UIColor yellowColor];
                                        //                                        cell.viContainerOption.backgroundColor=[UIColor greenColor];
                                        //Name
                                        cell.lblName.text=text;
                                        
                                        float height=[Alert getLabelHeight:cell.lblName];
                                        
                                        float defaultHeight=34;
                                        
                                        float finalHeight=MIN(height, defaultHeight);
                                        
                                        CGRect nameFrame=cell.lblName.frame;
                                        nameFrame.size.height=finalHeight;
                                        cell.lblName.frame=nameFrame;
                                        
                                        
                                        //Option
                                        CGRect optionFrame=cell.viContainerOption.frame;
                                        optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                        cell.viContainerOption.frame=optionFrame;
                                        
                                        cell.lblYes.text=@"Yes";
                                        cell.lblNo.text=@"No";
                                        
                                        //Image
                                        
                                        cell.imgYes.image=[UIImage imageNamed:(value.intValue==1) ? SELECT_RADIO: UNSELECT_RADIO];
                                        cell.imgNo.image=[UIImage imageNamed:(value.intValue==2) ? SELECT_RADIO: UNSELECT_RADIO];
                                        
                                        
                                        //Buttons
                                        cell.btnYes.tag=indexPath.row;
                                        cell.btnNo.tag=indexPath.row;
                                        
                                        [cell.btnYes addTarget:self action:@selector(optionOne:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnNo addTarget:self action:@selector(optionTwo:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        //Add ' * '
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblName.text=text;
                                        
                                        cell.lblName.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblName.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                        NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblName.text rangeOfString:readMore];
                                        [cell.lblName addLinkToURL:url withRange:r];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                case 1:
                                case 2:
                                case 3:
                                {
                                        BecomeASellerViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        //                                        cell.contentView.translatesAutoresizingMaskIntoConstraints=YES;
                                        cell.viContainerValue.translatesAutoresizingMaskIntoConstraints=NO;
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=NO;
                                        cell.txtField.translatesAutoresizingMaskIntoConstraints=NO;
                                        
                                        //                                        CGRect contentFrame=cell.contentView.frame;
                                        CGRect valueFrame=cell.viContainerValue.frame;
                                        CGRect titleFrame=cell.lblTitle.frame;
                                        CGRect textFieldFrame=cell.txtField.frame;
                                        
                                        //                                        contentFrame.size.height=43.0f;
                                        valueFrame.size.height=27.0f;
                                        titleFrame.size.height=21.0f;
                                        textFieldFrame.size.height=27.0f;
                                        
                                        
                                        //                                        cell.contentView.frame=contentFrame;
                                        cell.viContainerValue.frame=valueFrame;
                                        cell.lblTitle.frame=titleFrame;
                                        cell.txtField.frame=textFieldFrame;
                                        
                                        
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        NSInteger row2=[self tableView:self.tableView numberOfRowsInSection:2];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1+row2];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        NSString* msg=[dic objectForKey:@"msg"];
                                        
                                        //                                        cell.contentView.backgroundColor=[UIColor yellowColor];
                                        
                                        //Title
                                        cell.lblTitle.text=text;
                                        
                                        cell.txtField.text=value;
                                        
                                        cell.txtField.tag=indexPath.row;
                                        
                                        cell.txtField.delegate=self;
                                        
                                        [Alert attributedString:cell.txtField
                                                            msg:msg
                                                          color:cell.txtField.textColor];
                                        cell.txtField.autocorrectionType=UITextAutocorrectionTypeNo;
                                        [cell.txtField addTarget:self
                                                          action:@selector(textFieldDidChange:)
                                                forControlEvents:UIControlEventEditingChanged];
                                        cell.txtField.tintColor=[UIColor blackColor];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 4:
                                        // Text View Let Us know...
                                {
                                        BecomeASellerViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                                        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
                                        NSInteger row2=[self tableView:self.tableView numberOfRowsInSection:2];
                                        
                                        NSDictionary* dic=[arrData objectAtIndex:indexPath.row+row+row1+row2];
                                        
                                        NSString* text=[dic objectForKey:@"text"];
                                        NSString* value=[dic objectForKey:@"value"];
                                        
                                        
                                        cell.lblTitle.translatesAutoresizingMaskIntoConstraints=
                                        cell.viContainerField.translatesAutoresizingMaskIntoConstraints=YES;
                                        
                                        //                                        cell.contentView.backgroundColor=[UIColor grayColor];
                                        //                                        cell.lblTitle.backgroundColor=[UIColor yellowColor];
                                        //                                        cell.viContainerField.backgroundColor=[UIColor greenColor];
                                        //                                        cell.txtviField.backgroundColor=[UIColor blueColor];
                                        
                                        //Name
                                        cell.lblTitle.text=text;
                                        
                                        float height=[Alert getLabelHeight:cell.lblTitle];
                                        
                                        float defaultHeight=34;
                                        
                                        float finalHeight=MIN(height, defaultHeight);
                                        
                                        CGRect nameFrame=cell.lblTitle.frame;
                                        nameFrame.size.height=finalHeight;
                                        cell.lblTitle.frame=nameFrame;
                                        
                                        
                                        //Option
                                        CGRect optionFrame=cell.viContainerField.frame;
                                        optionFrame.origin.y=nameFrame.origin.y+nameFrame.size.height+8;
                                        cell.viContainerField.frame=optionFrame;
                                        
                                        
                                        cell.txtviField.text=value;
                                        cell.txtviField.tag=indexPath.row;
                                        cell.txtviField.delegate=self;
                                        
                                        //Add ' * '
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                case 5: {
                                        
                                        BecomeASellerViewCell7 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier8 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor clearColor];
                                        
                                        [cell.buttonCheckBox addTarget:self action:@selector(buttonCheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.buttonTermsOfService addTarget:self action:@selector(buttonTermsOfServiceTapped:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        NSDictionary *dic = [arrData objectAtIndex:14];
                                        
                                        BOOL isSelected = [[dic objectForKey:@"value"] boolValue];
                                        UIImage *image = isSelected ? [UIImage imageNamed:@"selected_tick"] : [UIImage imageNamed:@"unselected_tick"]; // selected_tick
                                        
                                        [cell.buttonCheckBox setImage:image forState:UIControlStateNormal];
                                        
                                        return cell;
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                }
                case 4:
                {
                        UpdateProfileViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.contentView.backgroundColor=[UIColor whiteColor];
                        cell.lblTitle.text=@"SUBMIT";
                        cell.btnClick.tag=indexPath.row;
                        [cell.btnClick addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
                        return cell;
                }
                        break;
                        
                case 5:
                        /*
                         {
                         BecomeASellerViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                         //                        cell.contentView.backgroundColor=[UIColor whiteColor];
                         //                        cell.btnTrial.tag=indexPath.row;
                         
                         [cell.btnApply addTarget:self action:@selector(paid:) forControlEvents:UIControlEventTouchUpInside];
                         
                         
                         
                         return cell;
                         }
                         */
                        
                        
                {
                        BecomeASellerViewCell6 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier7 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //                        cell.contentView.backgroundColor=[UIColor whiteColor];
                        //                        cell.btnTrial.tag=indexPath.row;
                        [cell.btnHome addTarget:self action:@selector(homePage:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                }
                        
                        
                        break;
                        
                default:
                        break;
        }
        
        
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        NSString *header  = [arrHeaderTitle objectAtIndex:section];
        
        return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        //Header View
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor=[UIColor whiteColor];
        
        //Header Title
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, 20);
        myLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:14];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textAlignment=NSTextAlignmentCenter;
        myLabel.textColor=[UIColor redColor];
        myLabel.backgroundColor=[UIColor clearColor];
        [headerView addSubview:myLabel];
        
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        
        NSInteger height=36;
        //             if(section==3 || section==4 || [[EAGallery sharedClass] roleType]==BecomeAnArtistPending) height=0;
        if(section==4 || section==5 || [[EAGallery sharedClass] roleType]==BecomeAnArtistPending) height=0;
        
        return height;
}


#pragma mark - TTTAttributedLabel Delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
        
        
        
        if ([[url scheme] hasPrefix:@"action"]) {
                if ([[url host] hasPrefix:@"Expand"]) {
                        
                        /* load help screen */
                } else if ([[url host] hasPrefix:@"show-settings"]) {
                        /* load settings screen */
                }
        } else {
                /* deal with http links here */
        }
}

#pragma Mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        
        [textField resignFirstResponder];
        
        
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        //        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:0];
        NSIndexPath *indexPath =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        
        return YES;
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
        
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
        [textField resignFirstResponder];
        
        BecomeASellerViewCell2 * cell;
        NSIndexPath *indexPathOriginal =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        if(indexPathOriginal.section==0){
                if(textField.tag==0 && !IS_EMPTY(textField.text)){
                        BOOL isName=[Alert validationString:textField.text];
                        
                        if(!isName){
                                [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES];
                                [textField becomeFirstResponder];
                                
                        }
                        else{
                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                [cell.txtField becomeFirstResponder];
                                
                        }
                }
                if(textField.tag==1 && !IS_EMPTY(textField.text)){
                        BOOL isEmail=[Alert validationEmail:textField.text];
                        
                        if(!isEmail){
                                [Alert alertWithMessage:@"Invalid Email ! Please enter valid Email."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES];
                                [textField becomeFirstResponder];
                                
                        }
                        else{
                                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:indexPathOriginal.section];
                                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                
                        }
                }
        }
        if(indexPathOriginal.section==3){
                
                if(textField.tag==1 && !IS_EMPTY(textField.text)){
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                        [cell.txtField becomeFirstResponder];
                }
                if(textField.tag==2 && !IS_EMPTY(textField.text)){
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                        [cell.txtField becomeFirstResponder];
                }
                if(textField.tag==3 && !IS_EMPTY(textField.text)){
                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:indexPathOriginal.section];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        
                }
        }
        
        
        if(isUpdateHeight){
                
                float height=0;
                
                if([self.from isEqualToString:@"popup"])
                        height=self.view.frame.size.height;
                else
                        height=self.view.frame.size.height-64;
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 height);
                
                
        }
        
        isUpdateHeight=NO;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender {
        
        //        isUpdate=YES;
        BOOL isValid=NO;
        UITextField* txt=(UITextField*)sender;
        NSIndexPath *indexPath =[Alert getIndexPathWithTextfield:txt table:self.tableView];
        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
        NSInteger row2=[self tableView:self.tableView numberOfRowsInSection:2];
        
        //
        if(indexPath.section==0){
                if(txt.tag==0)
                        isValid=[Alert validationString:txt.text];
                if(txt.tag==1)
                        isValid=[Alert validationEmail:txt.text];
                if(![[EAGallery sharedClass] isLogin]){
                        if(txt.tag==2)
                                isValid=[Alert validateMobileNumber:txt.text];
                        
                        if(txt.tag==3 || txt.tag==4) isValid=YES;
                }
        }
        //        if(indexPath.section==2) isValid=YES;
        if(indexPath.section==3) isValid=YES; // Added by cs rai
        
        txt.textColor = isValid ? [UIColor blackColor] : [UIColor redColor];
        
        NSMutableDictionary* dic=[arrData objectAtIndex:txt.tag+(indexPath.section==2 ? row : indexPath.section==3 ? (row+row1+row2) : 0)];
        
        [dic setObject:txt.text forKey:@"value"];
}


#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
        //        textView.backgroundColor = [UIColor whiteColor];
        //        textView.textColor=[UIColor blackColor];
        
        
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        //        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textView.tag inSection:1];
        NSIndexPath *indexPath =[Alert getIndexPathWithTextView:textView table:self.tableView];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
        //  NSLog(@"textViewShouldEndEditing:");
        
        // textView.textColor= [UIColor blackColor];
        return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
        //    NSLog(@"textViewDidEndEditing:");
        
        if(isUpdateHeight){
                
                float height=0;
                
                if([self.from isEqualToString:@"popup"])
                        height=self.view.frame.size.height;
                else
                        height=self.view.frame.size.height-64;
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 height);
                
        }
        isUpdateHeight=NO;
        
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
        
        NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
        NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
        NSUInteger location = replacementTextRange.location;
        
        if (textView.text.length + text.length > 140){
                if (location != NSNotFound){
                        [textView resignFirstResponder];
                }
                return NO;
        }
        else if (location != NSNotFound){
                [textView resignFirstResponder];
                return NO;
        }
        return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
        //    NSLog(@"textViewDidChangeSelection:");
}

- (void)textViewDidChange:(UITextView *)textView{
        //        textView.textColor=[UIColor blackColor];
        //        isUpdate=YES;
        //[self validateForNativeChat];
        NSIndexPath *indexPath =[Alert getIndexPathWithTextView:textView table:self.tableView];
        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
        NSInteger row2=[self tableView:self.tableView numberOfRowsInSection:2];
        
        if(textView.text.length == 0){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = @"";
                [textView resignFirstResponder];
        }
        NSMutableDictionary* dic = [arrData objectAtIndex:textView.tag+(indexPath.section==3 ? (row+row1+row2) : 0)];
        
        [dic setObject:textView.text forKey:@"value"];
}


#pragma mark PayPal Payment gateway

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
                
                
                
                
                NSMutableDictionary* data=[arrData objectAtIndex:17];
                NSMutableDictionary* dic=[dicResult mutableCopy];
                
                [dic setObject:@"2"
                        forKey:@"membershipType"];
                [dic setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_AMOUNT]
                        forKey:@"txn_amt"];
                [dic setObject:[self.transactionDetails objectForKey:PAYPAL_TRANSACTION_ID]
                        forKey:PAYPAL_TRANSACTION_ID];
                [dic setObject:[data objectForKey:@"value"]
                        forKey:@"coupon"];
                
                [self submitWebService:[dic mutableCopy]];
                
                
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

-(void)configPayPal{
//        self.title = @"PayPal";
        
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


#pragma mark- Open PayPal view
-(void)openPayPalView{
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
        
        NSMutableDictionary* dic=[arrData objectAtIndex:17];
        NSString* amountCoupon=[dic objectForKey:@"amount"];
        
        NSString* amount=[@(300-amountCoupon.intValue) stringValue];
        
        // Optional: include multiple items
        
        PayPalItem *item1 = [PayPalItem itemWithName:@"Easton Art Gallery"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:amount]
                                        withCurrency:CURRENCY_TYPE
                                             withSku:[NSString stringWithFormat:@"EastonArtGallery-%@",[dic objectForKey:@"value"]]];
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


#pragma mark - Target Methods

-(IBAction)optionOne:(id)sender{
        
        [self setDefaultTableHeight];

        
        UIButton* button=(UIButton*)sender;
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
        NSInteger row2=[self tableView:self.tableView numberOfRowsInSection:2];
        
        NSMutableDictionary* dic = [arrData objectAtIndex:button.tag+(indexPath.section==3 ? (row+row1+row2) : 0)];
        
        [dic setObject:@"1" forKey:@"value"];
        
        NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
        NSArray* arrAdditionalIndex=nil;
        
        if(indexPath.section == 3 && indexPath.row == 0)
        {
                NSIndexPath* index=[Alert getIndexPath:1 section:3];
                arrAdditionalIndex=[NSArray arrayWithObjects:index, nil];
                rowsToReload=[rowsToReload arrayByAddingObjectsFromArray:arrAdditionalIndex];
        }
        
        
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        
}

-(IBAction)optionTwo:(id)sender{
        
        [self setDefaultTableHeight];

        UIButton* button=(UIButton*)sender;
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
        NSInteger row1 = [self tableView:self.tableView numberOfRowsInSection:1];
        NSInteger row2 = [self tableView:self.tableView numberOfRowsInSection:2];
        
        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag+(indexPath.section == 3 ? (row+row1+row2) : 0)];
        
        [dic setObject:@"2" forKey:@"value"];
        
        NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
        
        NSArray* arrAdditionalIndex=nil;
        
        if(indexPath.section==3 && indexPath.row==0)
        {
                NSIndexPath* index=[Alert getIndexPath:1 section:3];
                arrAdditionalIndex=[NSArray arrayWithObjects:index, nil];
                rowsToReload=[rowsToReload arrayByAddingObjectsFromArray:arrAdditionalIndex];
        }
        
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        
}


-(void)buttonTermsOfServiceTapped : (UIButton *)button {
        
        [self setDefaultTableHeight];

        TermsOfUseBecomeAsellerVC *vc = GET_VIEW_CONTROLLER_STORYBOARD(kTermsOfUseBecomeAsellerVC);
        vc.titleString=@"Terms Of use";
        vc.from=@"back";
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
}

-(void)buttonCheckBoxTapped : (id)sender {
        
        [self setDefaultTableHeight];

        UIButton* button=(UIButton *)sender;
        NSIndexPath* indexPath =[Alert getIndexPath:5 section:3];
        
        
        NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
        
        
        NSLog(@"Button Terms of service Check box tapped");
        NSMutableDictionary *dic = [arrData objectAtIndex:14];
        [dic setValue:@"1" forKey:@"value"];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        
}

-(IBAction)selectOpt:(id)sender {
        
        [self setDefaultTableHeight];
        
        UIButton* button=(UIButton*)sender;
        
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        
        switch (indexPath.section) {
                case 1:
                        
                        switch (indexPath.row) {
                                        //                                case 4:
                                case 1:
                                        
                                {
                                        if(arrHearAbout.count)
                                                [self createDatePicker:YES items:arrHearAbout sender:sender];
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                case 2:
                        switch (indexPath.row) {
                                case 0:
                                {
                                        if(arrCountryList.count)
                                                [self createDatePicker:YES items:arrCountryList sender:sender];
                                        
                                        else{
                                                countrySender=sender;
                                                
                                                [self getCountryListWebService];
                                        }
                                }
                                        break;
                                        
                                case 1:
                                {
                                        if(arrSellingCurrency.count)
                                                [self createDatePicker:YES items:arrSellingCurrency sender:sender];
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                default:
                        break;
        }
        
        
        
}

// Set Default table height

-(void)setDefaultTableHeight {
        
        [self.view endEditing:YES];
        if(isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height+216);
                
        }
        
}

-(IBAction)submit:(id)sender{
        
        [self submit];
}

-(IBAction)applyCoupon:(id)sender {
        
        UIButton* button=(UIButton*)sender;
        applyButton=button;
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
        NSInteger row1=[self tableView:self.tableView numberOfRowsInSection:1];
        
        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag+(indexPath.section==2 ? (row+row1) : 0)];
        
        if(IS_EMPTY([dic objectForKey:@"value"]))
        {
                [Alert alertWithMessage:@"Field can't be empty !"
                             navigation:self.navigationController
                               gotoBack:NO animation:YES second:2.0];
                return;
        }
        //        {"coupon":"1221212hgg","user":"193"}
        
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
        if([[EAGallery sharedClass] isLogin])
                [data setObject:[[EAGallery sharedClass] memberID]       forKey:@"user"];
        [data setObject:[dic objectForKey:@"value"] forKey:@"coupon"];
        
        
        [self validateCouponCodeWebService:[data mutableCopy]];
        
        
}

-(IBAction)homePage:(id)sender{
        
        [self setDefaultTableHeight];
        MOVE_VIEW_CONTROLLER_VIEW_DECK(GET_VIEW_CONTROLLER(kViewController));
}

// Set Default table height



-(void)submit {
        
        NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* index1=[NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2=[NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath* index4=[NSIndexPath indexPathForRow:4 inSection:0];
        
        
        BOOL extraOpt=NO;
        if(![[EAGallery sharedClass] isLogin]) {
                
                if(![[[arrData objectAtIndex:2] objectForKey:@"value"] isEqualToString:ENTER_PHONE_TEXT] &&
                   ![[[arrData objectAtIndex:3] objectForKey:@"value"] isEqualToString:ENTER_PASSWORD_TEXT] &&
                   ![[[arrData objectAtIndex:4] objectForKey:@"value"] isEqualToString:ENTER_CONFIRM_PASSWORD_TEXT])
                        extraOpt=YES;
        }
        else extraOpt=YES;
        
        if(
           ![[[arrData objectAtIndex:0] objectForKey:@"value"] isEqualToString:ENTER_NAME_TEXT] &&
           ![[[arrData objectAtIndex:1] objectForKey:@"value"] isEqualToString:ENTER_EMAIL_TEXT] &&
           extraOpt &&
           
           // Commented on 14 August By CS Rai
           
           //           [[[arrData objectAtIndex:5] objectForKey:@"value"] intValue]!=0 &&
           //           [[[arrData objectAtIndex:6] objectForKey:@"value"] intValue]!=0 &&
           //           [[[arrData objectAtIndex:7] objectForKey:@"value"] intValue]!=0 &&
           
           [[[arrData objectAtIndex:5] objectForKey:@"value"] intValue]!=0 &&
           ![[[arrData objectAtIndex:6] objectForKey:@"value"] isEqualToString:SELECT_OPTION] &&
           ![[[arrData objectAtIndex:7] objectForKey:@"value"] isEqualToString:SELECT_OPTION] &&
           ![[[arrData objectAtIndex:8] objectForKey:@"value"] isEqualToString:SELECT_OPTION] &&
           [[[arrData objectAtIndex:9] objectForKey:@"value"] intValue]!=0 &&
           !IS_EMPTY([[arrData objectAtIndex:13] objectForKey:@"value"]) &&
           [[[arrData objectAtIndex:14] objectForKey:@"value"] intValue]!=0 )
                
        {
                
                BOOL isName=[Alert validationString:[[arrData objectAtIndex:0] objectForKey:@"value"]];
                BOOL isEmail=[Alert validationEmail:[[arrData objectAtIndex:1] objectForKey:@"value"]];
                BOOL isPhone=[Alert validateMobileNumber:[[arrData objectAtIndex:2] objectForKey:@"value"]];
                BOOL isPassword=[[[arrData objectAtIndex:3] objectForKey:@"value"] isEqualToString:[[arrData objectAtIndex:4] objectForKey:@"value"]];
                //                BOOL isConfirmPassword=[Alert validationEmail:[[arrData objectAtIndex:4] objectForKey:@"value"]];
                
                
                
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                        
                }
                if(!isEmail){
                        [Alert alertWithMessage:@"Invalid Email ! Please enter valid email."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                if(![[EAGallery sharedClass] isLogin]){
                        
                        if(!isPhone){
                                [Alert alertWithMessage:@"Invalid Phone ! Please enter valid phone number."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES second:2.0];
                                [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                return;
                        }
                        if(!isPassword){
                                
                                [Alert alertWithMessage:@"Invalid Confirm Password ! Password do not match."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES second:2.0];
                                [self.tableView scrollToRowAtIndexPath:index4 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                return;
                        }
                        
                }
                
                
                
                {
                        //{"user_id":"81","email":"yogesh20.kumar@gmail.com","original":"Yes","edition":"Yes","created":"Yes","gallery":"Yes","source":"facebook","country":"IN","currency":"USD","sold_online_before":"Yes","website":"http://www.abc.com","facebook":"http://www.facebook.com","twitter":"t","intro":"testing","status":"1","membershipType":"2","txn_amt":"120","txn_id":"ASDSD8768578","coupon":"HGFHGF7657"}
                        
                        
                         dicRequestParam =[NSMutableDictionary dictionary];
                        
                        if([[EAGallery sharedClass] isLogin])
                                [dicRequestParam setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"]; //
                        [dicRequestParam setObject:@"No" forKey:[[EAGallery sharedClass] isLogin] ? @"original" : @"signed"];
                        [dicRequestParam setObject:@"No" forKey:@"edition"];
                        [dicRequestParam setObject:@"No" forKey:@"created"];
                        
                        
                        
                        [dicRequestParam setObject:[[arrData objectAtIndex:0] objectForKey:@"value"] forKey:@"name"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:1] objectForKey:@"value"] forKey:@"email"]; //
                        
                        [dicRequestParam setObject:[[arrData objectAtIndex:2] objectForKey:@"value"] forKey:@"phone"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:3] objectForKey:@"value"] forKey:@"password"]; //
                        
                        [dicRequestParam setObject:[[[arrData objectAtIndex:5] objectForKey:@"value"] intValue]==1 ? @"Yes" : @"No" forKey:@"gallery"]; //
                        
                        [dicRequestParam setObject:[[arrData objectAtIndex:6] objectForKey:@"value"] forKey:@"source"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:7] objectForKey:@"value"] forKey:@"country"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:8] objectForKey:@"value"] forKey:@"currency"]; //
                        [dicRequestParam setObject:[[[arrData objectAtIndex:9] objectForKey:@"value"] intValue]==1 ? @"Yes" : @"No" forKey:[[EAGallery sharedClass] isLogin] ? @"sold_online_before" : @"online"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:10] objectForKey:@"value"] forKey:@"website"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:11] objectForKey:@"value"] forKey:@"facebook"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:12] objectForKey:@"value"] forKey:@"twitter"]; //
                        [dicRequestParam setObject:[[arrData objectAtIndex:13] objectForKey:@"value"] forKey:@"intro"]; //
                        
                        
                        // By Chandra......
                        
                        /*
                      if([[[arrData objectAtIndex:16] objectForKey:@"value"] intValue]==1){
                        
                                                        [dic setObject:@"1"     forKey:@"membershipType"];
                                                        [dic setObject:@""      forKey:@"txn_amt"];
                                                        [dic setObject:@""      forKey:@"txn_id"];
                                                        [dic setObject:@""      forKey:@"coupon"];
                        
                                                        [self submitWebService:[dic mutableCopy]];
                                                }
                                                else
                        
                        {
                                
                                //Paypal open
                                
                                dicResult=[dic mutableCopy];
                                
                                [self openPayPalView];
                                
                        }
                        
                        */
                        
                        [self checkEmailExistanceInDataBaseWebService: [[arrData objectAtIndex:1] objectForKey:@"value"]];
                }
        }
        else
        {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Mandatory (*) Fields can not be blank!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil]show];
                
                
        }
        
}


@end
