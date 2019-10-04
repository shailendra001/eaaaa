//
//  LoginViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 07/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewCell.h"
#import "LoginViewCell.h"
#import "RegistrationViewController.h"
#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>


#define COLOR_CELL_BACKGROUND           @"#DEDEDD"
#define COLOR_CELL_HEADER               @"#D4D4D4"
#define COLOR_CELL_TEXT                 @"#575656"
#define COLOR_CELL_CONTENT_BORRDER      @"#CBC9C9"


static NSString *const kKeychainItemName = @"Google OAuth2 For gglplustest";
static NSString *const kClientID = @"201488398408-krvnruj8mn31u2mg14hbsd78a8sv7hu7.apps.googleusercontent.com";
static NSString *const kClientSecret = @"AiUehCLrymId4G1QGsps2TQp";



@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GPPSignInDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSArray* arrIcon;
        NSMutableArray* arrData;
        BOOL isUpdateHeight;
        NSMutableArray* arrTextData;
        
        BOOL isGooglePlus;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        
}

@property(retain, nonatomic)GTMOAuth2Authentication* auth;

@end

@implementation LoginViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";

#pragma mark - View controller life cicle


- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self loadData];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
        
        
        
        
        

}

-(void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        [self loadCardCount];
        
        if(isGooglePlus)
                [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
        
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        self.view.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        
        self.btnForgotPassword.layer.cornerRadius=
        self.btnRegister.layer.cornerRadius=2.0;
        
}

-(void)loadData{
        
        arrIcon=@[
                  @"user_icon_black.png",
                  @"key_icon.png",
                  ];
        
        {
                arrData=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Email Id/Username"                             forKey:@"msg"];
                [dic setObject:@"email_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];

                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Password"                                      forKey:@"msg"];
                [dic setObject:@"key_icon.png"                                  forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
        }
        
        {
                arrTextData=[[NSMutableArray alloc]init];
                
                for (int i=0; i<2; i++) {
                        [arrTextData addObject:@""];
                }
                
        }
        
        
}

-(void)setLogoImage{
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
}

-(void)setNav{
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}

-(void)cellRegister{
        
        [self.tableView registerClass:[RegistrationViewCell class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[LoginViewCell class] forCellReuseIdentifier:CellIdentifier2];
        //        //        [self.tableView registerClass:[ArtDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        //
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"RegistrationViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        //
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"LoginViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        //
        //        UINib *contantsCellNib3 = [UINib nibWithNibName:@"ArtDetailViewCell3" bundle:nil];
        //        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
}

-(void)setActivityIndicator{
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

-(void)removeActivityIndicator{
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

-(void)setBackgroundLabel{
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

-(void)removeBackgroundLabel{
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

-(void)removeCardCount{
        
        for (id view in cardViewGlobal.subviews) {
                
                if(![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UIButton class]] )
                        [view removeFromSuperview];
        }
}

#pragma mark -Call WebService

-(void)getWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Login);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                // NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                
                NSURL *url = [NSURL URLWithString:urlString];
                
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                //                NSData *req=[NSData dataWithBytes:[postString UTF8String] length:[postString length]];
                [theRequest setHTTPBody:postData];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
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
                                
                                if (success.boolValue) {
                                        NSDictionary*resPonsedata = (NSDictionary*)[result valueForKey:@"data"];
                                        
                                       
                                        resPonsedata = [Alert dictionaryByReplacingNullsWithString:@"" dic:resPonsedata];
                                        
                                        [EAGallery sharedClass].memberID        =[resPonsedata objectForKey:LOGIN_MEMBER_ID];
                                        [EAGallery sharedClass].registeredOn    =[resPonsedata objectForKey:LOGIN_ADDED_ON];
                                        
                                        [EAGallery sharedClass].name            =[resPonsedata objectForKey:LOGIN_NAME];
                                        [EAGallery sharedClass].userName        =[resPonsedata objectForKey:LOGIN_USER_NAME];
                                        [EAGallery sharedClass].email           =[resPonsedata objectForKey:LOGIN_EMAIL];
                                        [EAGallery sharedClass].country         =[resPonsedata objectForKey:LOGIN_COUNTRY];
                                        [EAGallery sharedClass].phone           =[resPonsedata objectForKey:LOGIN_PHONE];
                                        [EAGallery sharedClass].profileImage    =[resPonsedata objectForKey:LOGIN_PROFILE_IMAGE];
                                        [EAGallery sharedClass].coverImage      =[resPonsedata objectForKey:LOGIN_COVER_IMAGE];
                                        [EAGallery sharedClass].bio             =[resPonsedata objectForKey:LOGIN_BIO];
                                        [EAGallery sharedClass].profileVideo    =[resPonsedata objectForKey:LOGIN_VIDEO_LINK];
                                        [EAGallery sharedClass].walletAmount    =[resPonsedata objectForKey:LOGIN_WALLET_AMOUNT];
                                        [EAGallery sharedClass].roleType        =[[EAGallery sharedClass] getRoleType:[[resPonsedata objectForKey:LOGIN_ROLE_TYPE] intValue]];
                                        [EAGallery sharedClass].type            =EmailId;
                                        [EAGallery sharedClass].isLogin         =YES;
                                        
                                        [[EAGallery sharedClass] saveDataLocal];
                                        
                                        [[NSUserDefaults standardUserDefaults]setObject:[resPonsedata objectForKey:COUNTRY_LIST] forKey:COUNTRY_LIST];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        
                                       
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                                
                                                ViewController*vc=GET_VIEW_CONTROLLER(kViewController);
                                                
                                                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
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

#pragma mark -Call WebService

-(void)socialLoginWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_LoginViaSocial);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                // NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                
                NSURL *url = [NSURL URLWithString:urlString];
                
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                //                NSData *req=[NSData dataWithBytes:[postString UTF8String] length:[postString length]];
                [theRequest setHTTPBody:postData];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
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
                                        NSDictionary*resPonsedata = (NSDictionary*)[result valueForKey:@"data"];
                                        
                                        [EAGallery sharedClass].memberID        =[resPonsedata objectForKey:LOGIN_MEMBER_ID];
                                        [EAGallery sharedClass].registeredOn    =[resPonsedata objectForKey:LOGIN_ADDED_ON];
                                        
                                        [EAGallery sharedClass].name            =[resPonsedata objectForKey:LOGIN_NAME];
                                        [EAGallery sharedClass].userName        =[resPonsedata objectForKey:LOGIN_USER_NAME];
                                        [EAGallery sharedClass].email           =[resPonsedata objectForKey:LOGIN_EMAIL];
                                        [EAGallery sharedClass].country         =[resPonsedata objectForKey:LOGIN_COUNTRY];
                                        [EAGallery sharedClass].phone           =[resPonsedata objectForKey:LOGIN_PHONE];
                                        [EAGallery sharedClass].profileImage    =[resPonsedata objectForKey:LOGIN_PROFILE_IMAGE];
                                        [EAGallery sharedClass].coverImage      =[resPonsedata objectForKey:LOGIN_COVER_IMAGE];
                                        [EAGallery sharedClass].bio             =[resPonsedata objectForKey:LOGIN_BIO];
                                        [EAGallery sharedClass].profileVideo    =[resPonsedata objectForKey:LOGIN_VIDEO_LINK];
                                        [EAGallery sharedClass].walletAmount    =[resPonsedata objectForKey:LOGIN_WALLET_AMOUNT];
                                        [EAGallery sharedClass].roleType        =[[EAGallery sharedClass] getRoleType:[[resPonsedata objectForKey:LOGIN_ROLE_TYPE] intValue]];
                                        [EAGallery sharedClass].type            =[dic objectForKey:LOGIN_GOOGLE_PLUS] ? GooglePlus :Facebook;
                                        [EAGallery sharedClass].isLogin         =YES;
                                        
                                        if([dic objectForKey:LOGIN_GOOGLE_PLUS])
                                        
                                        [[EAGallery sharedClass] saveDataLocal];
                                        
                                        [[NSUserDefaults standardUserDefaults]setObject:[resPonsedata objectForKey:COUNTRY_LIST] forKey:COUNTRY_LIST];
                                        [[NSUserDefaults standardUserDefaults] synchronize];

                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                                
                                                [self.viewDeckController rightViewPushViewControllerOverCenterController:GET_VIEW_CONTROLLER(kViewController)];
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

#pragma mark - Forgot Password

-(void)forgotPasswordWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Forgot_Password);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                
                NSURL *url = [NSURL URLWithString:urlString];
                
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:postData];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
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
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:5.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                }
                                else if (error.boolValue) {
                                 
                                        
                                }
                                
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}



#pragma mark -Get Action from right nav buttons

-(IBAction)search:(id)sender{
        
        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
        [data setObject:@"artist" forKey:@"page"];
        
        BestSellingArtistsViewController* vc=GET_VIEW_CONTROLLER(kBestSellingArtistsViewController);
        vc.urlString=urlString;
        vc.urlData=[data mutableCopy];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        switch (section) {
                case 0:
                        rows=2;
                        break;
                case 1:
                        rows=1;
                        break;
                        
                default:
                        break;
        }
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        NSInteger height=0;
        switch (indexPath.section) {
                        
                case 0:
                        height=44.0f;
                        break;
                case 1:
                        height=126.0f;
                        break;
                        
                default:
                        break;
        }
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if(indexPath.section==0){
                
                NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                
                RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:13];
                cell.txtName.text=[arrTextData objectAtIndex:indexPath.row];
                
                cell.txtName.delegate=self;
                
                cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                
                if(IS_EMPTY([arrTextData objectAtIndex:indexPath.row]))
                        [Alert attributedString:cell.txtName
                                            msg:[item objectForKey:@"msg"]
                                          color:[item objectForKey:@"color"]];
                
                cell.txtName.tag=indexPath.row;
                cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                
                cell.txtName.secureTextEntry=indexPath.row==1 ? YES : NO;
                
                cell.txtName.keyboardType = indexPath.row==3 ? UIKeyboardTypePhonePad : UIKeyboardTypeDefault;
                
                [cell.txtName addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
                
                
                //Tint color
                cell.txtName.tintColor=[UIColor blackColor];
                
                cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                return cell;
                
        }
        
        else if (indexPath.section==1) {
                
                LoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.viContainerLogin.backgroundColor=[UIColor blackColor];
                
                [cell.btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

                [cell.btnFacebook addTarget:self action:@selector(loginWithFB:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnGoogle addTarget:self action:@selector(loginWithGl:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
        }
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}


#pragma Mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        
        [textField resignFirstResponder];
        
        
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.viContainerTitleBar.frame.size.height,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 180);
        }
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        
        return YES;
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
        
        
        
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
        
        RegistrationViewCell * cell;
        
        if(textField.tag==0 && !IS_EMPTY(textField.text)){
                //BOOL isEmail=[Alert validationEmail:textField.text];
                
//                if(NO){
//                        [Alert alertWithMessage:@"Invalid email id! Please enter valid email id."
//                                     navigation:self.navigationController
//                                       gotoBack:NO animation:YES];
//                        [textField becomeFirstResponder];
//                        
//                }
//                else{
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                        [cell.txtName becomeFirstResponder];
                        
//                }
        }
        else if(textField.tag==1 && !IS_EMPTY(textField.text)){
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
                
        }
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.viContainerTitleBar.frame.size.height,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-50);
                
                
                //                [UIView transitionWithView:self.tableView
                //                                  duration:0.3
                //                                   options:UIViewAnimationOptionTransitionCrossDissolve
                //
                //                                animations:nil
                //                                completion:nil];
        }
        
        isUpdateHeight=NO;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender{
        //        isUpdate=YES;
        //        //[self.btnUpdate setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        //
        //        //[Alert viewButtonCALayer:[UIColor grayColor] viewButton:self.btnUpdate];
        //        self.btnUpdate.backgroundColor=[UIColor orangeColor];
        //
        BOOL isValid=NO;
        //
        UITextField* txt=(UITextField*)sender;
//        if(txt.tag==0)
//                isValid=[Alert validationEmail:txt.text];
        
        
        if(txt.tag==0 || txt.tag==1) isValid=YES;
        
        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
        
        arrTextData[txt.tag]=txt.text;
        
}


#pragma mark - Google Plus Login

-(void)initiliseGooglePlus{
        
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
        
        // You previously set kClientId in the "Initialize the Google+ client" step
        signIn.clientID = kClientId;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        //        signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        // Optional: declare signIn.actions, see "app activities"
        signIn.delegate = self;
        
//        [signIn trySilentAuthentication];
//        [self refreshInterfaceBasedOnSignIn];
        [signIn authenticate];
        
                
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        if (error) {
                [[SharedClass sharedObject] hudeHide];
                // Do some error handling here.
                [self disconnect];
                
                
        } else {
                [self refreshInterfaceBasedOnSignIn];
                
        }
}

-(void)refreshInterfaceBasedOnSignIn {
        if ([[GPPSignIn sharedInstance] authentication]) {
                
               // NSLog(@"%@",signIn.userEmail);
                // The user is signed in.
                //self.signInButton.hidden = YES;
                // Perform other actions here, such as showing a sign-out button
                
                [self fetchUserInfo];
                
        } else {
                [[SharedClass sharedObject] hudeHide];
                //self.signInButton.hidden = NO;
                // Perform other actions here
                [self disconnect];
        }
}

-(void)fetchUserInfo{
        
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];

        
//        GTLQueryPlus *query =
//        [GTLQueryPlus queryForPeopleListWithUserId:@"me"
//                                        collection:kGTLPlusCollectionVisible];
//        [plusService executeQuery:query
//                completionHandler:^(GTLServiceTicket *ticket,
//                                    GTLPlusPeopleFeed *peopleFeed,
//                                    NSError *error) {
//                        if (error) {
//                                GTMLoggerError(@"Error: %@", error);
//                        } else {
//                                // Get an array of people from GTLPlusPeopleFeed
//                                NSArray* peopleList = peopleFeed.items;
//                                
//                                NSLog(@"%@",peopleList);
//                        }
                //}];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
//                        [[SharedClass sharedObject] hudeHide];
                        
                        if (error) {
                                GTMLoggerError(@"Error: %@", error);
                                
                        } else {
                                // Retrieve the display name and "about me" text
                                //[person retain];
                                NSString* name=person.displayName;
                                NSArray* arr=[person.emails valueForKeyPath:@"value"];
                                NSString* email=arr.count ? [arr firstObject] : @"";
                                
                                NSString* image=person.image.url;
                                NSString* ID=person.identifier;
                                
                                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                                
                                [dic setObject:email                    forKey:@"email"];
                                [dic setObject:name                     forKey:@"name"];
                                [dic setObject:LOGIN_GOOGLE_PLUS        forKey:@"type"];
                                [dic setObject:ID                       forKey:@"app_id"];
                                [dic setObject:image                    forKey:@"pimage"];
                                
                                [self socialLoginWebService:[dic mutableCopy]];
                                
                                
                        }
                }];
}

