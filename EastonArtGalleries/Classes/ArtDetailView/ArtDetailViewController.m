//
//  ArtDetailViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 27/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtDetailViewController.h"
#import "ArtDetailViewCell1.h"
#import "ArtDetailViewCell2.h"
#import "ArtDetailViewCell3.h"
#import "ArtDetailCell4.h"
#import "ArtDetailViewCell5.h"

#import "WishListViewController.h"
#import "ArtistDetailViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>


#define COLOR_CELL_BACKGROUND   @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"


@interface ArtDetailViewController ()<UITableViewDelegate,UITableViewDataSource,FBSDKSharingDelegate,SFSafariViewControllerDelegate,GPPSignInDelegate,MFMailComposeViewControllerDelegate,TTTAttributedLabelDelegate>
{
        NSDictionary *data;
        NSMutableArray* arrImages;
        NSArray* arrVideos;
        UIActivityIndicatorView *activityIndicator;
        BOOL isShowDesc;
        BOOL isSelectedImage;
        NSString* seletedImageURL;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        BOOL isCard;
        NSDictionary * artistList;
}
@property (strong, nonatomic) STTwitterAPI* twitter;
@end

@implementation ArtDetailViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";
static NSString *CellIdentifier5 = @"Cell5";

#pragma mark - View controller life cicle

- (void)viewDidLoad {
        
        [super viewDidLoad];
    
        [self registerCell];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        
        if(!data)
        {
                
                //[self setActivityIndicator];
                
                [self getWebService];
        }
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        [self loadCardCount];
        
//        [self logout];
        
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
        cardCountViewGlobal=nil;
        cardViewGlobal=nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}


#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        self.lblAddToCard.text=[self getCardDetail] ? @"GO TO CART" : @"ADD TO CART";
        self.btnAddToCard.enabled=self.btnWishlist.enabled=NO;
        
        
//        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        [Alert setShadowOnViewAtTop:self.viContainerAddToCart];
        [Alert setShadowOnViewAtTop:self.viContainerBuyNow];
        [Alert setShadowOnViewAtTop:self.lblSeparatorLineVirtical];
#endif
        
        [MyObject sharedClass].delegate=self;
        
}

