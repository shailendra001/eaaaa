//
//  MediaLecturesAndPublicationVC.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 19/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "MediaLecturesAndPublicationVC.h"
#import "MediaLectureTVCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MediaCollectionViewCell.h"

#define CELL_WIDTH      152
#define CELL_HEIGHT     185


@interface MediaLecturesAndPublicationVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
        DataBaseHandler *dataManager;
        UIView* cardCountViewGlobal;
        UIView* cardViewGlobal;
        UIActivityIndicatorView *activityIndicator;
        AVPlayerViewController *playerViewController;
        NSMutableArray *arrayDataSource;
        
}


@end

@implementation MediaLecturesAndPublicationVC

static NSString * const reuseIdentifier = @"Cell";

#pragma mark -  Controller life cycle method -

- (void)viewDidLoad {
        
        [super viewDidLoad];
        [self cellRegister];
        [self config];
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        if([self.from isEqualToString:@"back"])
                [self setNav];
        
        else
                [self navigationBarConfiguration];

        if (![arrayDataSource count]) {
                
                [self getWebService];
                [self setActivityIndicator];

        }
}


-(void)cellRegister{
        
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;

        [self.collectionView registerClass:[MediaCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        UINib *cellNib = [UINib nibWithNibName:@"MediaCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
}

-(void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        [self loadCardCount];
        self.collectionView.backgroundColor = [UIColor lightGrayColor];
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

-(void)config {
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
//        self.lblTitle.text=[self.titleString uppercaseString];// @"ART COLLECTION";
        
       
        
        
        
//        self.tableView.delegate=self;
//        self.tableView.dataSource=self;
//        
//        [self.tableView reloadData];
        
        
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
        
        NSInteger cartCount=[self getCardCount];
        
        UIView* cardCountView=[[UIView alloc]initWithFrame:CGRectMake(cardViewGlobal.frame.size.width-17,
                                                                      2,
                                                                      15,
                                                                      15)];
        UILabel* lblcount=[[UILabel alloc]initWithFrame:cardCountView.bounds];
        lblcount.text = [NSString stringWithFormat:@"%lu",(long)cartCount];
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
        cardCountView.hidden=cartCount ? NO: YES;
        cardCountViewGlobal=cardCountView;
        [cardViewGlobal addSubview:cardCountView];
        [cardViewGlobal insertSubview:cardCountView atIndex:1];
        
        
        //#if SHADOW_ENABLE
        //        [Alert setShadowOnView:cardCountView];
        //
        //#endif
        
        
        
        
        
}

-(void)removeCardCount{
        
        for (id view in cardViewGlobal.subviews) {
                
                if(![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UIButton class]] )
                        [view removeFromSuperview];
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

#pragma Mark Navigation Bar Configuration Code

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

-(IBAction)search:(id)sender {
        
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
        
        [[EAGallery sharedClass]popover:sender vc:self];
        
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
   //     messageLabel.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
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

#pragma - Web Services -




-(void)getWebService {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_MEDIA_LECTURE);
                
//                NSString *urlString = @"http://eastern.psgahlout.com/services/artservices/mediaLecturePublicationListing";
                /*
                //;JOIN_STRING(kPrefixUrl, kURL_NewArt);
                //                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                //                [data setObject:@"15" forKey:@"limit"];
                
                NSString *postString =[Alert jsonStringWithDictionary:[self.urlData mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                // NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                */
                
                NSURL *url = [NSURL URLWithString:urlString];
                
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:nil forHTTPHeaderField:@"Content-Length"];
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                //                NSData *req=[NSData dataWithBytes:[postString UTF8String] length:[postString length]];
               // [theRequest setHTTPBody:postData];
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                
                        });
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if(arrayDataSource.count)
                                        [self removeBackgroundLabel];
                                else
                                        [self setBackgroundLabel];
                                [self.collectionView reloadData];
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                   //             [self removeActivityIndicator];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(arrayDataSource.count)
                                                [self removeBackgroundLabel];
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
                                
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                        [self removeActivityIndicator];
                                                _baseURL = [result objectForKey:@"base_url"];
                                                arrayDataSource = [result objectForKey:@"publicationList"];
                                                [self.collectionView reloadData];
                                          });
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                      //  if(arrayDataSource.count)
                                        //        [self removeBackgroundLabel];
                                       // else
                                        //        [self setBackgroundLabel];
                                });
                        }
                        
                }
                
        });
        
}

#pragma mark -  Selector method -

#pragma mark - Play selected Youtube Video