- (void)disconnect {
        [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
        if (error) {
                NSLog(@"Received error %@", error);
        } else {
                // The user is signed out and disconnected.
                // Clean up user data as specified by the Google+ terms.
        }
}

-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
        
        
}



#pragma mark- Google Plus via UIWebview
/*
-(IBAction)doretrive{
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        
        [plusService setAuthorizer:self.auth];//!!!here use our authentication object!!!
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                        if (error) {
                                GTMLoggerError(@"Error: %@", error);
                        } else {
                                // Retrieve the display name and "about me" text
//                                [person retain];
                                NSString *description = [NSString stringWithFormat:
                                                         @"%@\n%@\n%@", person.displayName,
                                                         person.aboutMe,person.emails];
//                                [profileTextView setText:description];
                                NSLog(@"%@",description);
                        }
                }];
}

- (void)auth:(GTMOAuth2Authentication *)auth finishedRefreshWithFetcher:(GTMHTTPFetcher *)fetcher error:(NSError *)error {
        [self viewController:nil finishedWithAuth:auth error:error];
        if (error != nil) {
                // Refresh failed
                NSLog(@"Authentication Error %@", error.localizedDescription);
                self.auth=nil;
                return;
        }
        self.auth=auth;
        
        [self doretrive];//
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{
        if (error != nil) {
                // Authentication failed
                NSLog(@"Authentication Error %@", error.localizedDescription);
                self.auth=nil;
                return;
        }
        self.auth=auth;
        [self doretrive];//
//        [viewController release];//no ARC
}

-(IBAction)dologin{
        NSString *scope = kGTLAuthScopePlusLogin;//Google+ scope
        GTMOAuth2Authentication * auth = [GTMOAuth2ViewControllerTouch
                                          authForGoogleFromKeychainForName:kKeychainItemName
                                          clientID:kClientID
                                          clientSecret:kClientSecret];
        if ([auth refreshToken] == nil) {
                GTMOAuth2ViewControllerTouch *authController;
                authController = [[GTMOAuth2ViewControllerTouch alloc] 
                                  initWithScope:scope 
                                  clientID:kClientID 
                                  clientSecret:kClientSecret  
                                  keychainItemName:kKeychainItemName
                                  delegate:self
                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
                [[self navigationController] pushViewController:authController animated:YES];
        }else{
                [auth beginTokenFetchWithDelegate:self didFinishSelector:@selector(auth:finishedRefreshWithFetcher:error:)];
        }
}
*/