-(void)registerCell{
        
        [self.tableView registerClass:[ArtDetailViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[ArtDetailViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[ArtDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[ArtDetailCell4 class]     forCellReuseIdentifier:CellIdentifier4];
        [self.tableView registerClass:[ArtDetailViewCell5 class] forCellReuseIdentifier:CellIdentifier5];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"ArtDetailViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"ArtDetailViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"ArtDetailViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"ArtDetailViewCell5" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier5];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
}

-(void)setNav{
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}

-(void)setLogoImage{
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
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

-(NSInteger)getCardCount{
        
        NSArray* arrCard=[dataManager getCardDetails];
        
        return  arrCard ? arrCard.count : 0;
}

-(NSInteger)getCardDetail{
        
        NSArray* arrCard=[dataManager getCardDetailsWithID:[data objectForKey:@"id"]];
        
        return  arrCard ? arrCard.count : 0;
}

-(void)loadCardCount{
        
        [self removeCardCount];
        
        NSInteger count=[self getCardCount];
        
        self.lblAddToCard.text=(isCard=[self getCardDetail]) ? @"GO TO CART" : @"ADD TO CART";
        
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

-(NSArray*)getValidUrl:(NSArray*)arr {
        
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        
        for (NSString* url in arr) {
 
                 NSString* fileName=[url lastPathComponent];
                //video
                NSArray*arr=[fileName componentsSeparatedByString:@"="];
                
                if(arr.count==2)
                        [arrResult addObject:fileName];
        }
        
        return  arrResult.count ? arrResult : nil;

}


#pragma mark - Load Gallery

-(void)loadGallery {
        
        artistList=[Alert getFromLocal:@"artistlist"];
        
        if(!artistList){
                [self getArtistListWebService];
        }
        else if(![MyObject sharedClass].isArtistListSet){
                [MyObject setArtistList:[Alert jsonStringWithDictionary:artistList]];
                
                NSLog(@"[ViewController] Show Unity->%@",self.artUserName);
                [MyObject setArtistName:self.artUserName];
                
                [self setGallery];
        }
        else{
                
                NSLog(@"[ViewController] Show Unity->%@",self.artUserName);
                [MyObject setArtistName:self.artUserName];
                
                [self setGallery];
        }
        
}

-(void)setGallery{
        
        //        if([AppDelegate appDelegate].isAppEastonArt)
        //                [[AppDelegate appDelegate] startUnityApp];
        
        
        [AppDelegate appDelegate].isAppEastonArt = NO;
        
        //        [UIView animateWithDuration:0.8 animations:^{
        //
        //                //                [self setNeedsStatusBarAppearanceUpdate];
        //                [[UIApplication sharedApplication] setStatusBarHidden:YES
        //                                                        withAnimation:UIStatusBarAnimationFade];
        //        }];
        
        
        [MyObject unMute];
        [MyObject changeToLandscapeRight];
        
        
#if IS_UNITY_USE
        [UIView animateWithDuration:0.3 animations:^{
                
                [[AppDelegate appDelegate] showUnityWindow];
        }];
#endif
        
        
}

#pragma mark - Instagram

- (void) logout{
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://instagram.com/"]];
        
        for (NSHTTPCookie* cookie in instagramCookies)
        {
                [cookies deleteCookie:cookie];
        }
}

#pragma MyObject Delegate Method

-(void)getClickedDetail:(NSString *)string{
        
        NSLog(@"%@",string);
        
        //e.g- json dictionary"
        //        {'title': '70 Reasons',
        //        'size' : '22*35*3 inch',
        //        'artistname' : 'William DeBilzan',
        //        'price':'$7100',
        //        'id' : '391' }"
        
        NSDictionary* dic=[Alert getDictionaryWithJsonString:string];
        //NSArray* arrDetail=[string componentsSeparatedByString:@":"];
        
        NSLog(@"Click for detail->%@",string);
        //        if(arrDetail.count<5) return;
        
        
        NSLog(@"Title->%@",             [dic objectForKey:@"title"]);
        NSLog(@"Size->%@",              [dic objectForKey:@"size"]);
        NSLog(@"Artist Name->%@",       [dic objectForKey:@"artistname"]);
        NSLog(@"Price->%@",             [dic objectForKey:@"price"]);
        NSLog(@"Art id->%@",            [dic objectForKey:@"id"]);
        
//        [Alert performBlockWithInterval:0.1 completion:^{
//                ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
//                vc.from=@"back";
//                vc.artID=[dic objectForKey:@"id"];
//                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
//        }];
        
        self.artID=[dic objectForKey:@"id"];
        data=nil;
        [self getWebService];
        [self.tableView reloadData];
}


#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromCollectionView:(NSNotification *)notification {
        NSString *cellData = [notification object];
        if (cellData)
        {
                NSLog(@"%@",cellData);
                NSString* fileName=[cellData lastPathComponent];
                NSArray*arr=[fileName componentsSeparatedByString:@"."];
                if(arr.count==2){
                        //Image
                        isSelectedImage=YES;
                        seletedImageURL=cellData;
                        
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                              withRowAnimation:UITableViewRowAnimationNone];
                }
                else{
                        
                        //video
                        NSArray*arr=[fileName componentsSeparatedByString:@"="];
                        NSString*videoID=arr.count==2 ? arr[1] : nil;
                        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
                        //                videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
                        videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
                        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];

                        
                }

        }
}

#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
        MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (finishReason == MPMovieFinishReasonPlaybackError)
        {
                NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
                NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
                NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
                NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
                [alertView show];
        }
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
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
}

-(IBAction)user:(id)sender{
        
        if([[EAGallery sharedClass]isLogin]){
                if([self.navigationController.visibleViewController isKindOfClass:[DashboardViewController class]]) return;
                
                DashboardViewController*vc=GET_VIEW_CONTROLLER(kDashboardViewController);
                vc.titleString=@"Dashboard";
                
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                
        }
        else{
                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                
                LoginViewController*vc=GET_VIEW_CONTROLLER(kLoginViewController);
                vc.titleString=@"Login";
                
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
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

-(void)getWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ArtDetail);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:self.artID forKey:@"art_id"];

                
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
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                
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
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                        NSArray*resDetailArray = (NSArray*)[result valueForKey:@"data"];
                                        NSArray*resImagesArray = (NSArray*)[result valueForKey:@"art_images"];
                                        NSArray*resVideosArray = (NSArray*)[result valueForKey:@"art_video"];
                                        
                                        if([resDetailArray isKindOfClass:[NSArray class]]){
                                                data=resDetailArray.count ? resDetailArray[0] :nil;
                                        }
                                        if([resImagesArray isKindOfClass:[NSArray class]]){
                                                arrImages=resImagesArray.count ? [resImagesArray mutableCopy] :nil;
                                                
                                                arrImages=[[Alert getValidImageUrl:arrImages] mutableCopy];
                                                
                                                if (arrImages==nil) {
                                                        arrImages=[[NSMutableArray alloc]init];
                                                }
                                                
                                                if(data)
                                                [arrImages addObject:[data objectForKey:@"art_image"]];
                                                
                                        }
                                        if([resVideosArray isKindOfClass:[NSArray class]]){
                                                arrVideos=resVideosArray.count ? [resVideosArray mutableCopy] :nil;
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                self.lblAddToCard.text=(isCard=[self getCardDetail]) ? @"GO TO CART" : @"ADD TO CART";
                                                self.btnAddToCard.enabled=self.btnWishlist.enabled=data ? YES : NO;
                                        });
                                        
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

-(void)wishlistWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AddToWishList);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                
                
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
                                        
                                        [Alert alertWithMessage:msg
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:3.0];
                                        
                                });
                                
                                
                                if (success.boolValue) {
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                });
                        }
                        
                }
                
                
        });
        
}

