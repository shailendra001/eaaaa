//
//  ArtCollectionViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 23/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtCollectionViewController.h"
#import "ArtCollectionViewCell.h"
#import "ArtDetailViewController.h"
#import "PopFilterViewController.h"
#import "ArtistDetailViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_TEXT         @"#575656"

#define CATEGORY                @"category"
#define CATEGORY_STYLE_NAME     @"stylename"
#define CATEGORY_COLOR_NAME     @"colorname"
#define CATEGORY_PRICE          @"price"
#define CATEGORY_SORT           @"sort"

#define CELL_WIDTH      152
#define CELL_HEIGHT     215


@interface ArtCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate,PopFilter,UITextFieldDelegate>
{
        NSDictionary *resPonsedataArray;
        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        NSMutableDictionary* filterDic;
        NSInteger lastPageNumber;
        __weak ArtCollectionViewController* weakSelf;
        UIScrollView *_scrollView;

}

@property(nonatomic,retain)UIPopoverPresentationController *popSort;
@property (nonatomic, assign) CGFloat numberOfRows;
@property (nonatomic, assign) CGFloat totalRecords;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldArtAndKeyword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsTopCollection;


@end

@implementation ArtCollectionViewController
@synthesize arrArtCollectionList=_arrArtCollectionList;


static NSString * const reuseIdentifier = @"artCell";



#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
    
        
        
        [self cellRegister];
        
        //Pagination
        if([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_ArtCategory)])
        {
                [self setPaginationSetup];
            
          
        }
        if([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_SearchArt)]){
        
         _constraintBottomCollection.constant = 0;
        }else{
            
          _constraintsTopCollection.constant = 0;
        }
    
        
        [self config];
    
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        [self setFilterRequest];
        
        
        if(YES/*![Alert getFromLocal:CATEGORY]*/){
            
            
                [self filterWebService];
        }
        
        if(!self.arrArtCollectionList.count)
        {
                
                [self setActivityIndicator];
                
                [self getWebService];
        }
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
        
        
}

