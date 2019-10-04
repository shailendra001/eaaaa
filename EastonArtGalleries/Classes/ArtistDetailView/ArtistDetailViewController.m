//
//  ArtistDetailViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 30/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "ArtistDetailViewCell1.h"
#import "ArtistDetailViewCell2.h"
#import "ArtistDetailCell3.h"
#import "ArtistDetailViewCell4.h"
#import "ArtDetailViewController.h"
#import "ArtCollectionViewController.h"
#import "ReviewViewController.h"
#import "ContentAboutViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
//#include "UnityViewControllerBaseiOS.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"
#define COLOR_CELL_TITLE        @"#840F16"
#define VIDEO_KEY               @"vediolink"



@interface ArtistDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EDStarRatingProtocols,EDStarRatingProtocol,DLStarRatingDelegate,FBSDKSharingDelegate,SFSafariViewControllerDelegate,TTTAttributedLabelDelegate,GPPSignInDelegate,MyObjectDelegate,MFMailComposeViewControllerDelegate>
{
        NSDictionary *data;
        UIActivityIndicatorView *activityIndicator;
        BOOL isShowDesc;
        NSArray* arrHeaderTitle;
        NSArray* arrArtList;
        NSArray* arrReview;
        NSString* baseURL;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        NSDictionary * artistList;
        BOOL isDataRecievedFromServer;
}


@end

@implementation ArtistDetailViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";

/*
 
 NSString* coverImage=[data objectForKey:@"coverImage"];
 
 //Cover image
 NSURL* url=[NSURL URLWithString:IS_EMPTY(coverImage) ? nil : coverImage ];
 
 */
#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        self.viContainerTitleBar.hidden  = YES;
        [self cellRegister];
        
        [self config];
        
        [self loadProfilePic];
        
        [self setSharedIcons];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        if(!self.arrArtistDetail.count)
        {
                
                [self setActivityIndicator];
                
                [self getWebService];
        }
        
//        [self loadArtistList];
        
        
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];

      //  UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        
       // [self autorotateToInterfaceOrientation:deviceOrientation];
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

- (BOOL)prefersStatusBarHidden {
        return ![AppDelegate appDelegate].isAppEastonArt;
}

#pragma mark - Custom Methods

-(void)config{
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        NSString* firstName=[self.titleString stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                      withString:[[self.titleString substringToIndex:1] capitalizedString]];
        arrHeaderTitle=@[
                         @"Biography",
                         [NSString stringWithFormat:@"Video of %@",[Alert getFirstName:firstName]],
                         @"Reviews",
                         [NSString stringWithFormat:@"Artworks from %@",[Alert getFirstName:firstName]],
                         ];
        
        
        
        self.lblTitle.text=[self.titleString uppercaseString];
        
        //Adjust font
        self.lblTitle.numberOfLines = 1;
        self.lblTitle.minimumScaleFactor =  8./self.lblTitle.font.pointSize;
        self.lblTitle.adjustsFontSizeToFitWidth = YES;
        
        //
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
#endif
        
        [MyObject sharedClass].delegate=self;
        
}

