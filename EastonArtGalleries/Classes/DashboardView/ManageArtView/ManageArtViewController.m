//
//  ManageArtViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 20/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ManageArtViewController.h"
#import "ManageArtCollectionViewCell.h"
#import "ArtDetailViewController.h"
#import "AddArtViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_TEXT         @"#575656"

#define CELL_WIDTH      152
#define CELL_HEIGHT     234


@interface ManageArtViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
       
        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        NSMutableDictionary* filterDic;
        NSDictionary* selectedDic;
        NSInteger lastPageNumber;
        __weak ManageArtViewController* weakSelf;
        UIScrollView *_scrollView;
        BOOL isLoaded;
}

@property (nonatomic, assign) CGFloat numberOfRows;
@property (nonatomic, assign) CGFloat totalRecords;



@end


@implementation ManageArtViewController
@synthesize arrArtCollectionList=_arrArtCollectionList;

static NSString * const reuseIdentifier = @"Cell";



#pragma mark - View controller life cicle

- (void)viewDidLoad {
        
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self config];
        
        [self setPaginationSetup];
        
//        [self callWebService];
        
        
        
}

-(void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        if(_isNeedUpdate){
                _isNeedUpdate=NO;
                [self callWebService];
        }
        
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
        
        if(!isLoaded){
                isLoaded=YES;
                [self callWebService];
        }
        
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
        
//        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.collectionView.backgroundColor=[UIColor whiteColor];
        
        _arrArtCollectionList=nil;
        [self removeBackgroundLabel];
        [self setActivityIndicator];
        [self loadTable];

        
#if SHADOW_ENABLE
//        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
//        [Alert setShadowOnViewAtTop:self.viContainerFilter];
//        [Alert setShadowOnViewAtTop:self.viContainerSort];
//        [Alert setShadowOnViewAtTop:self.lblSeparatorVirtical];
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

-(void)loadTable{
        
        dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                
                [UIView transitionWithView:self.collectionView
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:nil];
                
                
                
                [self.collectionView reloadData];
        });
}

-(void)setNav{
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
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
        [self.view insertSubview:activityIndicator aboveSubview:self.collectionView];
        
}

-(void)removeActivityIndicator {
        
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
        
        self.collectionView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)removeBackgroundLabel{
        self.collectionView.backgroundView = nil;
}

-(void)cellRegister{
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        
        [self.collectionView registerClass:[ManageArtCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        UINib *cellNib = [UINib nibWithNibName:@"ManageArtCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
        
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
                self.collectionView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 100.0f, 0.0f);
        }
        
        
        [self.collectionView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
                int64_t delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [scrollView ins_endPullToRefresh];
                        
                });
        }];
        
        self.collectionView.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
        if (self.style == INSPullToRefreshStylePreserveContentInset) {
                self.collectionView.ins_pullToRefreshBackgroundView.preserveContentInset = YES;
        }
        
        if (self.style == INSPullToRefreshStyleText) {
                self.collectionView.ins_pullToRefreshBackgroundView.dragToTriggerOffset = 60.0;
        }
        
        weakSelf = self;
        
        
        [self.collectionView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
                
                int64_t delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        if(_totalRecords>_arrArtCollectionList.count){
                                lastPageNumber++;
                                _scrollView=scrollView;
                                
                                [self callWebService];
                        }
                        else{
                                [_scrollView ins_endInfinityScroll];
                        }
                        
                        
                });
        }];
        
        UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
        [self.collectionView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
        [infinityIndicator startAnimating];
        
        self.collectionView.ins_infiniteScrollBackgroundView.preserveContentInset = NO;
        
        if (self.style == INSPullToRefreshStylePreserveContentInset) {
                self.collectionView.ins_infiniteScrollBackgroundView.preserveContentInset = YES;
        }
        
        UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
        self.collectionView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
        [self.collectionView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
        
        if (self.style == INSPullToRefreshStyleText) {
                pullToRefresh.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                pullToRefresh.translatesAutoresizingMaskIntoConstraints = YES;
                pullToRefresh.frame = self.collectionView.ins_pullToRefreshBackgroundView.bounds;
                
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

#pragma Mark Navigation Bar Configuration Code

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
        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"];
        [dic setObject:[@(lastPageNumber) stringValue]          forKey:@"page"];
        [self getWebService:dic];
}

-(void)getWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ManageArt);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
               
                
                NSMutableURLRequest *theRequest =[Alert getRequesteWithPostString:postString
                                                                        urlString:urlString
                                                                       methodType:REQUEST_METHOD_TYPE_POST
                                                                           images:nil];
                
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [self setBackgroundLabel];
                                
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
                        
                        
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self removeActivityIndicator];
                                        [self setBackgroundLabel];
                                        
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
                                        [self removeActivityIndicator];
                                        
                                });
                                
                                
                                if (success.boolValue) {
                                        
                                        NSArray *resData = (NSArray*)[result valueForKey:@"art_records"];
                                        _totalRecords = [[result valueForKey:@"totalRecords"] floatValue];
                                        
                                        if([resData isKindOfClass:[NSArray class]]){
                                                
                                                resData = [Alert dictionaryByReplacingNullsWithString:@"" arr:resData];

                                                
                                                        
//                                                _arrArtCollectionList=resData.count ? [resData mutableCopy] : nil;
                                                //For Pagination
                                                if(_arrArtCollectionList==nil){
                                                        _arrArtCollectionList=resData.count ? [resData mutableCopy] : nil;
                                                        weakSelf.numberOfRows=_arrArtCollectionList.count;
                                                        
                                                }
                                                else{
                                                        if(resData.count)
                                                           [_arrArtCollectionList addObjectsFromArray:[resData mutableCopy]];
                                                              weakSelf.numberOfRows += resData.count;
                                                }

//                                                [self loadTable];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                
                                                        [weakSelf.collectionView performBatchUpdates:^{
//                                                                weakSelf.numberOfRows=_arrArtCollectionList.count;
//                                                                weakSelf.numberOfRows += resData.count;
                                                                NSMutableArray* newIndexPaths = [NSMutableArray new];

                                                                for(NSInteger i = weakSelf.numberOfRows - resData.count; i < weakSelf.numberOfRows; i++) {
                                                                        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                                                        [newIndexPaths addObject:indexPath];
                                                                }
                                                                [weakSelf.collectionView insertItemsAtIndexPaths:newIndexPaths];

                                                        } completion:nil];
                                               
                                                        
                                                        [_scrollView ins_endInfinityScroll];
                                                        
                                                });
                                                
                                                
                                                
                                        }
                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(_arrArtCollectionList.count) [self removeBackgroundLabel];
                                        else                            [self setBackgroundLabel];
                                });
                        }
                        
                }
               
                
        });
        
}