-(void)viewWillAppear:(BOOL)animated {
        
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


#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
       NSLog(@"%@",self.titleString);
        self.lblTitle.text=[self.titleString uppercaseString];// @"ART COLLECTION";
        
#if SHADOW_ENABLE
        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
        [Alert setShadowOnViewAtTop:self.viContainerFilter];
        [Alert setShadowOnViewAtTop:self.viContainerSort];
        [Alert setShadowOnViewAtTop:self.lblSeparatorVirtical];
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
        messageLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
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
        
        [self.collectionView registerClass:[ArtCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        UINib *cellNib = [UINib nibWithNibName:@"ArtCollectionViewCell" bundle:nil];
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

-(void)loadCardCount {
        
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


#pragma mark - Textfield Dalegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _txtFieldArtAndKeyword){
        
        if (_txtFieldArtAndKeyword.text.length == 0){
            
            [Alert alertWithMessage:@"Please enter keyword" navigation:self.navigationController gotoBack:NO animation:YES];
        }else{
            
            [_arrArtCollectionList removeAllObjects];
            [self loadTable];
            
            _arrArtCollectionList = nil;
            [self setPaginationSetup];
            lastPageNumber = 0;
            [_txtFieldArtAndKeyword resignFirstResponder];
            [self getWebServiceWithKeyword:_txtFieldArtAndKeyword.text];
        }
    }
    
    return YES;
}

#pragma mark -Call WebService

-(void)callWebService{
    
    if ([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_SearchArt)]){
        
        [self getWebServiceWithKeyword:_txtFieldArtAndKeyword.text];
        
    }
    else if ([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_ArtFilter)]){
        
        NSMutableDictionary* dic=[filterDic mutableCopy];
        [dic setObject:[@(lastPageNumber) stringValue]          forKey:@"page"];
        filterDic=[dic mutableCopy];
        [self filterSearchWebService:filterDic];
        
    }else{
        
        if([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_ArtCategory)])
        {
                
                NSMutableDictionary* dic=[self.urlData mutableCopy];
                [dic setObject:[@(lastPageNumber) stringValue]          forKey:@"page"];
                self.urlData=[dic mutableCopy];
        }
        
        [self getWebService];
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
                        
                        _scrollView=scrollView;
                        if(_totalRecords>_arrArtCollectionList.count){
                                lastPageNumber++;
                                
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

#pragma mark -Call WebService

-(void)getWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = self.urlString;//;JOIN_STRING(kPrefixUrl, kURL_NewArt);
//                NSMutableDictionary* data=[NSMutableDictionary dictionary];
//                [data setObject:@"15" forKey:@"limit"];
                
                NSString *postString =[Alert jsonStringWithDictionary:[self.urlData mutableCopy]];
                
                
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
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                
                        });
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if(_arrArtCollectionList.count)         [self removeBackgroundLabel];
                                else                                    [self setBackgroundLabel];
                                [self.collectionView reloadData];
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
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(_arrArtCollectionList.count)         [self removeBackgroundLabel];
                                        else                                    [self setBackgroundLabel];
                                        
                                        [self.collectionView reloadData];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                        resPonsedataArray = (NSDictionary*)[result valueForKey:self.dataAccesskey];
                                        _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                                        
                                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
                                                // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                                                
                                                NSArray *resData = [Alert dictionaryByReplacingNullsWithString:@"" arr:[resPonsedataArray mutableCopy]];
                                                
                                                if([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_ArtCategory)]){
                                                        _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                                                        
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
                                                else{
                                                        _arrArtCollectionList=[resData mutableCopy];
                                                        
                                                        [self loadTable];
                                                }
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

-(void)filterWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_CategorySearch);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:@"catSearch" forKey:@"page"];//{"page":"catSearch"}
                
                
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
                                        
                                        NSDictionary*category = (NSDictionary*)[result valueForKey:@"data"];
                                        category = [Alert removedNullsWithString:@"" obj:category];
                                        /*BOOL isSave=*/[Alert saveToLocal:category key:CATEGORY];
                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