-(void)setSharedIcons {
        
        self.btnFB.layer.cornerRadius=self.btnFB.frame.size.width/2;
        self.btnFB.layer.masksToBounds=YES;
        
        self.btnTW.layer.cornerRadius=self.btnTW.frame.size.width/2;
        self.btnTW.layer.masksToBounds=YES;
        
        self.btnGooglePlus.layer.cornerRadius=self.btnGooglePlus.frame.size.width/2;
        self.btnGooglePlus.layer.masksToBounds=YES;
        
        self.btnInstagram.layer.cornerRadius=self.btnInstagram.frame.size.width/2;
        self.btnInstagram.layer.masksToBounds=YES;
        
        self.btnEmail.layer.cornerRadius=self.btnEmail.frame.size.width/2;
        self.btnEmail.layer.masksToBounds=YES;
        
        
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
        
        [self.tableView registerClass:[ArtistDetailViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[ArtistDetailViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[ArtistDetailCell3 class]     forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[ArtistDetailViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"ArtistDetailViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"ArtistDetailViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
//
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"ArtistDetailViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromArtWorksContainerCellView:) name:@"didSelectItemFromArtWorksContainerCellView" object:nil];
        
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
        messageLabel.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:16];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)removeBackgroundLabel{
        self.tableView.backgroundView = nil;
}

-(void)loadProfilePic{
        
        //Profile image
        NSURL* urlProfile = data ? [NSURL URLWithString:[data objectForKey:@"profileImage"]] : nil;
        
        
        self.imgProfilePic.contentMode=UIViewContentModeScaleAspectFit;
        
        UIImage* imgProfilePlaceHolder=[UIImage imageNamed:@"default_user.png"];
        
        __weak UIImageView *weakImgProfilePic = self.imgProfilePic;
        __weak UIView *weakViewContainer = self.viContainerTitleBar;
        
        
                [self.imgProfilePic setImageWithURL:urlProfile
                                   placeholderImage:imgProfilePlaceHolder
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                 {
                         
                         
                         UIImageView *strongImgPic = weakImgProfilePic;
                         UIView *strongViewContainer = weakViewContainer;
                         
                         if (!strongImgPic) return;
                         
                         strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                         
                         
                         
                         [UIView transitionWithView:strongImgPic
                                           duration:0.3
                                            options:UIViewAnimationOptionTransitionCrossDissolve
                          
                                         animations:^{
                                                 
                                                 
                                                 strongImgPic.image=image;
                                                 strongViewContainer.hidden = NO;
                                         }
                                         completion:^(BOOL finish){
                                                 
                                                 
                                         }];
                         
                         
                 } failure:NULL];
                
        

        
        self.imgProfilePic.layer.cornerRadius=self.imgProfilePic.frame.size.width/2;
        self.imgProfilePic.layer.masksToBounds=YES;
        self.imgProfilePic.layer.borderWidth=2;
        self.imgProfilePic.layer.borderColor=[UIColor whiteColor].CGColor;
        
       // self.imgProfilePic.layer.masksToBounds = NO;
        //self.imgProfilePic.layer.shadowColor = [UIColor grayColor].CGColor;
       // self.imgProfilePic.layer.shadowOpacity = 1;
       // self.imgProfilePic.layer.shadowRadius = 0.0;
       // self.imgProfilePic.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        

//#if SHADOW_ENABLE
//        [Alert setShadowOnViewAtBottom:self.imgProfilePic];
//#endif

        //self.imgProfilePic.layer.masksToBounds=YES;
        
        
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
        
        
        [AppDelegate appDelegate].isAppEastonArt=NO;
        
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

#pragma mark - NSNotification to select table cell

- (void)didSelectItemFromArtWorksContainerCellView:(NSNotification *)notification{
        NSDictionary *cellData = [notification object];
        if (cellData)
        {
                NSLog(@"%@",cellData);
                
                ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
                vc.from=@"back";
                vc.artID=[cellData objectForKey:@"id"];
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                
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

#pragma mark -Get Action from More buttons

-(IBAction)moreButton:(id)sender{
        UIButton* button=(UIButton*)sender;
        
        switch (button.tag) {
                case 0:
                        
                        break;
                case 1:
                        
                        break;
                case 2:
                {
                        ReviewViewController* vc=GET_VIEW_CONTROLLER(kReviewViewController);
                        vc.arrArtistReviews=[arrReview mutableCopy];
                        vc.titleString=[arrHeaderTitle objectAtIndex:button.tag];
                        vc.from=@"back";
                        if(arrReview.count)
                                [Alert performBlockWithInterval:0.30 completion:^{
                                        
                                        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                                }];
                        
                }
                        break;
                case 3:
                {
                        ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                        vc.arrArtCollectionList=[arrArtList mutableCopy];
                        vc.titleString=[arrHeaderTitle objectAtIndex:button.tag];
                        vc.from=@"back";
                        vc.baseURL=baseURL;
                        if(arrArtList.count)
                                [Alert performBlockWithInterval:0.30 completion:^{
                                        
                                        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                                }];
                }
                        break;
                        
                default:
                        break;
        }
        
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


#pragma mark - Play selected Youtube Video

- (void) didSelectYoutubeVideo:(id)sender{
        
                NSLog(@"%@",[data objectForKey:VIDEO_KEY]);
        
//                NSString* fileName=[[data objectForKey:VIDEO_KEY] lastPathComponent];
        
                //video
//                NSArray*arr=[fileName componentsSeparatedByString:@"="];
//                NSString*videoID=arr.count==2 ? arr[1] : nil;
                NSString* fileName=[Alert getYoutubeIdFromLink:[data objectForKey:VIDEO_KEY]];
                NSString*videoID=fileName;
                XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
                //                videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
                videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
                [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
                        
                        
                
}

#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification {
        
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



#pragma mark ====: STAR RATING DELEGATE METHOD :====
-(void)starSelectionChanged:(EDStarRatings *)control rating:(float)rating{
//        if( [control isEqual:_starRatings] )
//                ratingString = [NSString stringWithFormat:@"%.1f", rating];
//        else
                NSLog(@"%f",rating);
}

#pragma mark ====: STAR RATING OF USER :====
-(void)starRatingOfUser:(float)rate cell:(ArtistDetailViewCell2*)cell {
        
        // Setup control using iOS7 tint Color
        cell.viContainerRating.backgroundColor  = [UIColor clearColor];
        cell.viContainerRating.starImage = [[UIImage imageNamed:@"star-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.viContainerRating.starHighlightedImage = [[UIImage imageNamed:@"star-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.viContainerRating.maxRating = 5.0;
        cell.viContainerRating.delegate = self;
        cell.viContainerRating.horizontalMargin = 1.0;
        cell.viContainerRating.editable = NO;
        cell.viContainerRating.rating= rate;
        cell.viContainerRating.displayMode=EDStarRatingDisplayHalf;
        [cell.viContainerRating  setNeedsDisplay];
        cell.viContainerRating.tintColor = [UIColor yellowColor];
        //        [self starsSelectionChanged:cell.starRating rating:2.5];
}

#pragma mark -Delegate implementation of NIB instatiated DLStarRatingControl

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
        NSLog(@"%@",[NSString stringWithFormat:@"%0.1f star rating",rating]);
}

-(void)DLStarRatingOfUser:(float)rate cell:(ArtistDetailViewCell2*)cell{
        DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:cell.viContainerRating.frame andStars:5 isFractional:YES];
        customNumberOfStars.delegate = self;
        customNumberOfStars.backgroundColor = [UIColor clearColor];
        customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        customNumberOfStars.rating = rate;
        [cell.contentView addSubview:customNumberOfStars];
        [cell.contentView insertSubview:customNumberOfStars belowSubview:cell.viContainerRating];
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

#pragma mark - Call WebService

-(void)getWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ArtistDetail);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:self.artUserName forKey:@"artist_name"];//{"artist_name":"deepak"}
            
                
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
                                [self setBackgroundLabel];
                                [self removeActivityIndicator];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self setBackgroundLabel];
                                        [self removeActivityIndicator];
                                });
                        }
                        else
                        {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self removeActivityIndicator];
                                });
                                
//                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        

                                        NSArray*resData = (NSArray*)[result valueForKey:@"userid"];
                                        NSArray*resReview = (NSArray*)[result valueForKey:@"review"];
                                        NSArray*resArtList = (NSArray*)[result valueForKey:@"Artlist1"];
                                        NSString*resBaseURL = (NSString*)[result valueForKey:@"base_url"];
                                        
                                        if([resData isKindOfClass:[NSArray class]]){
                                                resData = [Alert dictionaryByReplacingNullsWithString:@"" arr:resData];
                                                        data=resData.count ? resData[0] :nil;
                                        }
                                        
                                        if([resReview isKindOfClass:[NSArray class]]){
                                                resReview = [Alert dictionaryByReplacingNullsWithString:@"" arr:resReview];
                                                arrReview=resReview.count ? [resReview mutableCopy] :nil;
                                                
                                        }
                                        if([resArtList isKindOfClass:[NSArray class]]){
                                                resArtList = [Alert dictionaryByReplacingNullsWithString:@"" arr:resArtList];
                                                arrArtList=resArtList.count ? [resArtList mutableCopy] :nil;
                                                
                                        }
                                        if([resBaseURL isKindOfClass:[NSString class]]){
                                                baseURL=!IS_EMPTY(resBaseURL) ? [resBaseURL mutableCopy] :nil;
                                                
                                        }
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                

                                                [self loadProfilePic];
                                                
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

//-(void)showViewTopContainer {
// 
//        self.viContainerTitleBar.hidden = NO;
//}

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
        
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        switch (section) {
                case 0:
                        rows+= data ? 1 :0;
                        break;
                        
                case 1:
                        rows+= data && !IS_EMPTY([data objectForKey:VIDEO_KEY]) ? 1 :0;
                        break;
                case 2:
                        rows+= arrReview ? 1 :0;
                        break;
                case 3:
                        rows+= arrArtList ? 1 :0;
                        break;
                        
                default:
                        break;
        }
        
     
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        
        switch (indexPath.section) {
                case 0:{
                                if(data){
                                        //                        ArtDetailViewCell3 *cell =(ArtDetailViewCell3*)[self.tableView cellForRowAtIndexPath:indexPath];
                                        
                                        float defaultHeight=75.0f,y=8.0f,bottom=60.0f;
                                        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 20)];
                                        label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:11];
                                        
                                        label.text=[data objectForKey:@"bio"];
                                        label.textAlignment=NSTextAlignmentLeft;
                                        label.backgroundColor=[UIColor yellowColor];
                                        float height=[Alert getLabelHeight:label];
                                        
                                        finalHeight=MIN(height, defaultHeight);
                                        
                                        finalHeight+=y+bottom;
                                        
                                        
                                        
                                }
                                else{
                                        finalHeight=0;
                                }
                        }
                        break;
                case 1:
                        finalHeight= data && !IS_EMPTY([data objectForKey:VIDEO_KEY]) ?  140.0f : 0;
                        break;
                case 2:
                        finalHeight= arrReview ?  101.0f : 0;
                        break;
                case 3:
                        finalHeight= arrArtList ?  231.0f : 0;
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
                        ArtistDetailViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                        cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.lblDesc.text=[data objectForKey:@"bio"];
                        
                        cell.lblDesc.translatesAutoresizingMaskIntoConstraints=YES;
                        
                        float height=[Alert getLabelHeight:cell.lblDesc];
                        
                        float defaultHeight=75;
                        
                        float finalHeight=MIN(height, defaultHeight);
                        
                        CGRect frame=cell.lblDesc.frame;
                        frame.size.height=finalHeight;
                        cell.lblDesc.frame=frame;
                                
                        UIColor* color2=[Alert colorFromHexString:COLOR_CELL_TITLE];
                                
                        NSString* text=[data objectForKey:@"bio"];
                        cell.lblDesc.text=text;
                        NSInteger lenght=[cell.lblDesc.text length];