-(void)getArtistListWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
                NSLog(@" tempURL :%@---",urlString);
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:@"artist" forKey:@"page"];
                NSString* postString=[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSMutableURLRequest *theRequest = [Alert getRequesteWithPostString:postString
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
                        
                        artistList =[NSJSONSerialization JSONObjectWithData:returnData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
                        
                        
                        
                        if ([artistList isKindOfClass:[NSNull class]] ||artistList == nil)
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
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [[SharedClass sharedObject] hudeHide];
                                });
                                
                                //                                NSLog(@"Response : %@", artistList);
                                NSString *success  = [artistList valueForKey:@"success"];
                                NSString *error  = [artistList valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                        NSArray*resData = (NSArray*)[artistList valueForKey:@"Artist"];
                                        
                                        
                                        if(resData.count){
                                                
                                                artistList=[Alert removedNullsWithString:@"" obj:artistList];
                                                
                                                [Alert saveToLocal:[artistList mutableCopy] key:@"artistlist"];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        
                                                        
                                                        NSLog(@"Now, Passing Artist list into Unity view \n");
                                                        
                                                        if(![MyObject sharedClass].isArtistListSet){
                                                                [MyObject setArtistList:[Alert jsonStringWithDictionary:artistList]];
                                                                
                                                        }
                                                        
                                                        NSLog(@"[ViewController] Show Unity->%@",self.artUserName);
                                                        [MyObject setArtistName:self.artUserName];
                                                        
                                                        [self setGallery];
                                                        
                                                        
                                                });
                                        }
                                        
                                        
                                        
                                        
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                }
                                
                                else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
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
        NSInteger rows=0;
        
        rows=data ? 6 :1;
        
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        
        switch (indexPath.row) {
                case 0:
                        finalHeight=  214.0f;
                        break;
                        
                case 1:
                        finalHeight= arrImages.count ? 88.0f : 0;
                        break;
                case 2:
                        finalHeight= arrVideos.count ? 88.0f : 0;
                        break;
                case 3:
                        finalHeight= data ?  60.0f : 0;
                        break;
                case 4:
                        finalHeight= data ?  110.0f : 0;
                        break;
                case 5:
                        
                        if(data){
//                        ArtDetailViewCell3 *cell =(ArtDetailViewCell3*)[self.tableView cellForRowAtIndexPath:indexPath];
                        
                        float defaultHeight=43;
                                UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 20)];
                        label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:15];
                                
                        label.text=[data objectForKey:@"art_about"];
                        label.textAlignment=NSTextAlignmentLeft;
                                label.backgroundColor=[UIColor yellowColor];
                        float height=[Alert getLabelHeight:label];
                        
                        if(isShowDesc){
                                
                                finalHeight=   height<20 ? defaultHeight+20 : defaultHeight + height +20 ;
                                finalHeight+=10;
                        }
                        else{
                                finalHeight= defaultHeight;
                        }
                        
                        }
                        else{
                                finalHeight=0;
                        }
                        break;
                default:
                        break;
        }
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
//        NSDictionary* data = [self.arrArtCategoryList objectAtIndex:indexPath.row];
       
        if(indexPath.row==0){
                ArtDetailViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.lblTime.hidden=YES;
                NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
                
                for (id view in cell.contentView.subviews) {
                        
                        if([view isKindOfClass:[UIActivityIndicatorView class]])
                                [view removeFromSuperview];
                }
                
                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator1.frame = CGRectMake(cell.imgArt.frame.size.width/2-15,
                                                     cell.imgArt.frame.size.height/2-15,
                                                     30,
                                                     30);
                [activityIndicator1 startAnimating];
                activityIndicator1.tag=indexPath.row;
                
                [activityIndicator1 removeFromSuperview];
                [cell.contentView addSubview:activityIndicator1];
                [cell.contentView insertSubview:activityIndicator1 aboveSubview:cell.imgArt];
                
                cell.imgArt.contentMode=UIViewContentModeScaleAspectFit;
                cell.imgArt.backgroundColor=[UIColor whiteColor];
                
                UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
                
                __weak UIImageView *weakImgPic = cell.imgArt;
                [cell.imgArt setImageWithURL:url
                             placeholderImage:imgPlaceHolder
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                 {
                         //                 dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator1 stopAnimating];
                         [activityIndicator1 removeFromSuperview];
                         
                         UIImageView *strongImgPic = weakImgPic;
                         if (!strongImgPic) return;
                         
                         strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                                 strongImgPic.image=image;
                         });
                         
                         [UIView transitionWithView:strongImgPic
                                           duration:0.3
                                            options:UIViewAnimationOptionTransitionCrossDissolve
                          
                                         animations:^{
                                                 // strongImgPic.image=image;
                                                 
                                         }
                                         completion:^(BOOL finish){
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                         //                                         NSIndexPath* indp=[NSIndexPath indexPathForRow:strongImgPic.tag inSection:0];
                                                         //                                         [collectionView reloadItemsAtIndexPaths:@[indp]];
                                                         
                                                 });
                                         }];
                         
                         //                 });
                         //                 [self.collectionView reloadData];
                         
                         
                 } failure:NULL];
                //        cell.backgroundColor=[UIColor yellowColor];
                cell.backgroundColor=[UIColor clearColor];
                cell.contentView.backgroundColor=[UIColor clearColor];

                
                return cell;
        }
       
        else if(indexPath.row==1){
                ArtDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell setCollectionData:[arrImages mutableCopy]];

                return cell;
        }
       
        else if(indexPath.row==2){
                
                ArtDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:@"2" forKey:@"type"];
                
                [cell setCollectionInfo:dic];
                NSArray* arrValidVideos=[self getValidUrl:arrVideos];
                [cell setCollectionData:[arrValidVideos mutableCopy]];
                
                return cell;
                
        }
        
        else if(indexPath.row==3){
                
                ArtDetailViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.btnVirtualGallery.tag=indexPath.row;
                [cell.btnVirtualGallery addTarget:self action:@selector(vrGallery:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
                
        }
        
        else if(indexPath.row==4){
                ArtDetailViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.lblName.text=[data objectForKey:@"art_name"];
                NSString* category=[data objectForKey:@"category_name"];;
                NSString* autherName=[data objectForKey:@"name"];
                
                UIColor* color1=[Alert colorFromHexString:@"#585858"];
                UIColor* color2=[Alert colorFromHexString:@"#971700"];
                
                cell.lblAutherName.text=[NSString stringWithFormat:@"%@ by %@",category,autherName];
                
                /*
                NSInteger l1=category.length;
                NSInteger l2=autherName.length;
                //        NSInteger l3=cell.lblAutherName.text.length;
                
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblAutherName.text];
                [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0,l1+4)];
                [string addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(l1+4,l2)];
                
                cell.lblAutherName.attributedText = string;
                */
                
                cell.lblAutherName.delegate=self;
                NSURL *url = [NSURL URLWithString:@"action://Expand"];
                cell.lblAutherName.linkAttributes = @{(id)kCTForegroundColorAttributeName: color2,
                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                
                NSRange r = [cell.lblAutherName.text rangeOfString:autherName];
                [cell.lblAutherName addLinkToURL:url withRange:r];
                
                
                
                cell.lblSize.text=[data objectForKey:@"art_size"];
                
                cell.lblPrice.text=[NSString stringWithFormat:@"$%@",[data objectForKey:@"art_price"]];
                
                [cell.btnFB addTarget:self action:@selector(shareOnFB:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnTW addTarget:self action:@selector(shareOnTW:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnGooglePlus addTarget:self action:@selector(shareOnGooglePlus:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnInstagram addTarget:self action:@selector(shareOnInstagram:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnEmail addTarget:self action:@selector(shareOnEmail:) forControlEvents:UIControlEventTouchUpInside];
            
                return cell;
        }
        //Artlist
        else if(indexPath.row==5){
                ArtDetailViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.lblDesc.text=[data objectForKey:@"art_about"];
                
                cell.btnShowDesc.tag=indexPath.row;
                
                [cell.btnShowDesc addTarget:self action:@selector(showDesc:) forControlEvents:UIControlEventTouchUpInside];
                
                float height=[Alert getLabelHeight:cell.lblDesc];
                
                cell.lblDesc.translatesAutoresizingMaskIntoConstraints=YES;
                
                CGRect frame=cell.lblDesc.frame;
                
                if(isShowDesc){
                        
                        frame.size.height=height<20 ? 20 : height +20 ;
                }
                else{
                        frame.size.height= 0;
                }
                frame.size.width=tableView.frame.size.width-16;
                frame.origin.x=8;
                frame.origin.y=43;
                cell.lblDesc.frame=frame;
                NSInteger numberOfLines= [Alert getLabelLines:cell.lblDesc];
                cell.lblDesc.numberOfLines =numberOfLines;
//                cell.lblDesc.backgroundColor=[UIColor yellowColor];
                
                
                [UIView transitionWithView:cell.imgShowDesc
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:^{
                                        cell.imgShowDesc.image=[UIImage imageNamed:isShowDesc ? @"minus.png" : @"plus.png"];
                                }
                                completion:nil];
                
                [UIView transitionWithView:cell
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:nil];
                
                
                
                return cell;
        }
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if(indexPath.row==0){
                
                 NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
                
                IDMPhoto *photo = [IDMPhoto photoWithURL:url];
                
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo] animatedFromView:self.view];
                [self presentViewController:browser animated:YES completion:nil];
        }
        
        
        
        
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
        
//        NSDictionary* dic=[data mutableCopy];
        
        if ([[url scheme] hasPrefix:@"action"]) {
                if ([[url host] hasPrefix:@"Expand"]) {
                        
                        ArtistDetailViewController* vc=GET_VIEW_CONTROLLER(kArtistDetailViewController);
                        vc.from=@"back";
                        vc.artUserName=[data objectForKey:@"username"];
                        vc.titleString=[data objectForKey:@"name"];
                        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        
                        
                        
                       
                } else if ([[url host] hasPrefix:@"show-settings"]) {
                        /* load settings screen */
                }
        } else {
                /* deal with http links here */
        }
}
-(void)showDesc:(id)sender{
//        UIButton* button=(UIButton*)sender
        
        isShowDesc=!isShowDesc;
        
        [self.tableView reloadData];
}
#pragma mark - FBSDKSharing

-(void)shareOnFB:(NSString*)title desc:(NSString*)desc link:(NSString*)link imgURL:(NSURL*)imgURL{
        
       FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentTitle=title;
        content.contentDescription=desc;
       content.contentURL = [NSURL URLWithString:link];
     // content.contentURL = [NSURL ur]
        content.imageURL=imgURL;
    
        [FBSDKShareDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];
    
//    FBSDKShareDialog * dialog = [[FBSDKShareDialog alloc] init];
//    [dialog setFromViewController:self];
//    [dialog setShareContent:content];
//    [dialog setMode:FBSDKShareDialogModeWeb];
//    [dialog show];
}

#pragma mark - FBSDKSharing Delegate

-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
        
        NSLog(@"%@",results);
        
        [Alert alertWithMessage:results.allKeys.count ? @"Post successfully shared ." : @"Post cancel successfully ."
                     navigation:self.navigationController gotoBack:NO animation:YES second:3.0];
}

-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
        
        
        NSLog(@"%@",error.description);
        
        
        [Alert alertWithMessage:@"Post cancel successfully ."
                     navigation:self.navigationController gotoBack:NO animation:YES second:3.0];
        
}

-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
        
        
        NSLog(@"sharerDidCancel");
        
        [Alert alertWithMessage:@"Post cancel successfully ."
                     navigation:self.navigationController gotoBack:NO animation:YES second:3.0];
        
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
                //[self disconnect];
                
                
        } else {
//                [self refreshInterfaceBasedOnSignIn];
                
                NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
                
                NSString* desc=[data objectForKey:@"art_about"];
                
                desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                
                NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/details/%@",[data objectForKey:@"id"]];
                
                NSString* title=[data objectForKey:@"art_name"];
                
                [self shareOnGooglePlus:title desc:desc link:link imgURL:url];
                
        }
}