#pragma mark - Facebook Login

-(void)loginWithFacebook{
        
        
        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        // Handle clicks on the button
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: SCOPE_FACEBOOK
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
                 if (error) {
                         NSLog(@"Process error");
                         [[SharedClass sharedObject] hudeHide];
                 } else if (result.isCancelled) {
                         NSLog(@"Cancelled");
                         
                         [[SharedClass sharedObject] hudeHide];
                 } else {
                         NSLog(@"Logged in");
                         
                         if ([FBSDKAccessToken currentAccessToken]) {
                                 [[[FBSDKGraphRequest alloc] initWithGraphPath:REQUEST_PARAM_FACEBOOK parameters:nil]
                                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                          [[SharedClass sharedObject] hudeHide];
                                          
                                          if(error){
                                          }
                                          else{
                                                  NSLog(@"fetched user:%@", result);
                                                  
                                                  NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                                                  
                                                  [dic setObject:[result objectForKey:@"email"] forKey:@"email"];
                                                  [dic setObject:[result objectForKey:@"name"]  forKey:@"name"];
                                                  [dic setObject:LOGIN_FACEBOOK                 forKey:@"type"];
                                                  [dic setObject:[result objectForKey:@"id"]    forKey:@"app_id"];
                                                  [dic setObject:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"] forKey:@"pimage"];
                                                  
                                                  [self socialLoginWebService:[dic mutableCopy]];
                                                  
                                                  //{"type":"Google_Plus",
                                                  //                                                  "name":"raj",
                                                  //                                                  "email":"yogesh20.kumar@gmail.com",
                                                  //                                                  "app_id":"",
                                                  //                                                  "pimage":"profile image url"}
                                                  
                                                  
                                          }
                                          
                                  }];
                         }
                         else {
                                 [[SharedClass sharedObject] hudeHide];
                         }
                         
                 }
         }];
}