//                        int subLength=[Alert getLabelLength:cell.lblDesc height:defaultHeight];
                                
                                NSInteger subLength;
                                if (lenght !=0) {
                                      subLength  =[Alert getLength:text intoLabel:cell.lblDesc];
                                }
                        
                                
                        if(subLength>12)        subLength-=12;
                                
//                        int subLength=270;
                        if(lenght>subLength){
                                NSString* readMore=@"...read more";//12
                                NSString *newString = [text substringWithRange:NSMakeRange(0, subLength)];
                                text=[newString stringByAppendingString:readMore];
                                cell.lblDesc.text=text;
                                
                                
                                cell.lblDesc.delegate=self;
                                NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                cell.lblDesc.linkAttributes = @{(id)kCTForegroundColorAttributeName: color2,
                                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                
                                NSRange r = [cell.lblDesc.text rangeOfString:readMore];
                                [cell.lblDesc addLinkToURL:url withRange:r];
                        }
                        
                                
                        [cell.btnVirtualGallery addTarget:self action:@selector(openVirtualGallery:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                }
                        break;
                case 1:
                        {
                        ArtistDetailViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                        cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.viContainerImage.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                        
                        for (id view in cell.viContainerImage.subviews) {
                                
                                if([view isKindOfClass:[UIActivityIndicatorView class]])
                                        [view removeFromSuperview];
                        }
                                
                        for (id view in cell.contentView.subviews) {
                                
                                if([view isKindOfClass:[UIActivityIndicatorView class]])
                                        [view removeFromSuperview];
                        }
                                
                        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        activityIndicator1.frame = CGRectMake(cell.imgThumbnail.frame.size.width/2-15,
                                                              cell.imgThumbnail.frame.size.height/2-15,
                                                              30,
                                                              30);
                        [activityIndicator1 startAnimating];
                        activityIndicator1.tag=indexPath.row;
                        
                        [activityIndicator1 removeFromSuperview];
                        [cell.viContainerImage addSubview:activityIndicator1];
                        [cell.viContainerImage insertSubview:activityIndicator1 aboveSubview:cell.imgThumbnail];
                                
                        
//                        NSString* fileName=[[data objectForKey:VIDEO_KEY] lastPathComponent];
//                        NSArray*arr=[fileName componentsSeparatedByString:@"="];
//                        NSString*thumbnail=arr.count==2 ? arr[1] : @"";
                        NSString* fileName=[Alert getYoutubeIdFromLink:[data objectForKey:VIDEO_KEY]];
                        NSString*thumbnail=fileName;
                        NSURL* url=[NSURL URLWithString:[Alert getYoutubeVideoThumbnail:thumbnail]];
                                
                        cell.imgThumbnail.contentMode=UIViewContentModeScaleAspectFit;
                        cell.imgThumbnail.backgroundColor=[UIColor whiteColor];
                        
                        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
                        
                        __weak UIImageView *weakImgPic = cell.imgThumbnail;
                        [cell.imgThumbnail setImageWithURL:url
                                    placeholderImage:imgPlaceHolder
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                         {
                                 [activityIndicator1 stopAnimating];
                                 [activityIndicator1 removeFromSuperview];
                                 
                                 UIImageView *strongImgPic = weakImgPic;
                                 if (!strongImgPic) return;
                                 
                                 strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                                 
                                 [UIView transitionWithView:strongImgPic
                                                   duration:0.3
                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                  
                                                 animations:^{
                                                          strongImgPic.image=image;
                                                         
                                                 }
                                                 completion:^(BOOL finish){
                                                         
                                                 }];
                                 
                         } failure:NULL];

                        [cell.btnVideoPlay addTarget:self action:@selector(didSelectYoutubeVideo :) forControlEvents:UIControlEventTouchUpInside];
                        
                        return cell;
                }
                        break;
                case 2:
                        {
                        ArtistDetailViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                        cell.contentView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //                float finalHeight=95.0f;
                        //                cell.contentView.translatesAutoresizingMaskIntoConstraints=YES;
                        //                CGRect frame=cell.contentView.frame;
                        //                frame.size.height=finalHeight;
                        //                cell.contentView.frame=frame;
                        
                        NSDictionary* dic=arrReview.count ? arrReview[0] : nil;
                        
                        cell.lblReview.text=[NSString stringWithFormat:@"\"%@\"",[dic objectForKey:@"review"]];
                        NSString* autherName=[dic objectForKey:@"name"];
                        NSString* reviewDate=[dic objectForKey:@"review_date"];
                        reviewDate=[Alert getDateWithString:reviewDate getFormat:@"yyyy-MM-dd HH:mm:ss" setFormat:@"yyyy-MM-dd"];
                        
                        
                        
                        
                        UIColor* color1=[Alert colorFromHexString:@"#585858"];
                        UIColor* color2=[Alert colorFromHexString:@"#971700"];
                        
                        cell.lblReviewer.text=[NSString stringWithFormat:@"Reviewed by : %@ on %@",autherName,reviewDate];
                        NSInteger l1=autherName.length;
                        NSInteger l2=reviewDate.length;
                        //        NSInteger l3=cell.lblAutherName.text.length;
                        
                        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblReviewer.text];
                        [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0,13)];
                        [string addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(14,l1)];
                        [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(14+l1,l2)];
                        
                        cell.lblReviewer.attributedText = string;
                        
                        float rating=[[dic objectForKey:@"rate"] floatValue];
                                
                                
                        [self DLStarRatingOfUser:rating cell:cell];
                        //[self starRatingOfUser:rating cell:cell];
                        
                        
                        return cell;
                }
                        break;
                case 3:
                        {
                        ArtistDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        [dic setObject:baseURL forKey:@"base_url"];
                                
                        [cell setCollectionInfo:dic];
                        [cell setCollectionData:[arrArtList mutableCopy]];

                        
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

#pragma mark -  UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//        NSDictionary *sectionData = [arrHeaderTitle objectAtIndex:section];
        NSString *header = [arrHeaderTitle objectAtIndex:section];
        return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

        //Header View
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
//        headerView.backgroundColor=[UIColor clearColor];
        
        //Header Title
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, 20);
        myLabel.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
        //myLabel.backgroundColor=[UIColor grayColor];
        [headerView addSubview:myLabel];
        
        //View All button
        UIButton*moreButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        moreButton.tag=section;
        moreButton.frame = CGRectMake(0, 5, 50, 25);
        moreButton.layer.cornerRadius=5.0;
        [moreButton addTarget:self action:@selector(moreButton:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setTitle:@"View All" forState:UIControlStateNormal];
        [moreButton setTitleColor:[Alert colorFromHexString:COLOR_CELL_TEXT] forState:UIControlStateNormal];
        moreButton.titleLabel.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
        
        UIView* moreView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-58, 0, 50, 30)];
        moreView.backgroundColor=[UIColor clearColor];
        [moreView addSubview:moreButton];
        
        
        
        

        
        switch (section) {
                case 0:
                        
                        break;
                case 1:
                        
                        break;
                case 2:
                       if(arrReview.count>=2)
                                [headerView addSubview:moreView];
                        break;
                case 3:
                        if(arrArtList.count>=2)
                                [headerView addSubview:moreView];
                        break;
                        
                default:
                        break;
        }
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        NSInteger height=0;
        switch (section) {
                case 0:
                        height= data ? 30 :0;
                        break;
                case 1:
                        height= data && !IS_EMPTY([data objectForKey:VIDEO_KEY]) ? 30 :0;
                        break;
                case 2:
                        height= arrReview ? 30 :0;
                        break;
                case 3:
                        height= arrArtList ? 30 :0;
                        break;
                        
                default:
                        break;
        }


        return height;
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
        
        
        
        if ([[url scheme] hasPrefix:@"action"]) {
                if ([[url host] hasPrefix:@"Expand"]) {
                        NSString* htmlString=[data objectForKey:@"bio"];
                        NSString* text=[Alert removeHTMLTags:htmlString];
                        //                        NSLog(@"Read more clicked");
                        ContentAboutViewController* vc=GET_VIEW_CONTROLLER(kContentAboutViewController);
                        vc.titleString=[data objectForKey:@"name"];
                        vc.descString=text;
                        vc.from=@"back";
                        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        
                        
                        
                        /* load help screen */
                } else if ([[url host] hasPrefix:@"show-settings"]) {
                        /* load settings screen */
                }
        } else {
                /* deal with http links here */
        }
}


