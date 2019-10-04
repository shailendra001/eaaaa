//
//  AuctionDetailViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 17/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "AuctionDetailViewController.h"
#import "ArtistDetailViewController.h"
#import "ArtDetailViewCell1.h"
#import "AuctionDetailTableViewCell.h"
#import "AuctionDetailTableViewCell2.h"
#import "ArtDetailCell4.h"
#import "SelectionListViewController.h"
#import "CurrentBiddersViewController.h"


#define COLOR_CELL_BACKGROUND   @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"


@interface AuctionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,FBSDKSharingDelegate,SFSafariViewControllerDelegate,GPPSignInDelegate,MFMailComposeViewControllerDelegate,TTTAttributedLabelDelegate,NIDropDownDelegate,SelectionListDelegate,MZTimerLabelDelegate>
{
        NSDictionary *data;
        NSMutableArray* arrImages;
        NSArray* arrVideos;
        NSDictionary* dicAuctionDetail;
        NSDictionary* dicCurrentWinner;
        UIActivityIndicatorView *activityIndicator;
        BOOL isShowDesc;
        BOOL isSelectedImage;
        NSString* seletedImageURL;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        BOOL isCard;
        NSDictionary * artistList;
        NSMutableArray* arrAmount;
        NSString* selectedAmount;
        NSArray* arrBidderList;
}


@end

@implementation AuctionDetailViewController


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
                
                self.viContainerPlaceBid.hidden=self.viContainerCurrentBidders.hidden=YES;
                
                [self setActivityIndicator];
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

#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        //self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        self.view.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        
//        [self.btnCurrentBidders setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.viContainerCurrentBidders.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
//        [Alert setShadowOnViewAtTop:self.viContainerAddToCart];
//        [Alert setShadowOnViewAtTop:self.viContainerBuyNow];
//        [Alert setShadowOnViewAtTop:self.lblSeparatorLineVirtical];
#endif
        
//        [MyObject sharedClass].delegate=self;
        
        
        arrAmount=[[NSMutableArray alloc]init];
        
        [arrAmount addObject:@"3000 USD"];
        [arrAmount addObject:@"4000 USD"];
        [arrAmount addObject:@"5000 USD"];
        
}

