//
//  DashboardViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 13/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "DashboardViewController.h"
//#import "TabViewController.h"
#import "MyAccountViewController.h"
#import "UpdateProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyOrderViewController.h"
#import "BecomeASellerViewController.h"
#import "AddArtViewController.h"
#import "ManageArtViewController.h"
#import "ReceivedOrderViewController.h"
#import "CancelOrderViewController.h"
#import "EarningReportViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"

@interface DashboardViewController ()
{
        UIActivityIndicatorView *activityIndicator;
        NSMutableArray* arrWithArtist;
        NSMutableArray* arrWithoutArtist;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        THSegmentedPager* vcTab;
}

@end

@implementation DashboardViewController


#pragma mark - View controller life cicle


- (void)viewDidLoad {
   
        [super viewDidLoad];
        
        [self setNotification];
        
        [self addChildView];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        
        if(YES)
        {
                
                //[self setActivityIndicator];
                
                //                [self getWebService];
        }
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];

        [self loadCardCount];
        
        
        
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateView" object:nil];
}



#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.lblTitle.text=[self.titleString uppercaseString];
        self.viContainerTitleBar.hidden=YES;
        
//        [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//        
//        [[UINavigationBar appearance] setTranslucent:NO];
        
        
//        [self.navigationController setValue:[[MSSTabNavigationBar alloc]init]forKeyPath:@"navigationBar"];

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
        
        //[self.tableView registerClass:[ArtistDetailViewCell2 class] forCellReuseIdentifier:CellIdentifier1];
        //        [self.tableView registerClass:[ArtistDetailViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        //        //        [self.tableView registerClass:[ArtDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        //
       // UINib *contantsCellNib1 = [UINib nibWithNibName:@"ArtistDetailViewCell2" bundle:nil];
        //[self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        //
        //        UINib *contantsCellNib2 = [UINib nibWithNibName:@"ArtistDetailViewCell2" bundle:nil];
        //        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
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
        //[self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
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
        
        //self.tableView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)removeBackgroundLabel{
        //self.tableView.backgroundView = nil;
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
        //[rightView addSubview:dotView];
        
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

#pragma mark - Set up tabs

-(void)addChildView{
        
         vcTab=GET_VIEW_CONTROLLER(kTHSegmentedPager);
        
        NSArray* pages=[[self getPages] mutableCopy];
        
        if(pages.count){
                [vcTab setPages:[pages mutableCopy]];
//                vc.selectedIndexCustom=self.selectedIndex;
                
                [self addChildViewController:vcTab];
                
                [self.view addSubview:vcTab.view];
                [vcTab didMoveToParentViewController:self];
        }
        
        
        
        
}

-(void)removeChildView{
        
        [vcTab willMoveToParentViewController:nil];
        [vcTab.view removeFromSuperview];
        [vcTab removeFromParentViewController];

}

-(void)loadData{
        arrWithArtist=[[NSMutableArray alloc]init];//Artist
        arrWithoutArtist=[[NSMutableArray alloc]init];//Not Artist
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        //Not Artist
        {
                [dic setObject:@"My Account" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"0" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Update Profile" forKey:@"title"];
                [dic setObject:kUpdateProfileViewController forKey:@"vc"];
                [dic setObject:@"1" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Change Your Password" forKey:@"title"];
                [dic setObject:kChangePasswordViewController forKey:@"vc"];
                [dic setObject:@"2" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Become a seller" forKey:@"title"];
                [dic setObject:kBecomeASellerViewController forKey:@"vc"];
                [dic setObject:@"3" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"My Order" forKey:@"title"];
                [dic setObject:kMyOrderViewController forKey:@"vc"];
                [dic setObject:@"4" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
        }
        
        //Artist
        {
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"My Account" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"0" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Add Art" forKey:@"title"];
                [dic setObject:kAddArtViewController forKey:@"vc"];
                [dic setObject:@"1" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Manage Art" forKey:@"title"];
                [dic setObject:kManageArtViewController forKey:@"vc"];
                [dic setObject:@"2" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Earning Report" forKey:@"title"];
                [dic setObject:kEarningReportViewController forKey:@"vc"];
                [dic setObject:@"3" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Receive Order" forKey:@"title"];
                [dic setObject:kReceivedOrderViewController forKey:@"vc"];
                [dic setObject:@"4" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Cancel Order" forKey:@"title"];
                [dic setObject:kCancelOrderViewController forKey:@"vc"];
                [dic setObject:@"5" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Update Profile" forKey:@"title"];
                [dic setObject:kUpdateProfileViewController forKey:@"vc"];
                [dic setObject:@"6" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Change Your Password" forKey:@"title"];
                [dic setObject:kChangePasswordViewController forKey:@"vc"];
                [dic setObject:@"7" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"My Order" forKey:@"title"];
                [dic setObject:kMyOrderViewController forKey:@"vc"];
                [dic setObject:@"8" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                
        }

}

-(NSArray*)getPages{
        
        [self loadData];
        
        NSArray* arr=[Alert getSortedList:[[EAGallery sharedClass] roleType]==BecomeAnArtist ? arrWithArtist : arrWithoutArtist key:@"sort" ascending:YES];
        
        NSInteger count=[[EAGallery sharedClass] roleType]==BecomeAnArtist ?
        arrWithArtist.count : arrWithoutArtist.count;
        NSMutableArray *pages = [NSMutableArray new];
        
        for (NSInteger i = 0; i < count; i++) {
                
                NSDictionary* dic=arr[i];
                NSString* vcName=[dic objectForKey:@"vc"];
                
                if([vcName isEqualToString:kMyAccountViewController]){
                        MyAccountViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kUpdateProfileViewController]){
                        UpdateProfileViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kChangePasswordViewController]){
                        ChangePasswordViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kMyOrderViewController]){
                        MyOrderViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kBecomeASellerViewController]){
                        BecomeASellerViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kAddArtViewController]){
                        AddArtViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kManageArtViewController]){
                        ManageArtViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kReceivedOrderViewController]){
                        ReceivedOrderViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kCancelOrderViewController]){
                        CancelOrderViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                else if([vcName isEqualToString:kEarningReportViewController]){
                        EarningReportViewController* vc=GET_VIEW_CONTROLLER(vcName);
                        vc.viewTitle= [dic objectForKey:@"title"];
                        
                        [pages addObject:vc];
                }
                
                
                
        }

        
        return pages;
}


-(void)setNotification{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"updateView"
                                                   object:nil];
}


#pragma mark - Call Notification

- (void)receiveNotification:(NSNotification *) notification{
        
        
        if ([[notification name] isEqualToString:@"updateView"]){
                [self removeChildView];
                [self addChildView];
                
              
        }
        
        
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


@end