-(void)deleteArtWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_DeleteArt);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                
                
                NSMutableURLRequest *theRequest =[Alert getRequesteWithPostString:postString
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
                        
                        
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [[SharedClass sharedObject] hudeHide];
                                        
                                });
                                
                                
                                if (success.boolValue) {
                                        

                                        [_arrArtCollectionList removeObject:selectedDic];
                                        [self loadTable];
                                        selectedDic=nil;

                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(_arrArtCollectionList.count) [self removeBackgroundLabel];
                                        else                            [self setBackgroundLabel];
                                });
                        }
                        
                }
                
                
        });
        
}

-(void)editArtWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_EditArt);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                
                
                NSMutableURLRequest *theRequest =[Alert getRequesteWithPostString:postString
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
                        
                        
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                NSString *msg  = [result valueForKey:@"msg"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [[SharedClass sharedObject] hudeHide];
                                        
                                });
                                
                                
                                if (success.boolValue) {
                                       result=[Alert removedNullsWithString:@"" obj:result];
                                        _isNeedUpdate=YES;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                AddArtViewController* vc=GET_VIEW_CONTROLLER(kAddArtViewController);
                                                vc.from=@"back";
                                                vc.titleString=@"Edit Art";
                                                vc.fromVC=kManageArtViewController;
                                                vc.response=[result mutableCopy];
                                                vc.artID=[dic objectForKey:@"art_id"];
                                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:msg
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                }
                                
                                else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:msg
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                }
                                
                        }
                        
                }
                
                
        });
        
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        
        return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
        return _arrArtCollectionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        ManageArtCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        
        
        
        for (id view in cell.viContainerImage.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
        
        
        
        NSDictionary* data=[_arrArtCollectionList objectAtIndex:indexPath.item];
        
        cell.lblName.text=[data objectForKey:@"art_name"];
        NSString* category=[data objectForKey:@"category_name"];;

        
        cell.lblAutherName.text=category;
        
        cell.lblSize.text=[data objectForKey:@"art_size"];
        

        
        
        NSString* path=[data objectForKey:@"art_image"];
        
        NSURL* url=[NSURL URLWithString:path];
        
        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator1.frame = CGRectMake(cell.imgView.frame.size.width/2-15,
                                              cell.imgView.frame.size.height/2-15,
                                              30,
                                              30);
        [activityIndicator1 startAnimating];
        activityIndicator1.tag=indexPath.row;
        
        [activityIndicator1 removeFromSuperview];
        [cell.viContainerImage addSubview:activityIndicator1];
        [cell.viContainerImage insertSubview:activityIndicator1 aboveSubview:cell.imgView];
        
        
        cell.imgView.contentMode=UIViewContentModeScaleToFill;
        cell.imgView.backgroundColor=[UIColor whiteColor];
        
        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
        
        __weak UIImageView *weakImgPic = cell.imgView;
        [cell.imgView setImageWithURL:url
                     placeholderImage:imgPlaceHolder
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 [activityIndicator1 stopAnimating];
                 [activityIndicator1 removeFromSuperview];
                 
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
//                 UIImage* temp=[Alert imageResizeScale:CGSizeMake(152, 102) image:image];
                 
                 UIImage* temp=[Alert imageWithImage:image
                                    scaledToMaxWidth:152
                                           maxHeight:149];
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                         strongImgPic.contentMode=UIViewContentModeTop;
                                         strongImgPic.image=temp;
                                         
                                 }
                                 completion:^(BOOL finish){
                                         
                                 }];
                 
         } failure:NULL];
        
