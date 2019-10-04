//
//  BlogViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 09/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "BlogViewController.h"
#import "BlogViewCell.h"
#import "BlogDetailsViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
//#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#777575"
#define COLOR_CELL_TITLE        @"#840F16"
#define IMAGE_BLOG_HEIGHT       165.0f
#define CELL_BLOG_HEIGHT        323.0f
#define CELL_BLOG_CONTAINER_HEIGHT  299.0f


@interface BlogViewController ()<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        NSInteger lastPageNumber;
        __weak BlogViewController* weakSelf;
        UIScrollView *_scrollView;
}
@property (nonatomic, assign) CGFloat numberOfRows;
@property (nonatomic, assign) CGFloat totalRecords;

@end

@implementation BlogViewController

static NSString *CellIdentifier1 = @"Cell1";

#pragma mark - View controller life cicle


- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self config];
        
        [self setPaginationSetup];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        
        if(!_arrBLogs.count)
        {
                
                [self setActivityIndicator];
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:[@(lastPageNumber) stringValue]          forKey:@"page"];
                [self getWebService:[dic mutableCopy]];
        }
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];

}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        self.navigationController.navigationBarHidden=NO;
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

#pragma mark - Custom Methods

-(void)config{
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
#endif
        
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
        
        [self.tableView registerClass:[BlogViewCell class] forCellReuseIdentifier:CellIdentifier1];
        //        [self.tableView registerClass:[ArtistDetailViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        //        //        [self.tableView registerClass:[ArtDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        //
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"BlogViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
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

#pragma mark - Set Pagnation setup

-(void)setPaginationSetup{
        
        self.numberOfRows = 0;
        
        if (self.style == INSPullToRefreshStylePreserveContentInset) {
                self.tableView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 100.0f, 0.0f);
        }
        
        //    self.automaticallyAdjustsScrollViewInsets = NO;
        //    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
                int64_t delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [scrollView ins_endPullToRefresh];
                });
        }];
        
        self.tableView.tableFooterView = [[UIView alloc] init];
        
        self.tableView.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
        if (self.style == INSPullToRefreshStylePreserveContentInset) {
                self.tableView.ins_pullToRefreshBackgroundView.preserveContentInset = YES;
        }
        
        if (self.style == INSPullToRefreshStyleText) {
                self.tableView.ins_pullToRefreshBackgroundView.dragToTriggerOffset = 60.0;
        }
        
        weakSelf = self;
        
        [self.tableView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
                
                int64_t delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        _scrollView=scrollView;
                        if(_totalRecords>_arrBLogs.count){
                                lastPageNumber++;
                                
                                [self callWebService];
                        }
                        else{
                                scrollView.ins_infiniteScrollBackgroundView.enabled = NO;
                        }

                        
                        
                        /*
                        [weakSelf.tableView beginUpdates];
                        
                        weakSelf.numberOfRows += 15;
                        NSMutableArray* newIndexPaths = [NSMutableArray new];
                        
                        for(NSInteger i = weakSelf.numberOfRows - 15; i < weakSelf.numberOfRows; i++) {
                                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                [newIndexPaths addObject:indexPath];
                        }
                        
                        [weakSelf.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                        
                        [weakSelf.tableView endUpdates];
                        
                        [scrollView ins_endInfinityScrollWithStoppingContentOffset:YES];
                        
                        if (weakSelf.numberOfRows > 30) {
                                // Disable infinite scroll after 45 rows
                                scrollView.ins_infiniteScrollBackgroundView.enabled = NO;
                        }
                         
                         */
                });
        }];
        
        UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
        [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
        [infinityIndicator startAnimating];
        
        self.tableView.ins_infiniteScrollBackgroundView.preserveContentInset = NO;
        
        if (self.style == INSPullToRefreshStylePreserveContentInset) {
                self.tableView.ins_infiniteScrollBackgroundView.preserveContentInset = YES;
        }
        
        UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
        self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
        [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
        
        if (self.style == INSPullToRefreshStyleText) {
                pullToRefresh.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                pullToRefresh.translatesAutoresizingMaskIntoConstraints = YES;
                pullToRefresh.frame = self.tableView.ins_pullToRefreshBackgroundView.bounds;
                
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

#pragma mark -Call WebService

-(void)callWebService{
        
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        [dic setObject:[@(lastPageNumber) stringValue]          forKey:@"page"];
        
        [self getWebService :[dic mutableCopy]];
}

#pragma mark -Call WebService

-(void)getWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Blog);
//                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
//                [dic setObject:@"blog" forKey:@"page"];//{"page":"blog","page":"0"}
                
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                NSURL *url = [NSURL URLWithString:urlString];
                
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:postData];
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [self setBackgroundLabel];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
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

                                        
                                        NSArray*resPonsedataArray = (NSArray*)[result valueForKey:@"blogList"];
                                        _baseURL = (NSString*)[result valueForKey:@"base_url"];
                                        
                                        
                                         NSArray *resData = [Alert dictionaryByReplacingNullsWithString:@"" arr:[resPonsedataArray mutableCopy]];
                                        
                                        if([resData isKindOfClass:[NSArray class]]){
                                                
                                                _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                                        
                                                if(_arrBLogs==nil){
                                                        _arrBLogs=resData.count ? [resData mutableCopy] :nil;
                                                        
                                                        weakSelf.numberOfRows=_arrBLogs.count;
                                                }else{
                                                        if(resData.count)
                                                                [_arrBLogs addObjectsFromArray:[resData mutableCopy]];
                                                        weakSelf.numberOfRows += resData.count;
                                                }
                                                
                                       
                                        
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                        [weakSelf.tableView beginUpdates];
                                                        
                //                                        weakSelf.numberOfRows += 15;
                                                        NSMutableArray* newIndexPaths = [NSMutableArray new];
                                                        
                                                        for(NSInteger i = weakSelf.numberOfRows - resData.count; i < weakSelf.numberOfRows; i++) {
                                                                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                                                [newIndexPaths addObject:indexPath];
                                                        }
                                                        
                                                        [weakSelf.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                                                        
                                                        
                                                        [weakSelf.tableView endUpdates];
                                                        
                                                        [_scrollView ins_endInfinityScrollWithStoppingContentOffset:YES];
                                                        
                //                                        if (weakSelf.numberOfRows > 30) {
                //                                                // Disable infinite scroll after 45 rows
                //                                                _scrollView.ins_infiniteScrollBackgroundView.enabled = NO;
                //                                        }

                                                
                                                
                                                
                                                        
                                                        
        //                                                [UIView transitionWithView:self.tableView
        //                                                                  duration:0.3
        //                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
        //                                                 
        //                                                                animations:nil
        //                                                                completion:nil];
        //                                                
        //                                                
        //                                                
        //                                                [self.tableView reloadData];
                                                });
                                                
                                        }
                                        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _arrBLogs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        if(_arrBLogs.count){
                NSDictionary* dic=[_arrBLogs objectAtIndex:indexPath.row];
                
                BOOL isImage=!IS_EMPTY([dic objectForKey:@"feature_image"]);
        
//                isImage=indexPath.row==1 ? NO : YES;
                finalHeight= isImage ?  CELL_BLOG_HEIGHT : CELL_BLOG_HEIGHT-IMAGE_BLOG_HEIGHT;
        }
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        
        
        BlogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary* dic=[_arrBLogs objectAtIndex:indexPath.row];
        
        for (id view in cell.viContainerDetail.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
        
        cell.lblDesc.tag=indexPath.row;
        cell.img.backgroundColor=[UIColor whiteColor];
        cell.viContainerDetail.translatesAutoresizingMaskIntoConstraints=
        cell.img.translatesAutoresizingMaskIntoConstraints=
        cell.lblDesc.translatesAutoresizingMaskIntoConstraints=YES;
        
        BOOL isImage=!IS_EMPTY([dic objectForKey:@"feature_image"]);
//        isImage=indexPath.row==1 ? NO : YES;
        if(isImage){
                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator1.frame = CGRectMake(cell.viContainerDetail.frame.size.width/2-15,
                                                      cell.viContainerDetail.frame.size.height/2-15,
                                                      30,
                                                      30);
                [activityIndicator1 startAnimating];
                activityIndicator1.tag=indexPath.row;
                
                //        [activityIndicator1 removeFromSuperview];
                [cell.viContainerDetail addSubview:activityIndicator1];
                [cell.viContainerDetail insertSubview:activityIndicator1 aboveSubview:cell.img];
                
                
                NSString* path=_baseURL ?
                [_baseURL stringByAppendingString:[dic objectForKey:@"feature_image"]] :
                [dic objectForKey:@"feature_image"];
                
                NSURL* url=[NSURL URLWithString:path];
                
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
                
                
                
                //Image
                CGRect imgFrame=cell.img.frame;
                imgFrame.size.height=IMAGE_BLOG_HEIGHT;
                cell.img.frame=imgFrame;
                
                //Desc
                CGRect descFrame=cell.lblDesc.frame;
                descFrame.origin.y=imgFrame.origin.y+imgFrame.size.height+8;
                cell.lblDesc.frame=descFrame;
                
                
                //Desc
                CGRect viFrame=cell.viContainerDetail.frame;
                viFrame.size.height=CELL_BLOG_CONTAINER_HEIGHT;
                cell.viContainerDetail.frame=viFrame;

        }
        else{
                //Image
                CGRect imgFrame=cell.img.frame;
                imgFrame.size.height=0;
                cell.img.frame=imgFrame;
                
                //Desc
                CGRect descFrame=cell.lblDesc.frame;
                descFrame.origin.y=imgFrame.origin.y;
                cell.lblDesc.frame=descFrame;
                
                
                //Desc
                CGRect viFrame=cell.viContainerDetail.frame;
                viFrame.size.height=CELL_BLOG_CONTAINER_HEIGHT-IMAGE_BLOG_HEIGHT;
                cell.viContainerDetail.frame=viFrame;
                
        }
        
        
        cell.lblName.text=[dic objectForKey:@"title"];
        NSString* posted_on=[dic objectForKey:@"posted_on"];
        NSString* posted_by=[dic objectForKey:@"posted_by"];
        //reviewDate=[Alert getDateWithString:reviewDate getFormat:@"yyyy-MM-dd HH:mm:ss" setFormat:@"yyyy-MM-dd"];
        cell.lblDate.text=[NSString stringWithFormat:@"Posted on %@ By %@",posted_on,posted_by];
        
        
        //UIColor* color1=[Alert colorFromHexString:COLOR_CELL_TEXT];
        UIColor* color2=[Alert colorFromHexString:COLOR_CELL_TITLE];
        NSString* htmlString=[dic objectForKey:@"desc"];
        NSString* text=[Alert removeHTMLTags:htmlString];
//        NSString*temp=@"Lorem ipsum dolor sit amet, nulla apeirian theophrastus sea in, quo eu facilisi delicatissimi. Ludus praesent definiebas pri at, duo et illud delicata salutandi, ea mel nisl augue. At ius invenire";
//        int tempLength=temp.length;
        cell.lblDesc.text=text;
        NSInteger lenght=[cell.lblDesc.text length];
        //int lines=(cell.lblDesc.frame.size.height+20)/cell.lblDesc.font.pointSize;
        int subLength=164;
        //NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:cell.lblDesc.text];
        
        
        if(lenght>subLength){
                NSString* readMore=@"...read more";
                NSString *newString = [text substringWithRange:NSMakeRange(0, subLength)];
                text=[newString stringByAppendingString:readMore];
                cell.lblDesc.text=text;
                
                //NSInteger l1=[cell.lblDesc.text length];
               // NSInteger l2=readMore.length-3;
//                [attributedString addAttribute:NSLinkAttributeName
//                                         value:@"Hello"
//                                         range:NSMakeRange(10,5)];
                //        NSInteger l2=reviewDate.length;
                //        NSInteger l3=cell.lblAutherName.text.length;
                
//                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblDesc.text];
//                [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0,l1-l2)];
//                [string addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(l1-l2,l2)];
//                //        [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(14+l1,l2)];
//                //
//                cell.lblDesc.attributedText = string;
                
                cell.lblDesc.delegate=self;
                NSURL *url = [NSURL URLWithString:@"action://Expand"];
                cell.lblDesc.linkAttributes = @{(id)kCTForegroundColorAttributeName: color2,
                                              NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                
                NSRange r = [cell.lblDesc.text rangeOfString:readMore];
                [cell.lblDesc addLinkToURL:url withRange:r];
        }
        
        
        
        
        
        return cell;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
         NSDictionary* dic=[_arrBLogs objectAtIndex:indexPath.row];
         NSString* htmlString=[dic objectForKey:@"desc"];
         NSString* text=[Alert removeHTMLTags:htmlString];
         NSLog(@"Read more clicked");
        BlogDetailsViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"BlogDetailsViewController"];                   //vc.titleString=[dic objectForKey:@"title"];
        //vc.descString=text;
        //vc.from=@"back";
        vc.dict = dic;
        vc.baseURL = _baseURL;
        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
        
        NSDictionary* dic=[_arrBLogs objectAtIndex:label.tag];
       
        if ([[url scheme] hasPrefix:@"action"]) {
                if ([[url host] hasPrefix:@"Expand"]) {
                        NSString* htmlString=[dic objectForKey:@"desc"];
                        NSString* text=[Alert removeHTMLTags:htmlString];
//                        NSLog(@"Read more clicked");
                    BlogDetailsViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"BlogDetailsViewController"];                   //vc.titleString=[dic objectForKey:@"title"];
                    //vc.descString=text;
                    //vc.from=@"back";
                    vc.dict = dic;
                    vc.baseURL = _baseURL;
                    [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                    
                        
                        
                        /* load help screen */
                } else if ([[url host] hasPrefix:@"show-settings"]) {
                        /* load settings screen */
                }
        } else {
                /* deal with http links here */
        }
}

@end
