//
//  MyAccountViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountViewCell1.h"
#import "MyAccountViewCell2.h"
#import "MyAccountViewCell3.h"
#import "MyAccountViewCell4.h"
#import "CustomWebViewController.h"


#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"
#define COLOR_CELL_TEXT1        @"#150F0F"
#define COLOR_CELL_TEXT_LINK    @"#BD5B5F"
#define STATUS_IMAGE_ENABLE     @"review_enable.png"
#define STATUS_IMAGE_DISABLE    @"review_disable.png"

@interface MyAccountViewController ()<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSDictionary*resPonsedata;
        NSString* agreementString;
        NSString* orderCount;
        NSString* reviewCount;
        NSArray* arrReviews;
        NSString* selectedID;
        NSMutableArray* arrHeaderTitle;
}

@end

@implementation MyAccountViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";

#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        [self cellRegister];
    
        [self config];
        
        
        /*[self setLogoImage];
        
        //[self rightNavBarConfiguration];
        
        if(YES)
        {
                
                //[self setActivityIndicator];
                
                //                [self getWebService];
        }
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
         */
}

- (void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];

        arrReviews=nil;
        resPonsedata=nil;
        [self removeActivityIndicatorAll];
        [self removeBackgroundLabel];
        [self setActivityIndicator];
        [self.tableView reloadData];
        
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"member_id"];
        [self getWebService:dic];
        
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

-(void)config{
        
        arrHeaderTitle=[[NSMutableArray alloc]init];
        [arrHeaderTitle addObject:@""];
        [arrHeaderTitle addObject:@""];
        [arrHeaderTitle addObject:@"Users Review"];
        
        //self.lblTitle.text=[self.titleString uppercaseString];
       // self.viContainerTitleBar.hidden=YES;
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
//        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];

        
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
        
        [self.tableView registerClass:[MyAccountViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[MyAccountViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[MyAccountViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[MyAccountViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        //
        UINib *contantsCellNib1 = [UINib nibWithNibName:[Alert getClassNameFromObject:MyAccountViewCell1.self] bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        //
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"MyAccountViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        //
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"MyAccountViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"MyAccountViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
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
        //[self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
}

-(void)removeActivityIndicator{
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

-(void)removeActivityIndicatorAll{
        
        for (UIView* view in self.view.subviews) {
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
}

-(void)setBackgroundLabel{
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data found";
        messageLabel.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
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

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
        
        
        if ([[url scheme] hasPrefix:@"action"]) {
                if ([[url host] hasPrefix:@"Open"]) {
                        
                        NSLog(@"Click here ");
                        
                        if(!IS_EMPTY(agreementString)){
                        
                                CustomWebViewController* vc=GET_VIEW_CONTROLLER(kWebViewController);
                                vc.titleString=@"Artist Agreement";
                                vc.htmlString=agreementString;
                                vc.from=@"back";
                                [Alert performBlockWithInterval:0.30 completion:^{
                                        
                                        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                                }];
                        }
                        
                        /* load help screen */
                } else if ([[url host] hasPrefix:@"show-settings"]) {
                        /* load settings screen */
                }
        } else {
                /* deal with http links here */
        }
}


#pragma mark -Call WebService

-(void)getWebService:(NSDictionary*)dic{
        
       
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_MyAccount);
                
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
                        //[[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [self removeActivityIndicatorAll];
                                [self setBackgroundLabel];
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
                                [self removeActivityIndicatorAll];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self setBackgroundLabel];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self removeBackgroundLabel];
                                        });
                                        
                                        result=[Alert removedNullsWithString:@"" obj:result];
                                        
                                        //user info
                                        NSDictionary* dic=(NSDictionary*)[result valueForKey:@"user"];
                                        resPonsedata = [Alert dictionaryByReplacingNullsWithString:@"" dic:dic];
                                        
                                        //Order
                                        NSArray*resPageArr = (NSArray*)[result valueForKey:@"page1"];
                                        orderCount=(NSString*)[result valueForKey:@"Ordercount"];
                                        reviewCount=(NSString*)[result valueForKey:@"Reviewcount"];
                                        //Desc
                                        NSDictionary* page=resPageArr.count ? resPageArr[0] : nil;
                                        agreementString = [page objectForKey:@"description"];
                                        
                                        //Reviews
                                        arrReviews = (NSArray*)[result valueForKey:@"review"];
                                        
                                        
                                        if(resPonsedata){
                                                [EAGallery sharedClass].registeredOn    =[resPonsedata objectForKey:LOGIN_ADDED_ON];
                                                [EAGallery sharedClass].name            =[resPonsedata objectForKey:LOGIN_NICK_NAME];
                                                [EAGallery sharedClass].userName        =[resPonsedata objectForKey:LOGIN_USER_NAME];
                                                [EAGallery sharedClass].email           =[resPonsedata objectForKey:LOGIN_EMAIL];
                                                [EAGallery sharedClass].country         =[resPonsedata objectForKey:LOGIN_COUNTRY];
                                                [EAGallery sharedClass].phone           =[resPonsedata objectForKey:LOGIN_PHONE];
                                                [EAGallery sharedClass].profileImage    =[resPonsedata objectForKey:LOGIN_PROFILE_IMAGE];
                                                [EAGallery sharedClass].coverImage      =[resPonsedata objectForKey:LOGIN_COVER_IMAGE];
                                                [EAGallery sharedClass].bio             =[resPonsedata objectForKey:LOGIN_BIO];
                                                [EAGallery sharedClass].walletAmount    =[resPonsedata objectForKey:LOGIN_WALLET_AMOUNT];
                                                [EAGallery sharedClass].roleType        =[[EAGallery sharedClass] getRoleType:[[resPonsedata objectForKey:LOGIN_ROLE_TYPE] intValue]];
                                                
                                                [[EAGallery sharedClass] saveDataLocal];
                                        }
                                        else{
                                                [[EAGallery sharedClass]removeUserDetail];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [Alert alertWithMessage:@"Something went wrong ! User not exist."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES second:3.0];
                                                        
                                                        DashboardViewController*vc=GET_VIEW_CONTROLLER(kDashboardViewController);
                                                        vc.titleString=@"Dashboard";
                                                        
                                                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                                                        return ;
                                                });
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [UIView transitionWithView:self.tableView
                                                                  duration:0.3
                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                 
                                                                animations:nil
                                                                completion:nil];
                                                
                                                
                                                
                                                [self.tableView reloadData];
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self setBackgroundLabel];
                                        });
                                }
                                else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self setBackgroundLabel];
                                        });
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