-(void)filterSearchWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                self.urlString = JOIN_STRING(kPrefixUrl, kURL_ArtFilter);
                
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",self.urlString);
                
                
                NSMutableURLRequest *theRequest =[Alert getRequesteWithPostString:postString
                                                                        urlString:self.urlString
                                                                       methodType:REQUEST_METHOD_TYPE_POST
                                                                           images:nil];
                
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                
                        });
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if(_arrArtCollectionList.count)         [self removeBackgroundLabel];
                                else                                    [self setBackgroundLabel];
                                [self.collectionView reloadData];
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
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(_arrArtCollectionList.count)         [self removeBackgroundLabel];
                                        else                                    [self setBackgroundLabel];
                                        
                                        [self.collectionView reloadData];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                       // [self setFilterRequest]; //TODO_ARVIND
                                    
                                    _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                                        resPonsedataArray = (NSDictionary*)[result valueForKey:@"getLatestArt"];
                                        
                                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
                                                // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                                            
                                            NSArray *resData = [Alert dictionaryByReplacingNullsWithString:@"" arr:[resPonsedataArray mutableCopy]];
                                            
                                            
                                            if([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_ArtFilter)]){
                                                _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                                                
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
                                            else{
                                                _arrArtCollectionList=[resData mutableCopy];
                                                
                                                [self loadTable];
                                            }
                                            
                                                
//                                                dispatch_async(dispatch_get_main_queue(), ^{
//
//                                                        _arrArtCollectionList=[resPonsedataArray mutableCopy];
//
//
//
//                                                        [UIView transitionWithView:self.collectionView
//                                                                          duration:0.3
//                                                                           options:UIViewAnimationOptionTransitionCrossDissolve
//
//                                                                        animations:nil
//                                                                        completion:nil];
//
//
//
//                                                        [self.collectionView reloadData];
//                                                });
                                            
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




#pragma mark -Call WebService

-(void)getWebServiceWithKeyword:(NSString*)strKeyword{
    
    const char* className=[NSStringFromSelector(_cmd) UTF8String];
    
    dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
    dispatch_async(myQueue, ^{
        
       // http://www.eastonartgalleries.com/services/home/searchArt
        self.urlString = JOIN_STRING(kPrefixUrl, kURL_SearchArt);
        //                NSMutableDictionary* data=[NSMutableDictionary dictionary];
        //                [data setObject:@"15" forKey:@"limit"];
        NSMutableDictionary* dic=[NSMutableDictionary new];
        [dic setObject:[@(lastPageNumber) stringValue]          forKey:@"page"];
        [dic setObject:strKeyword          forKey:@"keyword"];
        [dic setObject:@"12"          forKey:@"per_page"];

        
        NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
        
        
        NSLog(@" tempURL :%@---",self.urlString);
        
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        // NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        
        NSURL *url = [NSURL URLWithString:_urlString];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //                NSData *req=[NSData dataWithBytes:[postString UTF8String] length:[postString length]];
        [theRequest setHTTPBody:postData];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
        
        if (returnData == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeActivityIndicator];
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_arrArtCollectionList.count)         [self removeBackgroundLabel];
                else                                    [self setBackgroundLabel];
                [self.collectionView reloadData];
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
                //[self alerMessage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(_arrArtCollectionList.count)         [self removeBackgroundLabel];
                    else                                    [self setBackgroundLabel];
                    
                    [self.collectionView reloadData];
                });
            }
            else
            {
                
                NSLog(@"Response : %@", result);
                NSString *success  = [result valueForKey:@"success"];
                NSString *error  = [result valueForKey:@"error"];
                
                if (success.boolValue) {
                    
                    resPonsedataArray = (NSDictionary*)[result valueForKey:@"getLatestArt"];
                    _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                    
                    if([resPonsedataArray isKindOfClass:[NSArray class]]){
                        // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                        
                        NSArray *resData = [Alert dictionaryByReplacingNullsWithString:@"" arr:[resPonsedataArray mutableCopy]];
                        
                        if([self.urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_SearchArt)]){
                            _totalRecords = [[result valueForKey:@"total_records"] floatValue];
                            
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
                        else{
                            _arrArtCollectionList=[resData mutableCopy];
                            
                            [self loadTable];
                        }
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
- (IBAction)btnSearchAction:(id)sender {
    
    if (_txtFieldArtAndKeyword.text.length == 0){
        
        [Alert alertWithMessage:@"Please enter keyword" navigation:self.navigationController gotoBack:NO animation:YES];
    }else{
        
        [_arrArtCollectionList removeAllObjects];
        [self loadTable];
        
        _arrArtCollectionList = nil;
        [self setPaginationSetup];
        lastPageNumber = 0;
        [_txtFieldArtAndKeyword resignFirstResponder];
        [self getWebServiceWithKeyword:_txtFieldArtAndKeyword.text];
    }
}

#pragma mark - Filter Delegate

-(void)setFilterRequest{
        //{"user_id":"53","page":"1","sort":"art_name","category":["4"],"style":["5"],"price":["0_10000"],"color":["6"],"per_page":"12"}
        
        NSMutableDictionary* dic=[Alert getFromLocal:@"filter"];
        
        

        filterDic=[NSMutableDictionary dictionary];
        
        [filterDic setObject:[[EAGallery sharedClass] isLogin]? [[EAGallery sharedClass] memberID] : @"" forKey:@"user_id"];
        [filterDic setObject:@"12" forKey:@"per_page"];
        [filterDic setObject:@"1" forKey:@"page"];
        lastPageNumber = 1; //TODO_ARVIND
        [filterDic setObject:dic ? [dic objectForKey:@"category"] : @[] forKey:@"category"];
        [filterDic setObject:dic ? [dic objectForKey:@"style"] : @[] forKey:@"style"];
        [filterDic setObject:dic ? [dic objectForKey:@"color"] : @[] forKey:@"color"];
        
        [filterDic setObject:dic ? [dic objectForKey:@"sort"] :  @"id ASC" forKey:@"sort"];
        [filterDic setObject:dic ? [dic objectForKey:@"price"] :  @[@"0_10000"] forKey:@"price"];
}

-(void)filterOption:(id)object title:(NSString *)title finish:(BOOL)finish{
        NSArray* result;
        NSDictionary* info;
        
        if([object isKindOfClass:[NSArray class]])
                result=(NSArray*)object;
        
        if([object isKindOfClass:[NSDictionary class]])
                info=(NSDictionary*)object;
        
        
        if([title isEqualToString:CATEGORY])
                [filterDic setObject:result forKey:@"category"];
        if([title isEqualToString:CATEGORY_STYLE_NAME])
                [filterDic setObject:result forKey:@"style"];
        if([title isEqualToString:CATEGORY_COLOR_NAME])
                [filterDic setObject:result forKey:@"color"];
        
        if([title isEqualToString:CATEGORY_SORT])
                [filterDic setObject:[info objectForKey:@"id"] forKey:@"sort"];
        if([title isEqualToString:CATEGORY_PRICE])
                [filterDic setObject:@[[info objectForKey:@"id"]] forKey:@"price"];
        
        if(finish){
//                NSLog(@"%@",filterDic);
         
                self.arrArtCollectionList=nil;
                
                [self.collectionView reloadData];
                
                [self setBackgroundLabel];
                
                [self setActivityIndicator];
                
                [self filterSearchWebService:filterDic];
                
                [Alert saveToLocal:filterDic key:@"filter"];
        }
        
        
        
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        
        return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
        return _arrArtCollectionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
        ArtCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        
        for (id view in cell.viContainerImage.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
        
        NSDictionary* data=[_arrArtCollectionList objectAtIndex:indexPath.item];
        
        cell.lblName.text=[data objectForKey:@"art_name"];
        NSString* category=[data objectForKey:@"category_name"];;
        NSString* autherName=[data objectForKey:@"name"];
        
        
        
        UIColor* color1=[Alert colorFromHexString:@"#585858"];
        UIColor* color2=[Alert colorFromHexString:@"#971700"];
        
        cell.lblAutherName.text=[NSString stringWithFormat:@"%@ by %@",category,autherName];
        NSInteger l1=category.length;
        NSInteger l2=autherName.length;
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblAutherName.text];
        [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0,l1+4)];
        [string addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(l1+4,l2)];
        
        cell.lblAutherName.attributedText = string;
    
        cell.btnAutherNameSelection.tag = indexPath.row;
        [cell.btnAutherNameSelection addTarget:self action:@selector(btnAutherNameAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lblSize.text=[data objectForKey:@"art_size"];
        
        cell.lblPrice.text=[NSString stringWithFormat:@"$%@",[data objectForKey:@"art_price"]];
        

         NSString* path=_baseURL ? [_baseURL stringByAppendingString:[data objectForKey:@"art_image"]] : [data objectForKey:@"art_image"];
    
         NSLog(@"IMAGE_PATH:::%@",path);
    
        NSURL* url=[NSURL URLWithString:path];
        
        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator1.frame = CGRectMake(cell.imgView.frame.size.width/2-15,
                                             cell.imgView.frame.size.height/2-15,
                                             30,
                                             30);
        [activityIndicator1 startAnimating];
        activityIndicator1.tag = indexPath.row;
        
        [activityIndicator1 removeFromSuperview];
        [cell.viContainerImage addSubview:activityIndicator1];
        [cell.viContainerImage insertSubview:activityIndicator1 aboveSubview:cell.imgView];
        
        
        cell.imgView.contentMode = UIViewContentModeScaleToFill;
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
                 
                 strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                 
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
        
        
        
        
        //        cell.backgroundColor=[UIColor yellowColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.viContainerImage.backgroundColor=[UIColor clearColor];
        
        
        BOOL isSold= [data objectForKey:@"quantity"]!=nil && [[data objectForKey:@"quantity"] intValue]==0 ? YES : NO;
        cell.imgSold.hidden=!isSold;
        
        
        return cell;
}

-(void)btnAutherNameAction:(UIButton*)btn{
    
    NSDictionary* data=[_arrArtCollectionList objectAtIndex:btn.tag];
    
    ArtistDetailViewController* vc=GET_VIEW_CONTROLLER(kArtistDetailViewController);
    vc.from=@"back";
    vc.artUserName = [data objectForKey:@"username"];
    vc.titleString = [data objectForKey:@"name"];
    [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        
       // ArtCollectionViewCell *cell =(ArtCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
       NSDictionary* data=[_arrArtCollectionList objectAtIndex:indexPath.item];
        
        if(data!=nil){
                
                ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
                vc.from=@"back";
                vc.artID=[data objectForKey:@"id"];
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                
                
                
        }
 
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

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
        return UIModalPresentationNone;
}


- (IBAction)sort:(id)sender {
        
        NSMutableDictionary* dic=[Alert getFromLocal:CATEGORY];
        NSMutableDictionary* sort=[NSMutableDictionary dictionaryWithObject:[dic objectForKey:CATEGORY_SORT] forKey:CATEGORY_SORT];
        
        
        [self showPop:sender data:sort title:@"Sort" size:CGSizeMake(250,250)];
}

- (IBAction)filter:(id)sender {
        
        NSMutableDictionary* dic=[Alert getFromLocal:CATEGORY];
        NSMutableDictionary* filter=[NSMutableDictionary dictionary];
        
        for (NSString* key in dic.allKeys) {
                
                if(![key isEqualToString:CATEGORY_SORT])
                [filter setObject:[dic objectForKey:key] forKey:key];
        }
        
        
        [self showPop:sender data:filter title:@"Filter" size:CGSizeMake(250,300)];

}

-(void)showPop:(id)sender data:(NSDictionary*)data title:(NSString*)title size:(CGSize)size{
        
        UIButton* button=(UIButton*)sender;
        
        PopFilterViewController* vc=[[PopFilterViewController alloc]initWithNibName:@"PopFilterViewController" bundle:nil];
        vc.data=data;
        vc.titleString=title;
        
        vc.delegate=self;
        
        UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:vc];/*Here dateVC is controller you want to show in popover*/
        vc.preferredContentSize = size;
        destNav.modalPresentationStyle = UIModalPresentationPopover;
        _popSort = destNav.popoverPresentationController;
        _popSort.delegate = self;
        _popSort.sourceView = self.view;
        _popSort.sourceRect = button.superview.frame;
        destNav.navigationBarHidden = YES;
        [self presentViewController:destNav animated:YES completion:nil];

}

//#pragma mark:- Attributed Label Delegate
//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
//
//    //        NSDictionary* dic=[data mutableCopy];
//
//    if ([[url scheme] hasPrefix:@"action"]) {
//        if ([[url host] hasPrefix:@"Expand"]) {
//
//            ArtistDetailViewController* vc=GET_VIEW_CONTROLLER(kArtistDetailViewController);
//            vc.from=@"back";
//            vc.artUserName=[data objectForKey:@"username"];
//            vc.titleString=[data objectForKey:@"name"];
//            [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
//
//        } else if ([[url host] hasPrefix:@"show-settings"]) {
//            /* load settings screen */
//        }
//    } else {
//        /* deal with http links here */
//    }
//}

@end