#pragma mark - FBSDKSharing

-(void)shareOnFB:(NSString*)title desc:(NSString*)desc link:(NSString*)link imgURL:(NSURL*)imgURL{
        
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentTitle=title;
        content.contentDescription=desc;
        content.contentURL = [NSURL URLWithString:link];
        content.imageURL=imgURL;
        
        
        [FBSDKShareDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];
        
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
                
                NSURL* url=[NSURL URLWithString:[data objectForKey:@"profileImage"]];
                
                NSString* desc=[data objectForKey:@"bio"];
                
                desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                
                NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/profile/%@",[data objectForKey:@"username"]];
                
                NSString* title=[data objectForKey:@"name"];
                
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
        if (buttonIndex == 0)
        {
                
                
        }
        if (buttonIndex == 1)
        {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
                
        }
}


#pragma mark - Instagram

-(void)shareOnInstagram{
       
        
        if(self.imgProfilePic.image){
                
                SignInViewController* signInViewC = [[SignInViewController alloc] initWithNibName:@"SignInView" bundle:nil];

                signInViewC.shareImage=self.imgProfilePic.image;
                signInViewC.fileName=[data objectForKey:@"id"];

                MOVE_VIEW_CONTROLLER_VIEW_DECK(signInViewC);
        }
        
}