//        if([[data objectForKey:@"status"] boolValue]==1){
//                cell.lblLive.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:11.0 ];
//        }
        
        //Adjust Font
        cell.lblLive.numberOfLines = 1;
        cell.lblLive.minimumScaleFactor =  8./cell.lblLive.font.pointSize;
        cell.lblLive.adjustsFontSizeToFitWidth = YES;
        
        BOOL isSold= [data objectForKey:@"quantity"]!=nil && [[data objectForKey:@"quantity"] intValue]==0 ? YES : NO;
        BOOL isLive=[[data objectForKey:@"status"] boolValue]==1 ? YES : NO;
        
        cell.imgSend.hidden=YES;
        cell.btnSold.hidden=!isSold;
        cell.imgSold.hidden=!isSold;
        
//        cell.lblLive.text=[[data objectForKey:@"status"] boolValue]==1 ? @"Live" : @"Pending";
        if(isLive){
                cell.lblLive.hidden=NO;
                cell.lblPending.hidden=YES;
                cell.lblLive.textAlignment=isSold ? NSTextAlignmentRight :NSTextAlignmentCenter;
        }
        else{
                cell.lblLive.hidden=YES;
                cell.lblPending.hidden=NO;
                cell.lblPending.textAlignment=isSold ? NSTextAlignmentRight :NSTextAlignmentCenter;
        }
        
        
        cell.imgSend.image=[UIImage imageNamed:[[data objectForKey:@"status"] boolValue]==1 ? @"send_icon.png" :@"pending_icon.png"];
        
        //        cell.backgroundColor=[UIColor yellowColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.viContainerImage.backgroundColor=[UIColor clearColor];
        
        cell.btnImage.tag=indexPath.item;
        cell.btnEdit.tag=indexPath.item;
        cell.btnDelete.tag=indexPath.item;
        cell.btnLive.tag=indexPath.item;
        
        [cell.btnImage addTarget:self action:@selector(goArtDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(goArtEdit:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete addTarget:self action:@selector(goArtDelete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLive addTarget:self action:@selector(goArtLive:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSold addTarget:self action:@selector(sold:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        
        // ArtCollectionViewCell *cell =(ArtCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
       
        
        
        
        
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
}




- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
        return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 5.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsetsMake(5,5,5,5);  // top, left, bottom, right
}

#pragma mark - UIScrollView delegate for pagination
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if(y > h + reload_distance)
        {
                lastPageNumber++;
                // Call the method.
                [self callWebService];
        }
}
*/

/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        if (!decelerate) {
                lastPageNumber++;
                // Call the method.
                [self callWebService];
        }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        lastPageNumber++;
        // Call the method.
        [self callWebService];
}
 */


#pragma mark - Target Methods

-(IBAction)goArtDetail:(id)sender{
        
        UIButton* button=(UIButton*)sender;
        
        
        NSDictionary* data=[_arrArtCollectionList objectAtIndex:button.tag];
        
        if(data!=nil){
                
                ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
                vc.from=@"back";
                vc.artID=[data objectForKey:@"id"];
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                
                
                
        }
        
}

-(IBAction)goArtEdit:(id)sender{
        
        UIButton* button=(UIButton*)sender;
        
        NSDictionary* data=[_arrArtCollectionList objectAtIndex:button.tag];
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        [dic setObject:[data objectForKey:@"id"]       forKey:@"art_id"];
        
        [self editArtWebService:[dic mutableCopy]];
        
}

-(IBAction)goArtDelete:(id)sender{
        
        UIButton* button=(UIButton*)sender;
        
        NSDictionary* data=[_arrArtCollectionList objectAtIndex:button.tag];
        selectedDic=data;
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        [dic setObject:[data objectForKey:@"id"]       forKey:@"id"];
        
        [self deleteArtWebService:[dic mutableCopy]];
        
        
//        {"id":"142"}
        
}

-(IBAction)goArtLive:(id)sender{
        
}

-(IBAction)sold:(id)sender{
        
        [Alert alertWithMessage:@"SOLD"
                     navigation:self.navigationController
                       gotoBack:NO animation:YES second:2.0];
        
}

@end