#pragma mark - Google Plus share

-(void)shareOnGooglePlus:(NSString*)title desc:(NSString*)desc link:(NSString*)link imgURL:(NSURL*)imgURL{
        
        
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        
        
        // This line will fill out the title, description, and thumbnail from
        // the URL that you are sharing and includes a link to that URL.
        [shareBuilder setURLToShare:[NSURL URLWithString:link]];
        [shareBuilder setTitle:title description:desc thumbnailURL:imgURL];
        
//        [shareBuilder open];
        
        if(![shareBuilder open]){
                
                [self showGooglePlusShare:imgURL];
        }
        
}

- (void)showGooglePlusShare:(NSURL*)shareURL {
        
        // Construct the Google+ share URL
        NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                          initWithString:@"https://plus.google.com/share"];
        urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                      initWithName:@"url"
                                      value:[shareURL absoluteString]]];
        NSURL* url = [urlComponents URL];
        
        if ([SFSafariViewController class]) {
                // Open the URL in SFSafariViewController (iOS 9+)
                SFSafariViewController* controller = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:YES]; // 2.
                
                controller.delegate = self;
                
                [self presentViewController:controller animated:YES completion:nil];
        } else {
                // Open the URL in the device's browser
                [[UIApplication sharedApplication] openURL:url];
        }
}