-(void)changeStatusWebService:(NSDictionary*)dic{
        
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ReviewStatus);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                // NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                
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
//                                [self removeActivityIndicator];
//                                [self setBackgroundLabel];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
//                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
//                                        [self setBackgroundLabel];
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
                                                       gotoBack:NO animation:YES second:2.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                        //Reviews
                                        NSArray* review = (NSArray*)[result valueForKey:@"review"];
                                
                                        if([review isKindOfClass:[NSArray class]]){
                                                arrReviews=[review mutableCopy];
                                        }
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [UIView transitionWithView:self.tableView
                                                                  duration:0.3
                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                 
                                                                animations:nil
                                                                completion:nil];
                                                
                                                
                                                
                                                [self.tableView reloadData];
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                                [self setBackgroundLabel];
//                                        });
                                }
                                else{
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                                [self setBackgroundLabel];
//                                        });
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

-(void)deleteReviewWebService:(NSDictionary*)dic{
        
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ReviewDelete);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                // NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                
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
                                //                                [self removeActivityIndicator];
                                //                                [self setBackgroundLabel];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                //                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        //                                        [self setBackgroundLabel];
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
                                                       gotoBack:NO animation:YES second:2.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                        //Reviews
                                        //arrReviews = (NSArray*)[result valueForKey:@"review"];
                                        
                                        arrReviews=[self removeSelectedReview:selectedID];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [UIView transitionWithView:self.tableView
                                                                  duration:0.3
                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                 
                                                                animations:nil
                                                                completion:nil];
                                                
                                                
                                                
                                                [self.tableView reloadData];
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


-(NSArray*)removeSelectedReview:(NSString*)ID{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != %@",ID];
        NSArray *filtered = [arrReviews filteredArrayUsingPredicate:predicate];
        
        return filtered.count ? filtered : nil;
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
                CGRect rect = CGRectMake(0,0,320,44);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        
        return result;
        
}

#pragma Mark Navigation Bar Configuration Code

-(void)navigationBarConfiguration{
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setBackgroundImage:[[self setNavBarImage]
                                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch]
                                                      forBarMetrics:UIBarMetricsDefault];
        UIButton * menuButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        menuButton.frame = CGRectMake(8, 20, 24, 18);
        [menuButton setBackgroundImage:[UIImage imageNamed:MENU_IMAGE] forState:UIControlStateNormal];
        
        //    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *accountBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        self.navigationItem.leftBarButtonItem = accountBarItem;
        //[self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTranslucent:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        switch (section) {
                case 0:
                        rows=1;
                        break;
                case 1:
                        rows=1;
                        break;
                case 2:
                        rows=arrReviews.count;
                        break;
                        
                default:
                        break;
        }
        
        
        return resPonsedata ? rows : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        
        switch (indexPath.section) {
                case 0:
                        finalHeight=181;
                        
                        break;
                case 1:
                        finalHeight= ([[EAGallery sharedClass] roleType]==BecomeAnArtist) ? 225 : 174.0f;
                        break;
                case 2:
                        {
                        
                                float defaultHeight=42.0f;
                                UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(43, 0, self.tableView.frame.size.width-51, 20)];
//                                label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:11];
                                label.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];

                                NSDictionary* dic=[arrReviews objectAtIndex:indexPath.row];
                                label.text=[dic objectForKey:@"review"];
                                label.textAlignment=NSTextAlignmentLeft;
                                label.backgroundColor=[UIColor yellowColor];
                                float height=[Alert getLabelHeight:label];
                                
                                finalHeight=height+5+ defaultHeight;
                
                        }
                        break;
                
                default:
                        break;
        }
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        switch (indexPath.section) {
                case 0:
                        {
                        MyAccountViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        NSURL* url=[NSURL URLWithString:IS_EMPTY([[EAGallery sharedClass] profileImage]) ? nil :[[EAGallery sharedClass] profileImage]];
                                
//                                NSString* urlString=@"http://presscity.com/api/showimage.cfm?id=178989&machineid=36371&width=60&customerid=17&apikey=98ECF1BECBA1EA9EF4744651C80AC592";
//                                
//                                NSURL* url=[NSURL URLWithString:urlString];
                        
                        for (id view in cell.contentView.subviews) {
                                
                                if([view isKindOfClass:[UIActivityIndicatorView class]])
                                        [view removeFromSuperview];
                        }

                        
                        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        activityIndicator1.frame = CGRectMake(cell.viContainerImage.frame.size.width/2-15,
                                                             cell.viContainerImage.frame.size.height/2-15,
                                                             30,
                                                             30);
                        [activityIndicator1 startAnimating];
                        activityIndicator1.tag=indexPath.row;
                        
                        [activityIndicator1 removeFromSuperview];
                        if(url){
                                [cell.viContainerImage addSubview:activityIndicator1];
                                [cell.viContainerImage insertSubview:activityIndicator1 aboveSubview:cell.img];
                        }
                        
                        
                        cell.img.backgroundColor=[UIColor whiteColor];
//                        cell.viContainerImage.backgroundColor=[UIColor grayColor];
                        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
                        
                        __weak UIImageView *weakImgPic = cell.img;
                        [cell.img setImageWithURL:url
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
                                                 completion:^(BOOL finish){
                                                 }];
                         } failure:NULL];
                        
                                
                        cell.lblWalletAmount.text=[NSString stringWithFormat:@"Wallet : $ %@",[EAGallery sharedClass].walletAmount];
                         
                        cell.btnAddMoneyToWallet.tag=indexPath.row;
                        [cell.btnAddMoneyToWallet addTarget:self action:@selector(addMoneyToWallet:) forControlEvents:UIControlEventTouchUpInside];
                        
                        return cell;
                }
                        break;
                case 1:
                        
                        {
                        if([[EAGallery sharedClass] roleType]==BecomeAnArtist){
                                MyAccountViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                                cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                
                                cell.lblNameValue.text          = [[EAGallery sharedClass] name];
                                cell.lblPhoneValue.text         = [[EAGallery sharedClass] phone];
                                cell.lblCountryValue.text       = [[EAGallery sharedClass] country];
                                cell.lblTotalOrderValue.text    = [NSString stringWithFormat:@"%@",orderCount];
                                cell.lblUserNameValue.text      = [[EAGallery sharedClass] userName];
                                cell.lblTotalReviewValue.text   =  [NSString stringWithFormat:@"%@",reviewCount];
                                cell.lblEmailValue.text         = [[EAGallery sharedClass] email];
                                
                                //Agreement label
                                cell.lblAgreementValue.delegate=self;
                                NSURL *url = [NSURL URLWithString:@"action://Open"];
                                UIColor* color2=[Alert colorFromHexString:COLOR_CELL_TEXT_LINK];
                                cell.lblAgreementValue.linkAttributes = @{(id)kCTForegroundColorAttributeName: color2,
                                                                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                NSString* clickHere=@"Click here";
                                NSRange r = [cell.lblAgreementValue.text rangeOfString:clickHere];
                                [cell.lblAgreementValue addLinkToURL:url withRange:r];
                                
                                
                                return cell;
                        }
                        else{
                                
                                MyAccountViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                
                                cell.lblNameValue.text          = [[EAGallery sharedClass] name];
                                cell.lblPhoneValue.text         = [[EAGallery sharedClass] phone];
                                cell.lblUserNameValue.text      = [[EAGallery sharedClass] userName];
                                cell.lblCountryValue.text       = [[EAGallery sharedClass] country];
                                cell.lblEmailValue.text         = [[EAGallery sharedClass] email];
                                
                                //Agreement label
                                cell.lblAgreementValue.delegate=self;
                                NSURL *url = [NSURL URLWithString:@"action://Open"];
                                UIColor* color2=[Alert colorFromHexString:COLOR_CELL_TEXT_LINK];
                                cell.lblAgreementValue.linkAttributes = @{(id)kCTForegroundColorAttributeName: color2,
                                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                NSString* clickHere=@"Click here";
                                NSRange r = [cell.lblAgreementValue.text rangeOfString:clickHere];
                                [cell.lblAgreementValue addLinkToURL:url withRange:r];
                                
                                
                                return cell;
                        }
                }
                        
                        break;
                case 2:
                        {
                                MyAccountViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                cell.viContainerText.translatesAutoresizingMaskIntoConstraints=
                                cell.viContainerButton.translatesAutoresizingMaskIntoConstraints=
                                cell.lblReview.translatesAutoresizingMaskIntoConstraints=YES;
                                
                                NSDictionary* dic=[arrReviews objectAtIndex:indexPath.row];
                                
                                cell.btnStatus.tag=indexPath.row;
                                cell.btnDelete.tag=indexPath.row;
                                cell.lblSno.text=[@(indexPath.row+1) stringValue];
                                cell.lblReview.text=[dic objectForKey:@"review"];
                                float height=[Alert getLabelHeight:cell.lblReview];
                                
                                //Review Label
                                CGRect reviewFrame=cell.lblReview.frame;
                                reviewFrame.size.height=height+5;
                                cell.lblReview.frame=reviewFrame;
//                                cell.lblReview.backgroundColor=[UIColor yellowColor];
                                
                                
                                //Text Container
                                cell.viContainerText.frame=CGRectMake(cell.viContainerText.frame.origin.x,
                                                                      cell.viContainerText.frame.origin.y,
                                                                      cell.viContainerText.frame.size.width,
                                                                      reviewFrame.size.height+8+4);
                                
//                                cell.viContainerText.backgroundColor=[UIColor grayColor];
                                //Button container
                                cell.viContainerButton.frame=CGRectMake(cell.viContainerButton.frame.origin.x,
                                                                      cell.viContainerText.frame.origin.y+cell.viContainerText.frame.size.height,
                                                                      cell.viContainerButton.frame.size.width,
                                                                      cell.viContainerButton.frame.size.height);
                                
//                                cell.viContainerButton.backgroundColor=[UIColor greenColor];
                                
                                
                                
                                int status=[[dic objectForKey:@"status"] intValue];
                                cell.imgStatus.image=[UIImage imageNamed:status ? STATUS_IMAGE_ENABLE : STATUS_IMAGE_DISABLE];
                                
                                [cell.btnStatus addTarget:self action:@selector(status:) forControlEvents:UIControlEventTouchUpInside];
                                [cell.btnDelete addTarget:self action:@selector(deleteStatus:) forControlEvents:UIControlEventTouchUpInside];
                                
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
        //        NSDictionary *sectionData = [arrHeaderTitle objectAtIndex:section];
        NSString *header = [arrHeaderTitle objectAtIndex:section];
        return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        //Header View
        UIView *headerView = [[UIView alloc] init];
//        headerView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        headerView.backgroundColor=[UIColor whiteColor];
        
        //Header Title
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, tableView.frame.size.width, 20);
//        title.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:15];
        title.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:14];

        title.text = [self tableView:tableView titleForHeaderInSection:section];
        title.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT1];
        title.textAlignment=NSTextAlignmentCenter;