-(void)registerCell{
        
        [self.tableView registerClass:[ArtDetailViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[AuctionDetailTableViewCell class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[AuctionDetailTableViewCell2 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[ArtDetailCell4 class]     forCellReuseIdentifier:CellIdentifier4];
      //  [self.tableView registerClass:[ArtDetailViewCell5 class] forCellReuseIdentifier:CellIdentifier5];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:NSStringFromClass([ArtDetailViewCell1 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib2 = [UINib nibWithNibName:NSStringFromClass([AuctionDetailTableViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];

        UINib *contantsCellNib3 = [UINib nibWithNibName:NSStringFromClass([AuctionDetailTableViewCell2 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
//
//        UINib *contantsCellNib4 = [UINib nibWithNibName:@"ArtDetailViewCell5" bundle:nil];
//        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier5];
        
        
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
        
//        self.lblAddToCard.text=(isCard=[self getCardDetail]) ? @"GO TO CART" : @"ADD TO CART";
        
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

-(NSArray*)getValidUrl:(NSArray*)arr{
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

- (NSArray *)extractYoutubeIdFromLinkWithArray:(NSArray*)arr {//:(NSString *)link {
        
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        for (NSString* link in arr) {
                
                NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
                NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                          error:nil];
                
                NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
                if (array.count > 0) {
                        NSTextCheckingResult *result = array.firstObject;
                        
                        [arrResult addObject:[link substringWithRange:result.range]];
        //                return [link substringWithRange:result.range];
                }
        //        return nil;
                
        }
        
        
        return  arrResult.count ? arrResult : nil;
}

#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromCollectionView:(NSNotification *)notification{
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
//                        NSArray*arr=[fileName componentsSeparatedByString:@"="];
//                        NSString*videoID=arr.count==2 ? arr[1] : nil;
                        NSString*videoID=fileName;
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
                
                
         //       NSString *urlString = @"http://eastern.psgahlout.com/services/artservices/auctionDetails";
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AUCTION_ART_DETAIL);
                //{"pid":"1462","uid":"92"}
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:self.artID forKey:@"pid"];
                [dic setObject:[EAGallery sharedClass].memberID forKey:@"uid"];
                
                
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
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if(data)                        [self removeBackgroundLabel];
                                else                            [self setBackgroundLabel];
                                [self.tableView reloadData];
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
                                        if(data)                        [self removeBackgroundLabel];
                                        else                            [self setBackgroundLabel];
                                        [self.tableView reloadData];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                        _baseURL = (NSString*)[result valueForKey:@"base_url"];
                                        
                                        NSArray*resDetailArray = (NSArray*)[result valueForKey:@"ArtDetails"];
                                        NSArray*resImagesArray = (NSArray*)[result valueForKey:@"ArtImages"];
                                        NSArray*resVideosArray = (NSArray*)[result valueForKey:@"ArtVideo"];
                                        
                                        NSArray*resAuctionDetailArray = (NSArray*)[result valueForKey:@"AuctionDetails"];
                                        NSArray*resCurrentWinnerArray = (NSArray*)[result valueForKey:@"currentWinner"];
                                        
                                        NSArray*resBidderListArray = (NSArray*)[result valueForKey:@"BidderList"];
                                        
                                        
                                        
                                        if([resDetailArray isKindOfClass:[NSArray class]]){
                                                data=resDetailArray.count ? [resDetailArray firstObject] :nil;
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
                                        
                                        if([resAuctionDetailArray isKindOfClass:[NSArray class]]){
                                                dicAuctionDetail=resAuctionDetailArray.count ? [resAuctionDetailArray firstObject] :nil;
                                        }
                                        if([resCurrentWinnerArray isKindOfClass:[NSArray class]]){
                                                dicCurrentWinner=resCurrentWinnerArray.count ? [resCurrentWinnerArray firstObject] :nil;
                                        }
                                        if([resBidderListArray isKindOfClass:[NSArray class]]){
                                                arrBidderList=resBidderListArray.count ? [resBidderListArray mutableCopy] :nil;
                                        }
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [UIView transitionWithView:self.tableView
                                                                  duration:0.3
                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                 
                                                                animations:nil
                                                                completion:nil];
                                                
                                                
                                                self.viContainerPlaceBid.hidden=self.viContainerCurrentBidders.hidden=NO;
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

-(void)placeBidWebService{
        
        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_PLACE_BID);
                //{"uid":"92","pid":"1462","amount":"175"}
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:self.artID forKey:@"pid"];
                [dic setObject:selectedAmount forKey:@"amount"];
                [dic setObject:[EAGallery sharedClass].memberID forKey:@"uid"];
                
                
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
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if(data)                        [self removeBackgroundLabel];
                                else                            [self setBackgroundLabel];
                                [self.tableView reloadData];
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
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(data)                        [self removeBackgroundLabel];
                                        else                            [self setBackgroundLabel];
                                        [self.tableView reloadData];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                NSString *msg  = [result valueForKey:@"WalletAmountMessage"];
                                
                                if (success.boolValue) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                [Alert alertWithMessage:msg
                                                             navigation:self.navigationController
                                                               gotoBack:NO
                                                              animation:YES second:5.0];
                                        });
                                        
                                        //Update Credit Balance
                                        NSString* bal           =[result valueForKey:LOGIN_WALLET_AMOUNT];
                                        
                                        if(!IS_EMPTY(bal)){
                                                //Update User info
                                                [EAGallery sharedClass].walletAmount=bal;
                                                [[EAGallery sharedClass] saveDataLocal];
                                        }

                                        data=nil;
                                        selectedAmount=nil;
                                        self.viContainerPlaceBid.hidden=self.viContainerCurrentBidders.hidden=YES;
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self setActivityIndicator];
                                                [self getWebService];
                                                
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        rows=data ? 5 :0;
        
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        
        switch (indexPath.row) {
                case 0:
                        finalHeight=  235.0f;
                        break;
                        
                case 1:
                        finalHeight= arrImages.count ? 88.0f : 0;
                        break;
                case 2:
                        finalHeight= arrVideos.count ? 88.0f : 0;
                        break;
//                case 3:
//                        finalHeight= data ?  60.0f : 0;
//                        break;
                case 3:
                        finalHeight= data ?  110.0f : 0;
                        break;
                case 4:
                        
                        finalHeight=  79.0f;
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
                
//                NSString* path=_baseURL ? [_baseURL stringByAppendingString:[data objectForKey:@"art_image"]] : [data objectForKey:@"art_image"];
                
//                NSURL* url=[NSURL URLWithString:path];
                
                
                
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
                
                if(dicAuctionDetail){
                        cell.lblTime.hidden=NO;
                        NSDate* bidEndDate=[[Alert getDateFormatWithString:DATE_FORMAT_UTC] dateFromString:[dicAuctionDetail objectForKey:@"bid_end_date"]];
                        cell.lblTime = [[MZTimerLabel alloc] initWithLabel:cell.lblTime andTimerType:MZTimerLabelTypeTimer];
                        [cell.lblTime setCountDownToDate:bidEndDate]; //** Or you can use [timer3 setCountDownToDate:aDate];
                        [cell.lblTime start];
                        cell.lblTime.delegate=self;
                }
                else cell.lblTime.hidden=YES;
                
                
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
//                NSArray* arrValidVideos=[self getValidUrl:arrVideos];
                NSArray* arrValidVideos=[self extractYoutubeIdFromLinkWithArray:arrVideos];
                [cell setCollectionData:[arrValidVideos mutableCopy]];
                
                return cell;
                
        }
        /*
        
        else if(indexPath.row==3){
                
                ArtDetailViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.btnVirtualGallery.tag=indexPath.row;
                [cell.btnVirtualGallery addTarget:self action:@selector(vrGallery:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
                
        }
        */
        else if(indexPath.row==3){
                AuctionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString* category=[data objectForKey:@"category_name"];;
                NSString* autherName=[data objectForKey:@"name"];
                
                
                
                UIColor* color1=[Alert colorFromHexString:@"#585858"];
                UIColor* color2=[Alert colorFromHexString:@"#971700"];
                
                cell.lblArtName.text=[data objectForKey:@"art_name"];
                cell.lblState.text=[data objectForKey:@"count_name"];
                cell.lblAutherName.text=[NSString stringWithFormat:@"%@ by %@",category,autherName];
                
                
                cell.lblAutherName.delegate=self;
                NSURL *url = [NSURL URLWithString:@"action://Expand"];
                cell.lblAutherName.linkAttributes = @{(id)kCTForegroundColorAttributeName: color2,
                                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                
                NSRange r = [cell.lblAutherName.text rangeOfString:autherName];
                [cell.lblAutherName addLinkToURL:url withRange:r];
                
                
                
                cell.lblDesc.text=[data objectForKey:@"art_size"];
                
//                cell.lblDesc.text=[NSString stringWithFormat:@"$%@",[data objectForKey:@"art_price"]];
                
               
                return cell;
        }
        
        //Artlist
        else if(indexPath.row==4){
                AuctionDetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString* max=[dicAuctionDetail objectForKey:@"bid_max_price"];
                NSString* min=[dicAuctionDetail objectForKey:@"bid_min_price"];
                NSString* win=[dicCurrentWinner objectForKey:@"amount"];
                
                
                BOOL isWinner=([max integerValue]==[win integerValue]);
                
                cell.lblEstimationValue.text=[NSString stringWithFormat:@"%@-%@ USD",min,max];
                cell.lblCurrentBidValue.text=[NSString stringWithFormat:@"%@ USD",win];
                
                cell.lblCurrentBidValue.textColor=isWinner ?[UIColor redColor] :[Alert colorFromHexString:COLOR_CELL_TEXT];
                cell.btnChooseAmount.enabled=isWinner ? NO : YES;
                
                cell.lblChooseAmoutValue.text=IS_EMPTY(selectedAmount) ? @"Choose Amount" : [NSString stringWithFormat:@"$ %@",selectedAmount];
                cell.btnChooseAmount.tag=indexPath.row;
                [cell.btnChooseAmount addTarget:self action:@selector(chooseAmount:) forControlEvents:(UIControlEventTouchUpInside)];
                /*
                cell.lblEstimationValue.text=[data objectForKey:@"art_about"];
                
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
                
                
                */
                return cell;
                 
                 
        }
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if(indexPath.row==0){
//                NSString* path=_baseURL ? [_baseURL stringByAppendingString:[data objectForKey:@"art_image"]] : [data objectForKey:@"art_image"];
                
//                NSURL* url=[NSURL URLWithString:path];
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
        //        UIButton* button=(UIButton*)sender;
        
        isShowDesc=!isShowDesc;
        
        [self.tableView reloadData];
}

-(void)chooseAmount:(id)sender{
        UIButton* button=(UIButton*)sender;
        SelectionListViewController *vc = GET_VIEW_CONTROLLER(kSelectionListViewController);
        vc.tag=button.tag;
        vc.delegate=self;
//        vc.arrList=[arrAmount mutableCopy];        
        vc.artID=self.artID;
        vc.titleString=@"Choose Amount";
        UINavigationController* nav=[[UINavigationController alloc]initWithRootViewController:vc];
        PRESENT_VIEW_CONTOLLER(nav, YES);
}

#pragma mark - Selection List Delegate

-(void)selectionListValue:(NSString *)name tag:(long)tag{
        
        selectedAmount=name;
        
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow:tag inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - MZTimerLabel DELEGATE Method

- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
        
        timerLabel.text=@"Timer Finished!";
        
        //        NSString *msg = [NSString stringWithFormat:@"Countdown of Example 6 finished!\nTime counted: %i seconds",(int)countTime];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil];
        //        [alertView show];
}

- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time{
        NSDate *leftDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
        NSDate *today10am =[NSDate date];
        
        NSInteger seconds = [leftDate timeIntervalSinceDate:today10am];
        
        NSInteger days = (int) (floor(seconds / (3600 * 24)));
        if(days) seconds -= days * 3600 * 24;
        
        NSInteger hours = (int) (floor(seconds / 3600));
        if(hours) seconds -= hours * 3600;
        
        NSInteger minutes = (int) (floor(seconds / 60));
        if(minutes) seconds -= minutes * 60;
        
        
        NSString* daysString=(days<10)? [NSString stringWithFormat:@"0%ld",days] : [NSString stringWithFormat:@"%ld",days];
        NSString* hoursString=(hours<10)? [NSString stringWithFormat:@"0%ld",hours] : [NSString stringWithFormat:@"%ld",hours];
        NSString* minutesString=(minutes<10)? [NSString stringWithFormat:@"0%ld",minutes] : [NSString stringWithFormat:@"%ld",minutes];
        NSString* secondsString=(seconds<10)? [NSString stringWithFormat:@"0%ld",seconds] : [NSString stringWithFormat:@"%ld",seconds];
        
        //        if([timerLabel isEqual:timerExample9]){
        //                int second = (int)time  % 60;
        //                int minute = ((int)time / 60) % 60;
        //                int hours = time / 3600;
        //                int days = time / 3600 * 24;
        return [NSString stringWithFormat:@"%@ days %@:%@:%@",daysString,hoursString,minutesString,secondsString];
        //        }
        //        else
        //                return nil;
}



- (IBAction)currentBidders:(id)sender {
        
        
        CurrentBiddersViewController* vc=GET_VIEW_CONTROLLER(kCurrentBiddersViewController);
        vc.from=@"back";
        vc.titleString=@"Current Bidders";
        vc.arrList=[arrBidderList mutableCopy];
        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
}

- (IBAction)placeBid:(id)sender {
        NSString* max=[dicAuctionDetail objectForKey:@"bid_max_price"];
//        NSString* min=[dicAuctionDetail objectForKey:@"bid_min_price"];
        NSString* win=[dicCurrentWinner objectForKey:@"amount"];
        BOOL isWinner=([max integerValue]==[win integerValue]);
        
        
        if(![[EAGallery sharedClass]isLogin]){
                
                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                
                LoginViewController*vc=GET_VIEW_CONTROLLER(kLoginViewController);
                vc.titleString=@"Login";
                
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                
                return;
        }
        
        if(isWinner){
                [Alert alertWithMessage:@"Max bid already placed !"
                             navigation:self.navigationController
                               gotoBack:NO
                              animation:YES second:3.0];
        }
        else if(IS_EMPTY(selectedAmount)){
                [Alert alertWithMessage:@"Please choose bid amount first !"
                             navigation:self.navigationController
                               gotoBack:NO
                              animation:YES second:3.0];
                
        }
        else if([selectedAmount integerValue]<=[[EAGallery sharedClass].walletAmount integerValue]){
                //Place bid
                [self placeBidWebService];
        }
        else{
                AddAmountViewController* vc=GET_VIEW_CONTROLLER(kAddAmountViewController);
                vc.from=@"back";
                MOVE_VIEW_CONTROLLER(vc, YES);
        }
        
}


@end