- (void)finishedSharingWithError:(NSError *)error{
        
        
        NSLog(@"%@",error.description);
}

- (void)finishedSharing:(BOOL)shared{
        
        NSLog(@"Done button pressed");
        
}


#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
        // Load finished
        
        NSLog(@"Load finished");
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
        // Done button pressed
        
        NSLog(@"Done button pressed");
}


#pragma  mark - Twitter Share

/*
- (void)shareToTwitter{
//        APP_DELEGATE.navController = self.navigationController;
        
        NSString *strTwitterToken       = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterToken"];
        NSString *strTwitterTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterTokenSecret"];
        
        if (strTwitterToken && strTwitterTokenSecret)
        {
                self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY
                                                             consumerSecret:TWITTER_SECRET_KEY
                                                                 oauthToken:strTwitterToken
                                                           oauthTokenSecret:strTwitterTokenSecret];
                
                [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
//                        DLogs(@"Twitter User Name");
                        
                        [self twitterMediaUpload];
                        
                } errorBlock:^(NSError *error) {
//                        DLogs(@"-- error: %@", error);
//                        [AppConstant showAutoDismissAlertWithMessage:[error localizedDescription] onView:self.view];
                        
                        [self safariLoginTwitter];
                }];
        }
        
        else
        {
                [self safariLoginTwitter];
        }
        
}

-(void)safariLoginTwitter{
        //    [APP_CONSTANT getNativeTwitterAccountAccessToken:^(id result) {
        //
        //    }];
        
        self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY
                                                     consumerSecret:TWITTER_SECRET_KEY];
        
        [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
//                DLogs(@"-- url: %@", url);
//                DLogs(@"-- oauthToken: %@", oauthToken);
                
                [[UIApplication sharedApplication] openURL:url];
        } authenticateInsteadOfAuthorize:NO
                            forceLogin:@(YES)
                            screenName:nil
                         oauthCallback:@"myapp://twitter_access_tokens/"
                            errorBlock:^(NSError *error) {
//                                    DLogs(@"-- error: %@", error);
//                                    [AppConstant showAutoDismissAlertWithMessage:[error localizedDescription] onView:self.view];
                            }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
        
        [self.twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
//                DLogs(@"-- screenName: %@", screenName);
                
                
//                 At this point, the user can use the API and you can read his access tokens with:
//                 
//                 _twitter.oauthAccessToken;
//                 _twitter.oauthAccessTokenSecret;
//                 
//                 You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
//                 
//                 Next time, just instanciate STTwitter with the class method:
//                 
//                 +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
//                 
//                 Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
                
                
                [[NSUserDefaults standardUserDefaults] setObject:self.twitter.oauthAccessToken forKey:@"TwitterToken"];
                [[NSUserDefaults standardUserDefaults] setObject:self.twitter.oauthAccessToken forKey:@"TwitterTokenSecret"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self twitterMediaUpload];
                
        } errorBlock:^(NSError *error) {
                
//                [AppConstant showAutoDismissAlertWithMessage:[error localizedDescription] onView:self.view];
//                DLogs(@"-- %@", [error localizedDescription]);
        }];
}

-(void)twitterMediaUpload{
        //    ProfileImageBO *objProfImg = nil;
        //
        //    if ([self.objProfile.arrUserImages count]) {
        //        objProfImg = [self.objProfile.arrUserImages objectAtIndex:0];
        //    }
        
//        [APP_CONSTANT showLoaderWithTitle:@"posting" onView:self.view];
        
        //    NSURL *urlProfImg = [NSURL URLWithString:[objProfImg.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
//        NSURL *screenshotUrl = [self getScreenshotUrl];
        NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
         [self.twitter postMediaUpload:url
                   uploadProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                           
                           
                           
                   } successBlock:^(NSDictionary *imageDictionary, NSString *mediaID, NSInteger size) {
                           
                           [self postToTheTwitterWithMediaId:mediaID];
                           
                   } errorBlock:^(NSError *error) {
                           
                   }];
        
//        [self.twitter postMediaUpload:screenshotUrl
//                  uploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//               //DLogs(@"uploading");
//        } successBlock:^(NSDictionary *imageDictionary, NSString *mediaID, NSString *size) {
//                //DLogs(@"imageDictionary =  %@, mediaID = %@, size %@",imageDictionary.description,mediaID,size);
//                
//                [self postToTheTwitterWithMediaId:mediaID];
//                
//        } errorBlock:^(NSError *error) {
//               // DLogs(@"Error in uploading media, try again ...");
//                
//                //[APP_CONSTANT hideLoader];
//               // [AppConstant showAutoDismissAlertWithMessage:error.localizedDescription onView:self.view];
//        }];
}

-(void)postToTheTwitterWithMediaId:(NSString *)mediaID{
        NSString *msg = [NSString stringWithFormat:@"Check out My Profile"];
        
        [self.twitter postStatusUpdate:msg
                     inReplyToStatusID:nil
                              mediaIDs:[NSArray arrayWithObject:mediaID]
                              latitude:nil
                             longitude:nil
                               placeID:nil
                    displayCoordinates:nil
                              trimUser:nil
                          successBlock:^(NSDictionary *status) {
                //DLogs(@"Description %@",status.description);
                
                //[self showNotificationToastWithMessage:TwitterPostSuccess];
                //[APP_CONSTANT hideLoader];
                
        } errorBlock:^(NSError *error) {
               // DLogs(@"Twitter posting error %@",error.description);
                //[APP_CONSTANT hideLoader];
                
                //[AppConstant showAutoDismissAlertWithMessage:error.localizedDescription onView:self.view];
        }];
        
}


//
*/
-(void) postImageWithMessageOnTwitter:(NSString*)title desc:(NSString*)desc link:(NSString*)link imgURL:(NSURL*)imgURL{
        
        NSData* imageData=[NSData dataWithContentsOfURL:imgURL];
        UIImage* image=[UIImage imageWithData:imageData];

        SLComposeViewController *mySLComposerSheet;
        
//        NSString* msg=[[title stringByAppendingString:@"\n"] stringByAppendingString:desc];

        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
                mySLComposerSheet = [[SLComposeViewController alloc] init];
                mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [mySLComposerSheet setInitialText:[NSString stringWithFormat:title,mySLComposerSheet.serviceType]]; //the message you want to post
                [mySLComposerSheet addImage:image];
                [mySLComposerSheet addURL:[NSURL URLWithString:link]];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                                message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Settings",nil];
                alert.tag=100;
                [alert show];

        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output;
                switch (result) {
                        case SLComposeViewControllerResultCancelled:
                                output = @"Action Cancelled";
                                break;
                        case SLComposeViewControllerResultDone:
                                output = @"Post Successfull";
                                break;
                        default:
                                break;
                } //check if everything worked properly. Give out a message on the state.
                
                [Alert alertWithMessage:output
                             navigation:self.navigationController
                               gotoBack:NO animation:YES second:2.0];
                
        }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        switch (alertView.tag) {
                case 100:
                {
                        if (buttonIndex == 0)
                        {
                                
                                
                        }
                        if (buttonIndex == 1)
                        {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
                                
                        }
                        
                }
                        break;
                case 101:
                {
                        if (buttonIndex == 0)
                        {
                                
                                
                        }
                        if (buttonIndex == 1)
                        {
                                LoginViewController*vc=GET_VIEW_CONTROLLER_STORYBOARD(kLoginViewController);
                                vc.titleString=@"Login";
                                //vc.from=@"back";
                                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                                
                        }
                }
                        break;
                        
                default:
                        break;
        }
        
}