#pragma mark - Email

-(void)email {
        
        if (!TARGET_IPHONE_SIMULATOR) {
                
                NSString* title=[data objectForKey:@"name"];
                NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/profile/%@",[data objectForKey:@"username"]];
                NSString* desc=[data objectForKey:@"bio"];
                
                desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                
                NSString* fileName=[data objectForKey:@"profileImage"];
                fileName=[fileName lastPathComponent];

                NSURL* url=data ? [NSURL URLWithString:[data objectForKey:@"profileImage"]] : nil;
                
                NSMutableString *body = [NSMutableString string];
                // add HTML before the link here with line breaks (\n)
                [body appendString:@"<b>Artist Name </b>"];
                [body appendString:[NSString stringWithFormat:@": %@ <br>",title]];
                [body appendString:[NSString stringWithFormat:@"<a href=\"%@\"> Click here for details </a><br>",link]];                
                [body appendString:@"<b> Bio </b>"];
                [body appendString:[NSString stringWithFormat:@": %@ <h3></h3>",desc]];
                
                [Alert performBlockWithInterval:0.30 completion:^{
                        [self sendEmail:title
                                   desc:desc
                                   link:link
                                 imgURL:url
                               fileName:fileName
                                   body:body];
                        
                        NSLog(@"Method Called");
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

-(void)sendEmail:(NSString*)title desc:(NSString*)desc link:(NSString*)link imgURL:(NSURL*)imgURL fileName:(NSString*)fileName body:(NSString*)body {
        
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

        [Alert performBlockWithInterval:0.1 completion:^{
                ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
                vc.from=@"back";
                vc.artID=[dic objectForKey:@"id"];
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
        }];
}

#pragma mark - Target Methods

-(IBAction)shareOnFB:(id)sender{
        
        NSURL* url=[NSURL URLWithString:[data objectForKey:@"profileImage"]];
        
        NSString* desc=[data objectForKey:@"bio"];
        
        desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/profile/%@",[data objectForKey:@"username"]];
        
        NSString* title=[data objectForKey:@"name"];
        
        [self shareOnFB:title desc:desc link:link imgURL:url];
        
}

-(IBAction)shareOnTW:(id)sender{
        
        NSURL* url=[NSURL URLWithString:[data objectForKey:@"profileImage"]];
        
        NSString* desc=[data objectForKey:@"bio"];
        
        desc = [desc stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSString* link=[NSString stringWithFormat:@"http://www.eastonartgalleries.com/profile/%@",[data objectForKey:@"username"]];
        
        NSString* title=[data objectForKey:@"name"];
        
        [self postImageWithMessageOnTwitter:title desc:desc link:link imgURL:url];
}

-(IBAction)shareOnGooglePlus:(id)sender{
        
        [self initiliseGooglePlus];
        
}

-(IBAction)shareOnInstagram:(id)sender{
        
        
        [self shareOnInstagram];
        
        
}

- (IBAction)shareOnEmail:(id)sender {
        
//        if (isDataRecievedFromServer) {
        
                  [self email];
//        } else {
//        
//        [Alert alertWithMessage:@"Please wait."
//                     navigation:self.navigationController
//                       gotoBack:NO animation:YES second:3.0];
//        }
}

-(IBAction)openVirtualGallery:(id)sender{
        
        
#if IS_UNITY_USE
        
        NSLog(@"[ViewController] Show Unity->%@",self.artUserName);
        
        [self loadGallery];
#else
        [Alert alertWithMessage:@"First Enable Virtual gallery code and Add relevant files in project !"
                     navigation:self.navigationController
                       gotoBack:NO animation:YES second:5.0];
        
#endif
        
//        [[AppDelegate appDelegate] startUnityApp];
        

//                [MyObject setArtistName:self.artUserName];
//                
//                [self setGallery];
        

        

        
}




@end