//        title.backgroundColor=[UIColor grayColor];
        [headerView addSubview:title];
        
        UILabel *desc = [[UILabel alloc] init];
        desc.frame = CGRectMake(15, title.frame.size.height, tableView.frame.size.width-30, 20);
 //       desc.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
        desc.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];

//        desc.text = [self tableView:tableView titleForHeaderInSection:section];
        desc.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT1];
        desc.textAlignment=NSTextAlignmentLeft;
//        desc.backgroundColor=[UIColor grayColor];
        [headerView addSubview:desc];
        
        switch (section) {
                case 2:
                        desc.text=@"S No  Review";
                        break;
                        
                default:
                        desc.text=@"";
                        break;
        }
        
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        NSInteger height=0;
        switch (section) {
                case 0:
                        height= 0;
                        break;
                case 1:
                        height= 0;
                        break;
                case 2:
                        height= arrReviews.count ? 40 :0;
                        break;
                        
                default:
                        break;
        }
        
        
        return height;
}

#pragma mark - Action Methods

-(IBAction)status:(id)sender{
        UIButton* button=(UIButton*)sender;
        NSDictionary* dic=[arrReviews objectAtIndex:button.tag];
        int status=[[dic objectForKey:@"status"] intValue];
        
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
        [data setObject:[[EAGallery sharedClass] memberID]      forKey:@"member_id"];
        [data setObject:[dic objectForKey:@"id"]                forKey:@"id"];
        [data setObject:@(!status)                              forKey:@"status"];
        
        
        [self changeStatusWebService:data];
        
//        {"id":"6","status":"1","member_id":"92"}
        
}

-(IBAction)deleteStatus:(id)sender{
        
        UIButton* button=(UIButton*)sender;
        NSDictionary* dic=[arrReviews objectAtIndex:button.tag];
        
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
        selectedID=[dic objectForKey:@"id"];
        if(selectedID){
                [data setObject:selectedID      forKey:@"id"];
                
        [self deleteReviewWebService:data];
                
//                arrReviews=[self removeSelectedReview:selectedID];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                        [UIView transitionWithView:self.tableView
//                                          duration:0.3
//                                           options:UIViewAnimationOptionTransitionCrossDissolve
//                         
//                                        animations:nil
//                                        completion:nil];
//                        
//                        
//                        
//                        [self.tableView reloadData];
//                });
        }

        
}

-(IBAction)addMoneyToWallet:(id)sender{
        
        //Add Money to wallet
        
        AddAmountViewController* vc=GET_VIEW_CONTROLLER(kAddAmountViewController);
        vc.from=@"back";
        MOVE_VIEW_CONTROLLER(vc, YES);
        
        
}



@end