#pragma mark - Instagram 

-(void)shareOnInstagram{
        NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
        
        //        NSData *data = [NSData dataWithContentsOfURL:url];
        //        UIImage *img = [[UIImage alloc] initWithData:data];
        
        UIImageView* temp=[[UIImageView alloc]init];
        __weak UIImageView *weakImgPic = temp;
        
        [temp setImageWithURL:url
             placeholderImage:nil
                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 //                 dispatch_async(dispatch_get_main_queue(), ^{
                 
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                         strongImgPic.image=image;
                 });
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                         // strongImgPic.image=image;
                                         
                                 }
                                 completion:^(BOOL finish){
                                         
                                         SignInViewController* signInViewC = [[SignInViewController alloc] initWithNibName:@"SignInView" bundle:nil];
                                         
                                         signInViewC.shareImage=image;
                                         signInViewC.fileName=[data objectForKey:@"id"];
                                         
                                         
                                         MOVE_VIEW_CONTROLLER_VIEW_DECK(signInViewC);
                                 }];
                 
                 
         } failure:NULL];
        
}

#pragma mark - Email

-(void)email{
        if (!TARGET_IPHONE_SIMULATOR) {
                
                NSString* title=[data objectForKey:@"art_name"];
                NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/details/%@",[data objectForKey:@"id"]];
                NSString* desc=[data objectForKey:@"art_about"];
                
                desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                
                NSString* fileName=[data objectForKey:@"art_image"];
                fileName=[fileName lastPathComponent];
                
                NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
                
                NSMutableString *body = [NSMutableString string];
                // add HTML before the link here with line breaks (\n)
                [body appendString:@"<b>Art Name </b>"];
                [body appendString:[NSString stringWithFormat:@": %@ <br>",title]];
                
                [body appendString:[NSString stringWithFormat:@"<a href=\"%@\"> Click here for details </a><br>",link]];
                
                [body appendString:@"<b> Description </b>"];
                [body appendString:[NSString stringWithFormat:@": %@ <h3></h3>",desc]];
                
                [Alert performBlockWithInterval:0.30 completion:^{
                        [self sendEmail:title
                                   desc:desc
                                   link:link
                                 imgURL:url
                               fileName:fileName
                                   body:body];
                }];
                
        } else {
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"Your device doesn't support this feature."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [notPermitted show];;
        }
}