#pragma mark - UIAlert Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        
        
        if (alertView.tag == 100) {
                if(buttonIndex==0){
                        //Cancel
                        
                }
                if(buttonIndex==1){
                        //Apply
                        
                        
                        NSString* email=[Alert trimSpaces:[alertView textFieldAtIndex:0].text];
                        bool isEmail=[Alert validationEmail:email];
                        NSLog(@"Entered Email Id : %@",email);
                        
                        if(!IS_EMPTY(email) && isEmail){
                                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                                
                                [dic setObject:email forKey:@"email"];
                                [self forgotPasswordWebService:[dic mutableCopy]];
                                
                        }
                        else{
                                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@""
                                                                                    message:@"Please enter valid email id !"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                [alertView show];
                        }
                        
                        
                }
        }
}

#pragma mark - Action Methods

-(IBAction)login:(id)sender {
        
        //NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:0];
        
        if(!IS_EMPTY([arrTextData objectAtIndex:0]) &&
           !IS_EMPTY([arrTextData objectAtIndex:1])){
                
                //BOOL isEmail=[Alert validationEmail:[arrTextData objectAtIndex:0]];
                
//                if (NO){
//                        [Alert alertWithMessage:@"Invalid email id! Please enter valid email id."
//                                     navigation:self.navigationController
//                                       gotoBack:NO animation:YES];
//                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                        return;
//                        
//                }
//                else
//                {
                        //{"email":"deepak","password":"123","device_type":"iOS/ANDROID","device_id":"12345678"}
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:[arrTextData objectAtIndex:0] forKey:@"email"];
                        [dic setObject:[arrTextData objectAtIndex:1] forKey:@"password"];
                        [dic setObject:DEVICE_TYPE                   forKey:@"device_type"];
                        [dic setObject:@""                           forKey:@"device_id"];
                        
                        
                        [self getWebService:[dic mutableCopy]];
//                }
        }
        else
        {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Fields can not be blank !"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil]show];
                
                
        }
        
        
        
}

-(IBAction)loginWithFB:(id)sender {
        
        
        [self loginWithFacebook];
}

-(IBAction)loginWithGl:(id)sender {
        
        isGooglePlus=YES;
        
//       [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
        
        [self initiliseGooglePlus];
        
}


- (IBAction)forgotPassword:(id)sender {
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Forgot Password"
                                                    message:@"Please enter email id !"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Apply", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        av.tag=100;
        [av textFieldAtIndex:0].delegate = self;
        [av show];

        
}

- (IBAction)registration:(id)sender {
        
        RegistrationViewController*vc=GET_VIEW_CONTROLLER_STORYBOARD(kRegistrationViewController);
        vc.titleString=@"Sign up";
        //vc.from=@"back";        
        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
}

@end