- (void) didSelectYoutubeVideo:(id)sender{
        
       // NSLog(@"%@",[data objectForKey:VIDEO_KEY]);
        
        //                NSString* fileName=[[data objectForKey:VIDEO_KEY] lastPathComponent];
        
        //video
        //                NSArray*arr=[fileName componentsSeparatedByString:@"="];
        //                NSString*videoID=arr.count==2 ? arr[1] : nil;
        NSString* fileName = [Alert getYoutubeIdFromLink:@"https://www.youtube.com/watch?v=elYbYiTyJEc"];
        NSString *videoID = fileName;
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
        //                videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
        videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        
        return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
        return arrayDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
        MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.contentView.layer.cornerRadius = 5.0f;
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        cell.viewBG.backgroundColor = [UIColor whiteColor];
        for (id view in cell.viewBG.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
        
        NSDictionary* data=[arrayDataSource objectAtIndex:indexPath.item];
        
        cell.labelTitle.text=[data objectForKey:@"title"];
        
        //   Downloading Media Thumbnail Image

         NSString* path=_baseURL ? [_baseURL stringByAppendingString:[data objectForKey:@"background_image"]] : [data objectForKey:@"background_image"];
        
        NSURL* url = [NSURL URLWithString:path];
        
              UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator1.frame = CGRectMake(cell.imageThumbnail.frame.size.width/2-15,
                                              cell.imageThumbnail.frame.size.height/2-15,
                                              30,
                                              30);
        [activityIndicator1 startAnimating];
        activityIndicator1.tag = indexPath.row * 5;
        
        [activityIndicator1 removeFromSuperview];
        [cell.viewBG addSubview:activityIndicator1];
        [cell.viewBG insertSubview:activityIndicator1 aboveSubview:cell.imageThumbnail];
        
        
        cell.imageThumbnail.contentMode = UIViewContentModeScaleToFill;
        cell.imageThumbnail.backgroundColor=[UIColor whiteColor];
        cell.imageUser.layer.cornerRadius = 2.5f;
        cell.imageUser.backgroundColor = [UIColor clearColor];

        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
        __weak UIImageView *weakImgPic = cell.imageThumbnail;
        
        [cell.imageThumbnail setImageWithURL:url
                     placeholderImage:imgPlaceHolder
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 [activityIndicator1 stopAnimating];
                 [activityIndicator1 removeFromSuperview];
                 
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
                 strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor lightGrayColor];
                 
                 //                 UIImage* temp=[Alert imageResizeScale:CGSizeMake(152, 102) image:image];
                 
                 UIImage* temp=[Alert imageWithImage:image
                                    scaledToMaxWidth:152
                                           maxHeight:149];
                 
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                         strongImgPic.contentMode=UIViewContentModeTop;
                                         strongImgPic.image = temp;
                                         
                                 }
                                 completion:^(BOOL finish){
                                         
                                 }];
                 
                 
                 
         } failure:NULL];
        
        //   Downloading User Image
        
        NSString *strPathForUserImage = [_baseURL stringByAppendingString:[data objectForKey:@"profile_image"]];
        
        NSURL * urlUserImage = [NSURL URLWithString:strPathForUserImage];
        UIActivityIndicatorView *activityIndicator2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator2.frame = CGRectMake(cell.imageThumbnail.frame.size.width/2-0,
                                              cell.imageThumbnail.frame.size.height-15,
                                              20,
                                              20);
        [activityIndicator2 startAnimating];
        activityIndicator2.tag = indexPath.row *5 + 1;
        
        [activityIndicator2 removeFromSuperview];
        [cell.viewBG addSubview:activityIndicator2];
        [cell.viewBG insertSubview:activityIndicator2 aboveSubview:cell.imageUser];

        __weak UIImageView *weakImgPic2 = cell.imageUser;

        [cell.imageUser setImageWithURL:urlUserImage
                            placeholderImage:imgPlaceHolder
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 [activityIndicator2 stopAnimating];
                 [activityIndicator2 removeFromSuperview];
                 
                 UIImageView *strongImgPic2 = weakImgPic2;
                 if (!strongImgPic2) return;
                 
                 strongImgPic2.backgroundColor = image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                 
//                                  UIImage* temp=[Alert imageResizeScale:CGSizeMake(152, 102) image:image];
                 
                 UIImage* temp=[Alert imageWithImage:image
                                    scaledToMaxWidth:40
                                           maxHeight:40];
                 
                 
                 [UIView transitionWithView:strongImgPic2
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                         
                                         strongImgPic2.contentMode=UIViewContentModeCenter;
                                         strongImgPic2.image = temp;
                                         
                                         
                                 }
                                 completion:^(BOOL finish){
                                         
                                 }];
                 
                 
                 
         } failure:NULL];
        
        
        //        cell.backgroundColor=[UIColor yellowColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.viewBG.backgroundColor=[UIColor whiteColor];
        cell.viewBG.layer.cornerRadius = 2.5f;
        
  //      BOOL isSold= [data objectForKey:@"quantity"]!=nil && [[data objectForKey:@"quantity"] intValue]==0 ? YES : NO;
  //      cell.imgSold.hidden=!isSold;
        
        
        return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
       MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.imageThumbnail.image = [UIImage imageNamed:@"all_artists.png"];
        
        NSDictionary *dicMediaInfo = [arrayDataSource objectAtIndex:indexPath.row];
        NSString *strMediaURL = [dicMediaInfo objectForKey:@"video_url"];
        NSString* fileName = [Alert getYoutubeIdFromLink:strMediaURL];
        NSString *videoID = fileName;
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
        //                videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
        videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];

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



@end