-(void)sendEmail:(NSString*)title desc:(NSString*)desc link:(NSString*)link imgURL:(NSURL*)imgURL fileName:(NSString*)fileName body:(NSString*)body{
        
        if ([MFMailComposeViewController canSendMail])
        {
                
                UIImageView* temp=[[UIImageView alloc]init];
                __weak UIImageView *weakImgPic = temp;
                
                [temp setImageWithURL:imgURL
                     placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                 {
                         
                         UIImageView *strongImgPic = weakImgPic;
                         if (!strongImgPic) return;
                         
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                                 strongImgPic.image=image;
                         });
                         
                         [UIView transitionWithView:strongImgPic
                                           duration:0.3
                                            options:UIViewAnimationOptionTransitionCrossDissolve
                          
                                         animations:^{
                                                 
                                         }
                                         completion:^(BOOL finish){

                                                 MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                                                 mail.mailComposeDelegate = self;
                                                 [mail setSubject:@"Easton Art Galleries"];
                                                 [mail setMessageBody:body isHTML:YES];
                                                 [mail setToRecipients:Nil];
                                                 
                                                 NSData *imageData = UIImagePNGRepresentation(image);
                                                 [mail addAttachmentData:imageData mimeType:@"image/png"   fileName:fileName];
                                                 
                                                 
                                                 [self presentViewController:mail animated:YES completion:NULL];
                                         }];
                         
                         
                 } failure:NULL];
               
        }
        else
        {
                NSLog(@"This device cannot send email !Please add an account in Settings");
                
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"This device cannot send email !Please add an account in Settings."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [notPermitted show];
                
                
        }
        
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
        switch (result) {
                case MFMailComposeResultSent:
                        NSLog(@"You sent the email.");
                        break;
                case MFMailComposeResultSaved:
                        NSLog(@"You saved a draft of this email");
                        break;
                case MFMailComposeResultCancelled:
                        NSLog(@"You cancelled sending this email.");
                        break;
                case MFMailComposeResultFailed:
                        NSLog(@"Mail failed:  An error occurred when trying to compose this email");
                        break;
                default:
                        NSLog(@"An error occurred when trying to compose this email");
                        break;
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Target Methods

-(IBAction)shareOnFB:(id)sender{
    
        NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
        
        NSString* desc=[data objectForKey:@"art_about"];
        
        desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSString* link=[NSString stringWithFormat:@"https://www.eastonartgalleries.com/details/%@",[data objectForKey:@"id"]];
        
        NSString* title=[data objectForKey:@"art_name"];
        [self shareOnFB:title desc:desc link:link imgURL:url];
        
}

-(IBAction)shareOnTW:(id)sender{
        
        NSURL* url=[NSURL URLWithString:isSelectedImage ? seletedImageURL :[data objectForKey:@"art_image"]];
        
        NSString* desc=[data objectForKey:@"art_about"];
        
        desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/details/%@",[data objectForKey:@"id"]];
        
        
        NSString* title=[data objectForKey:@"art_name"];
        
        [self postImageWithMessageOnTwitter:title desc:desc link:link imgURL:url];
    
}

-(IBAction)shareOnGooglePlus:(id)sender{
        
        [self initiliseGooglePlus];
        
}

-(IBAction)shareOnInstagram:(id)sender{
        
        [self shareOnInstagram];
}

-(IBAction)shareOnEmail:(id)sender{
        
        [self email];
}





#pragma mark - Action Methods

- (IBAction)addToCard:(id)sender {
        
        BOOL isSold=[[data objectForKey:@"quantity"] intValue]==0 ? YES : NO;
        
        
        
        if(isSold){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ADD TO CART"
                                                                message:@"Already sold !"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
        }
        else if(data && !isCard){
                CardDetailModel* card=[[CardDetailModel alloc]init];
                card.ID                 =[[data objectForKey:@"id"] intValue];
                card.ART_NAME           =[data objectForKey:@"art_name"];
                card.ARTIST_NAME        =[data objectForKey:@"name"];
                card.ART_URL            =[data objectForKey:@"art_image"];
                card.ART_CATEGORY       =[data objectForKey:@"category_name"];
                card.QUANTITY           =1;
                card.PRICE              =[data objectForKey:@"art_price"];
                card.ART_SIZE           =[data objectForKey:@"art_size"];
                card.SORT               =(int)[dataManager getCardSortMax]+1;
                
                [dataManager insertAndUpdateCardDetailWithArrayUsingTrasaction:@[card]];
                
                [self loadCardCount];
                
                 self.lblAddToCard.text=(isCard=[self getCardDetail]) ? @"GO TO CART" : @"ADD TO CART";
                
                
                [Alert performBlockWithInterval:0.05 completion:^{
                        
                        [[EAGallery sharedClass] flipView:cardCountViewGlobal];
                }];
        }else{
                CardDetailViewController*vc=GET_VIEW_CONTROLLER(kCardDetailViewController);
                vc.titleString=@"Your Cart";
                vc.from=@"back";
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        }
        
}

- (IBAction)wishlist:(id)sender {
        
        //{"user_id":"53","pid":"103"}
        
        if([[EAGallery sharedClass] isLogin]){
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"];
                [dic setObject:[data objectForKey:@"id"]                forKey:@"pid"];
                
                [self wishlistWebService:[dic mutableCopy]];
        }
        else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LOGIN"
                                                                message:@"Please login first !"
                                                               delegate:self
                                                      cancelButtonTitle:@"CANCEL"
                                                      otherButtonTitles:@"LOGIN",nil];
                alert.tag=101;
                [alert show];
        }
        
}

-(IBAction)vrGallery:(id)sender{
        
#if IS_UNITY_USE
        
        if(data){
                self.artUserName=[data objectForKey:@"username"];
                NSLog(@"[ViewController] Show Unity->%@",self.artUserName);
                
                [self loadGallery];
        }
#else
        [Alert alertWithMessage:@"First Enable Virtual gallery code and Add relevant files in project !"
                     navigation:self.navigationController
                       gotoBack:NO animation:YES second:5.0];
        
#endif
}

@end
