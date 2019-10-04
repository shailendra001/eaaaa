//
//  ViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 11/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ViewController.h"
#import "ArtCollectionViewController.h"
#import "BestSellingArtistsViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
//#import "MSSTabNavigationBar.h"
#import "OrderDetailViewController.h"
#import "HomeCollectionViewCell.h"
#import "AuctionViewController.h"
#import "ArtServicesViewController.h"
#import "ArtCategoryViewController.h"
#import "CustomTableViewCell.h"



#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_TEXT         @"#575656"

#define CELL_WIDTH      152
#define CELL_HEIGHT     82

#define TABLE_VIEW_ENABLE       1


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,FPPopoverControllerDelegate,buttontitledelgate,PopupDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
        BOOL isSlider;
        NSArray* arrSlider;
        NSTimer *timerImg;
        NSInteger imageOrignal;
        NSArray *animationImages;
        NSArray* arrItems;	
        NSArray* arrItemsData;
        NSDictionary *resPonsedataArray;
        int count;
        BOOL isMenu;
        FPPopoverKeyboardResponsiveController *popover;
        DemoTableController *tableSuggesstionDictionary;

        ///
        Popup* popper;
        PopupBackGroundBlurType blurType;
        PopupIncomingTransitionType incomingType;
        PopupOutgoingTransitionType outgoingType;
        NSArray *keyboardTypes;
        NSArray *incomingTypes;
        NSArray *outgoingTypes;
        
        BOOL isEmailSubscribe;
        NSString* subscribeEmail;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
}

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - View controller life cicle

- (void)viewDidLoad {
        [super viewDidLoad];

        //TODO - Metal API Validation Disabled from Debug->Edit Scheme-> Metal API Validation Disabled, This is done in Xcode and may generate issue
    
        [self config];
        
        [self setLogoImage];
        
        [self navigationBarConfiguration];
        
        [self getSliderWebService];
        
        [self setSlider];
        
        [self rightNavBarConfiguration];
        
        
#if TABLE_VIEW_ENABLE

#else
        [self cellRegister];
#endif
        
        [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        //self.title =@"Home";
        
        [self imageAnimation];
        
        [self loadCardCount];
        
#if IS_UNITY_USE
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self hideUnityButton];
//        });
#endif
        
        
        
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
        
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
        return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        self.pageController.numberOfPages=0;
        

        
#if TABLE_VIEW_ENABLE
        
//        arrItems = @[
//                     @"Latest Art",
//                     @"Search Art"/*@"Bestseller arts",*/,
//                     @"Works Sold"/*@"Special"*/,
//                     @"All Artist"/*@"Best selling artists"*/,
//                     @"Art Services"/*@"Top New Arrivals"*/,
//                     @"Auction",
//                     @"About Us",
//                     @"Contact Us"];
    
            arrItems = @[
                         @{@"title" : @"New Join",
                           @"icon"  : @"newspaper.png",
                           @"bg"    : @"new_art_text.png"},
    
                         @{@"title" : @"Artist Gallery",
                           @"icon"  : @"MAGNIFIER.png",
                           @"bg"    : @"search_text.png"},
    
                         @{@"title" : @"Contact us",
                           @"icon"  : @"contact_icon.png",
                           @"bg"    : @"contact_text.png"}];
    
    
//            arrItemsData = @[
//                             @"New Join",
//                            @"Artist Gallery",
//                             @"Contact us"];

    
        arrItemsData = @[
                         @"newArrival",
                         @"special",
                         @"contact"];
    

        
        self.tableView.hidden=NO;
        self.collectionView.hidden=YES;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        [self.tableView reloadData];
#else
    
        arrItems = @[
                     @{@"title" : @"New Art",
                       @"icon"  : @"new_art_icon.png",
                       @"bg"    : @"new_art.png"},
                     
                     @{@"title" : @"Search Art",
                       @"icon"  : @"search_art_icon.png",
                       @"bg"    : @"search_art.png"},
                     
                     @{@"title" : @"Works Sold",
                       @"icon"  : @"works_sold_icon.png",
                       @"bg"    : @"works_sold.png"},
                     
                     @{@"title" : @"Artists",
                       @"icon"  : @"all_artists_icon.png",
                       @"bg"    : @"all_artists.png"},
                     
                     @{@"title" : @"Services",
                       @"icon"  : @"art_services_icon.png",
                       @"bg"    : @"art_services.png"},
                     
                     @{@"title" : @"Auction",
                       @"icon"  : @"auction_icon.png",
                       @"bg"    : @"auction.png"},
                     
                     @{@"title" : @"About",
                       @"icon"  : @"about_icon.png",
                       @"bg"    : @"about.png"},
                     @{@"title" : @"Contact",
                       @"icon"  : @"contact_us_icon.png",
                       @"bg"    : @"contact_us.png"}];
    
        

    
        
        arrItemsData = @[
                         @"latestArt",
                         @"bestSellerArt",
                         @"special",
                         @"bestSellerArtist",
                         @"",
                         @"",
                         @"",
                         @""];
        
        self.tableView.hidden=YES;
        self.collectionView.hidden=NO;
        [self.collectionView reloadData];
#endif
        
        
        
        self.imgViSliderImage.image=nil;
        self.imgViSliderImage.backgroundColor=[UIColor whiteColor];
        self.lblSeperatorLine.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
#if SHADOW_ENABLE
        
        [Alert setShadowOnViewAtTop:self.viContainerBottom];
        
#endif

}

-(void)cellRegister{
        
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;

        [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([HomeCollectionViewCell class]) bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
}

-(void)setLogoImage{
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
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
        lblcount.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_MEDIUM size:9];

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
        
        CardDetailViewController * vc = GET_VIEW_CONTROLLER(kCardDetailViewController);
        vc.titleString = @"Your Cart";
        vc.from = @"back";
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
}

-(IBAction)dot:(id)sender{

        [[EAGallery sharedClass]popover:sender vc:self];

}

/*
#pragma mark - Pop Menu

- (void)optionNavButtonActionForDotMenu:(id)sender {
        
        
        if(isMenu){
                [KxMenu dismissMenu];
        }
        else{
                UIButton* button=(UIButton*)sender;
                NSMutableArray* arrMenuItems=[[NSMutableArray alloc]init];
                
                [arrMenuItems addObject:[KxMenuItem menuItem:@"Login"
                                                       image:[UIImage imageNamed:@""]
                                                      target:self
                                                      action:@selector(login:)]];
                
                [arrMenuItems addObject:[KxMenuItem menuItem:@"Sign up"
                                                       image:[UIImage imageNamed:@""]
                                                      target:self
                                                      action:@selector(signup:)]];
                
                //                [arrMenuItems addObject:[KxMenuItem menuItem:@"Alarm"
                //                                                       image:[UIImage imageNamed:@""]
                //                                                      target:self
                //                                                      action:@selector(reminderNavButtonAction)]];
                
                
                
                KxMenuItem *first1 = arrMenuItems[0];
                KxMenuItem *first2 = arrMenuItems[1];
                //                KxMenuItem *first3 = arrMenuItems[2];
                //                KxMenuItem *first4 = arrMenuItems[3];
                first1.alignment =
                first2.alignment= NSTextAlignmentLeft;
                
                [KxMenu showMenuInView:self.view
                              fromRect:button.frame
                             menuItems:arrMenuItems];
                
                NSLog(@"menuItems =%@",arrMenuItems);
        }
        isMenu=!isMenu;
        
}

-(IBAction)login:(id)sender{
        isMenu=!isMenu;
}

-(IBAction)signup:(id)sender{
        isMenu=!isMenu;
}
*/

-(void)setSlider {
    
        [self.imgViSliderImage setContentMode:UIViewContentModeScaleAspectFill];
    
        [self.imgViSliderImage setUserInteractionEnabled:YES];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageUrl:)];
        // Setting the swipe direction.
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        // Adding the swipe gesture on image view
        [self.imgViSliderImage addGestureRecognizer:swipeLeft];
    [self.imgViSliderImage addGestureRecognizer:tapgesture];

        [self.imgViSliderImage addGestureRecognizer:swipeRight];
//        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
        
        count=0;
}
-(void)openImageUrl:(id)sender {

    if (imageOrignal < [arrSlider count])
    {
        NSString *linkid = [[arrSlider objectAtIndex:imageOrignal] objectForKey:@"id"];
        NSString *strUrl = [[arrSlider objectAtIndex:imageOrignal] objectForKey:@"links"];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",strUrl,@"/",linkid];
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    }
}

-(void)handleSwipeLeft:(id)sender {
        
        [self setCoundwonTimer:0];
        [self performSelector:@selector(resumeTimer) withObject:self afterDelay:1.0];
        if(imageOrignal < arrSlider.count-1)
        {
                imageOrignal++;
                self.pageController.currentPage=imageOrignal;
                UIImageView *moveIMageView = self.imgViSliderImage;
                [self addAnimationPresentToView:moveIMageView];
                [self changeImage];
                
                
        }
}

-(void)handleSwipeRight:(id)sender {
        
        [self setCoundwonTimer:0];
        [self performSelector:@selector(resumeTimer) withObject:self afterDelay:1.0];
        if(imageOrignal > 0)
        {
                imageOrignal--;
                self.pageController.currentPage=imageOrignal;
                
                UIImageView *moveIMageView =self.imgViSliderImage;
                [self addAnimationPresentToViewOut:moveIMageView];
                [self changeImage];
                
                
                
        }
}

-(void)changeImage {
    
    // https://www.eastonartgalleries.com/timthumb.php?src=https://www.eastonartgalleries.com/artwork/full/149271547614927154713.jpg&h=500&w=2000
    
        if (imageOrignal < [arrSlider count])
        {
                NSString *imageWidth = @"704";
                NSString *imageHeight = @"240";
            NSLog(@"%@",arrSlider);
                self.pageController.numberOfPages=[arrSlider count];
                self.pageController.currentPage = imageOrignal;
            
                NSString *strUrl = [[arrSlider objectAtIndex:imageOrignal] objectForKey:@"slider_image"];
                NSString *strUrlWithSize = [NSString stringWithFormat:@"%@&h=%@&w=%@",strUrl,imageHeight,imageWidth];
      
                UIImage* imgplaceholder=[UIImage imageNamed:@"slider-noimg.jpg"];
                __weak UIImageView *weakImgPic = self.imgViSliderImage;
                
                [self.imgViSliderImage setImageWithURL:[NSURL URLWithString:strUrl]
                                      placeholderImage:imgplaceholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              UIImageView *strongImgPic = weakImgPic;
                                              if (!strongImgPic) return;
                                              
                                              [UIView transitionWithView:strongImgPic
                                                                duration:0.3
                                                                 options:UIViewAnimationOptionTransitionCrossDissolve
                                                              animations:^{
                                                                      strongImgPic.image=image;
                                                              }
                                                              completion:NULL];

                                              
                                      } failure:nil];
                
                
                if(self.imgViSliderImage.image!=nil){
                        for (id view in self.viContainerImageSlider.subviews) {
                                
                                if([view isKindOfClass:[UIActivityIndicatorView class]])
                                        [view removeFromSuperview];
                        }
                }
        }
        
}

- (void)addAnimationPresentToView:(UIImageView *)viewTobeAnimated{
        CATransition *transition = [CATransition animation];
        transition.duration = 0.30;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
        transition.fillMode=kCAFillModeForwards;
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromRight;
        [viewTobeAnimated.layer addAnimation:transition forKey:nil];
        
}

- (void)addAnimationPresentToViewOut:(UIImageView *)viewTobeAnimated{
        CATransition *transition = [CATransition animation];
        transition.duration = 0.30;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
        transition.fillMode=kCAFillModeForwards;
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        [viewTobeAnimated.layer addAnimation:transition forKey:nil];
        
}

#pragma mark -
#pragma mark - ======: Show Image Animation :=====

-(void)imageAnimation{
        imageOrignal = 0;
        [timerImg invalidate];
        
        [self performTransition];
        
        // Set the timer for image transition fired
        timerImg=[NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(performTransition) userInfo:nil repeats:YES];
        
}

-(void)performTransition{
        
        
        
        imageOrignal++;
        
        if(imageOrignal >= [arrSlider count])  imageOrignal = 0;
        self.pageController.numberOfPages=[arrSlider count];
        self.pageController.currentPage = imageOrignal;
        arrSlider=arrSlider ? arrSlider : nil;
        
        
        [self setImageWithSlider:arrSlider index:(int)imageOrignal];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.75;
        transition.delegate = self;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
        NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
        int rnd = random() % 4;
        transition.type = types[rnd];
        if(rnd > 3)
        {
                transition.subtype = subtypes[random() % 4];
        }
        [self.imgViSliderImage.layer addAnimation:transition forKey:nil];
        
        
}

-(void)setImageWithSlider:(NSArray*)arr index:(int)index{
        NSURL* url;
        if(arr.count){
                NSDictionary* info=arr[index];
                url=[NSURL URLWithString:[info objectForKey:@"slider_image"]];
        }
        else
                
                url=nil;
        //    [self.imgviProfilePic setImageWithURL:url placeholderImage:imgPlaceHolder];
        //        UIImage*imgPlaceHolder=[UIImage imageNamed:@"user_pic.png"];
        
        for (id view in self.viContainerImageSlider.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }

        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(self.imgViSliderImage.frame.size.width/2-15,
                                             self.imgViSliderImage.frame.size.height/2-15,
                                             30,
                                             30);
        [activityIndicator startAnimating];
        activityIndicator.tag=imageOrignal;
        
        [activityIndicator removeFromSuperview];
        if(self.imgViSliderImage.image==nil){
                [self.viContainerImageSlider addSubview:activityIndicator];
                [self.viContainerImageSlider insertSubview:activityIndicator aboveSubview:self.imgViSliderImage];
        }
        
        UIImage* imgplaceholder=[UIImage imageNamed:@"slider-noimg.jpg"];
        __weak UIImageView *weakImgPic = self.imgViSliderImage;
        [self.imgViSliderImage setImageWithURL:url
                      placeholderImage:imgplaceholder
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
                 [activityIndicator stopAnimating];
                 [activityIndicator removeFromSuperview];
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^{
                                         strongImgPic.image=image;
                                 }
                                 completion:NULL];
                 
         } failure:NULL];
        
        /*
         [Alert downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
         
         if (succeeded) {
         
         
         [UIView transitionWithView:bannerImgView
         duration:0.3
         options:UIViewAnimationOptionTransitionCrossDissolve
         animations:^{
         [bannerImgView setImage:image];
         }
         completion:NULL];
         }
         }];
         */
}

-(void)setCoundwonTimer:(int) interval{
        if (timerImg && [timerImg isValid]) {
                [timerImg invalidate];
                timerImg = NULL;
        }
        
        
        if (interval > 0) {
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                                  target:self
                                                                selector:@selector(performTransition)
                                                                userInfo:nil
                                                                 repeats:YES];
                timerImg = timer;
        }
        
        
}

-(void)resumeTimer{
        
        [self setCoundwonTimer:4.5];
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

#pragma mark -Call WebService for all Home page data

-(void)getSliderWebService {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Slider);
                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                [data setObject:@"home" forKey:@"page"];
                
                NSString *postString =[Alert jsonStringWithDictionary:[data mutableCopy]];
                
               
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
                        //[self alerMessage];
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                        }
                        else
                        {
                                
                                //NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                        resPonsedataArray = (NSDictionary*)[result valueForKey:@"data"];
                                        
                                        if([resPonsedataArray isKindOfClass:[NSDictionary class]]){
                                                // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        arrSlider=[resPonsedataArray objectForKey:@"sliders"];
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        //[self setSliderData];
                                                });
                                                
                                        }
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}


-(void)subscribeWebService {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Subscribe);
                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                [data setObject:subscribeEmail forKey:@"news_letter"];//{"news_letter":"yogesh@gmail.com"}
                
                NSString *postString =[Alert jsonStringWithDictionary:[data mutableCopy]];
                
                
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
                                [[SharedClass sharedObject] hudeHide];
                                [Alert alertWithMessage:@"Network failure ! Please try agian later."
                                             navigation:self.navigationController
                                               gotoBack:NO animation:YES second:2.0];

                                
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
                                        [Alert alertWithMessage:@"Network failure ! Please try agian later."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:2.0];
                                        

                                        
                                });

                        }
                        else
                        {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [[SharedClass sharedObject] hudeHide];
                                        
                                });
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                         [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                      navigation:self.navigationController
                                                        gotoBack:NO animation:YES second:2.0];
                                        
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

#if TABLE_VIEW_ENABLE

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return arrItems.count;  //did change
  //  return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *CellIdentifier = @"Cell";
   //  static NSString *CellIdentifier = @"CustomCell";
    
    NSLog(@"%@",arrItems);
       NSString *item = [[arrItems objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString *img = [[arrItems objectAtIndex:indexPath.row] valueForKey:@"icon"];

    
   //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.lblTitle.text = [item uppercaseString];
    [cell.customImg setImage:[UIImage imageNamed:img]];
  //  [cell.customImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",]] ]
//        cell.textLabel.text=[item uppercaseString];
//        cell.textLabel.textAlignment=NSTextAlignmentCenter;
//        cell.textLabel.textColor=[UIColor blackColor];
//        cell.textLabel.font=[UIFont fontWithName:FONT_MONTSERRAT_SEMIBOLD size:16];
//        cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
      //  [tableView deselectRowAtIndexPath:indexPath animated:YES];

        switch (indexPath.row)
        {
                case 0:
                {
                        ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                       NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                        vc.arrArtCollectionList=[arr mutableCopy];
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] valueForKey:@"title"];
                        vc.from=@"back";
                        if(arr.count)
                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                }
                        break;
                case 1:
                {
                        
                        
                        ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                        NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                        vc.arrArtCollectionList=[arr mutableCopy];
                       vc.titleString=[[arrItems objectAtIndex:indexPath.row] valueForKey:@"title"];
                        vc.from=@"back";
                        if(arr.count)
                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                }
                        break;
                case 2:
                {
                    
                    ContactUsViewController* vc=GET_VIEW_CONTROLLER(kContactUsViewController);
//                    vc.titleString=[arrItems objectAtIndex:indexPath.row];
                    vc.titleString=[[arrItems objectAtIndex:indexPath.row] valueForKey:@"title"];

                    vc.from=@"back";
                    MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                    
//                        ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
//                        NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
//                        vc.arrArtCollectionList=[arr mutableCopy];
//                        vc.titleString=[arrItems objectAtIndex:indexPath.row];
//
//
//                        vc.from=@"back";
//                        if(arr.count)
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                }
                        break;
                case 3:
                {
                        BestSellingArtistsViewController* vc=GET_VIEW_CONTROLLER(kBestSellingArtistsViewController);
                        //NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                        //vc.arrBestSellingArtistsList=arr;
                        vc.titleString=[arrItems objectAtIndex:indexPath.row];
                        vc.from=@"back";
                        //                        if(arr.count)
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                        
                        
                }
                        break;
                        
                case 4:
                {
                        /*
                         ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                         NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                         vc.arrArtCollectionList=arr;
                         vc.titleString=[arrItems objectAtIndex:indexPath.row];
                         vc.from=@"back";
                         if(arr.count)
                         MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                         */
                        
                        ArtServicesViewController* vc=GET_VIEW_CONTROLLER(kArtServicesViewController);
                        vc.titleString=[arrItems objectAtIndex:indexPath.row];
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                }
                        break;
                case 5:
                {
                        
                        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AUCTION_ART_LIST);
                        AuctionViewController* vc=GET_VIEW_CONTROLLER(kAuctionViewController);
                        vc.urlString=urlString;
                        vc.urlData=nil;
                        vc.dataAccesskey=@"AuctionList";
                        vc.titleString=@"Auction";
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                }
                        break;
                case 6:
                {
                        
                        AboutUsViewController* vc=GET_VIEW_CONTROLLER(kAboutUsViewController);
                        vc.titleString=[arrItems objectAtIndex:indexPath.row];
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                        
                }
                        break;
                case 7:
                {
                        
                        ContactUsViewController* vc=GET_VIEW_CONTROLLER(kContactUsViewController);
                        vc.titleString=[arrItems objectAtIndex:indexPath.row];
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                }
                        break;
                        
                        
                default:
                        break;
                        
                        
        }

//        NSLog(@"[ViewController] Show Unity");
//        
//        [[self appDelegate] showUnityWindow];
        
//        OrderDetailViewController* vc=GET_VIEW_CONTROLLER(kOrderDetailViewController);
//        
//        vc.titleString=@"Order Details";
//        vc.from=@"back";
//        
//        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
}



#else

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        
        return 1; //did change
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
        return arrItems.count;
       //  return 0;  //did change
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        
        NSDictionary *item = [arrItems objectAtIndex:indexPath.row];
        
        NSString* title=[item objectForKey:@"title"];
        NSString* iconName=[item objectForKey:@"icon"];
        NSString* bg=[item objectForKey:@"bg"];
        
        
        cell.lblTitle.text = [title capitalizedString];
        cell.lblTitle.textColor = [UIColor blackColor];
        
        cell.imgIcon.image = [UIImage imageNamed:iconName];
        cell.imgBG.contentMode = UIViewContentModeScaleToFill;
        cell.imgBG.image = [UIImage imageNamed:bg];;
        cell.viContainerContent.backgroundColor = [UIColor clearColor];
        
        
        
     //   cell.lblTitle.font = [UIFont fontWithName:FONT_DOSIS_BOLD size:16];
        cell.backgroundColor = [Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        
        return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        
        switch (indexPath.row)
        {
                case 0:
                {
                        ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                        NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                        vc.arrArtCollectionList=[arr mutableCopy];
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                        vc.from=@"back";
                        if(arr.count)
                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                        
                }
                        break;
                case 1:
                {
                        
                        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_SearchArt);
                        ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                        NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                        vc.arrArtCollectionList=[arr mutableCopy];
                        vc.urlString=urlString;
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                        vc.from=@"back";
                        if(arr.count)
                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                        
                }
                        break;
                case 2:
                {

                                                BestSellingArtistsViewController* vc=GET_VIEW_CONTROLLER(kBestSellingArtistsViewController);
                                                //NSArray* arr=[resPonsedataArray objectForKey:[arrItemsData objectAtIndex:indexPath.row]];
                                                //vc.arrBestSellingArtistsList=arr;
                                                vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                                                vc.from=@"back";
                                                //                        if(arr.count)
                                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                }
                        break;
                case 3:
                {

                        ArtServicesViewController* vc=GET_VIEW_CONTROLLER(kArtServicesViewController);
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);

                        
                }
                        break;
                        
                case 4:
                {
                       
                        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ArtCategory);
                        NSMutableDictionary* data=[NSMutableDictionary dictionary];
                        [data setObject:@"category" forKey:@"page"];
                        
                        ArtCategoryViewController* vc=GET_VIEW_CONTROLLER(kArtCategoryViewController);
                        
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                        vc.from=@"back";
                        vc.urlString=urlString;
                        vc.urlData=[data mutableCopy];
                        vc.dataAccesskey=@"categoryList";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                }
                        break;
                case 5:
                {
                        
                        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AUCTION_ART_LIST);
                        AuctionViewController* vc=GET_VIEW_CONTROLLER(kAuctionViewController);
                        vc.urlString=urlString;
                        vc.urlData=nil;
                        vc.dataAccesskey=@"AuctionList";
                        vc.titleString=@"Auction";
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                }
                        break;
                case 6:
                {
                        
                        AboutUsViewController* vc=GET_VIEW_CONTROLLER(kAboutUsViewController);
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                        
                        
                }
                        break;
                case 7:
                {
                        
                        ContactUsViewController* vc=GET_VIEW_CONTROLLER(kContactUsViewController);
                        vc.titleString=[[arrItems objectAtIndex:indexPath.row] objectForKey:@"title"];
                        vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                }
                        break;
                        
                        
                default:
                        break;
                
                        
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

#endif




-(void)hideUnityButton{
        UIView* view=[[[(AppDelegate*)[UIApplication sharedApplication].delegate unityWindow] subviews] lastObject];
        
        UIButton* button=[UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Hide Unity" forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 100, 40);
        button.center=view.center;
        button.backgroundColor=[UIColor greenColor];
        [button addTarget:self action:@selector(hideUnity:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:button];
}

-(void)hideUnity:(UIButton*)sender{
        
        NSLog(@"[ViewController] Hide Unity Window");
        
        [[AppDelegate appDelegate] hideUnityWindow];
        //        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        
        
}


#pragma mark Setting Methods

- (void)figureOutSecure {
        
        [popper setTextFieldTypeForTextFields:@[@""]];
        
}

- (void)figureOutKeyboardType {
        
//        UIButton *key1 = (UIButton *)[self.view viewWithTag:14];
//        UIButton *key2 = (UIButton *)[self.view viewWithTag:16];
//        UIButton *key3 = (UIButton *)[self.view viewWithTag:18];
//        
//        NSString *k1 = key1.titleLabel.text;
//        NSString *k2 = key2.titleLabel.text;
//        NSString *k3 = key3.titleLabel.text;
        
        keyboardTypes = @[@"DEFAULT",
                          @"ASCIICAPABLE",
                          @"NUMBERSANDPUNCTUATION",
                          @"URL",
                          @"NUMBER",
                          @"PHONE",
                          @"NAMEPHONE",
                          @"EMAIL",
                          @"DECIMAL",
                          @"TWITTER",
                          @"WEBSEARCH"];
        
        
//        if (setKey1 && !setKey2 && !setKey3) {
//                [popper setKeyboardTypeForTextFields:@[k1]];
//        }
//        else if (setKey1 && setKey2 && !setKey3) {
//                [popper setKeyboardTypeForTextFields:@[k1, k2]];
//        }
//        else if (setKey1 && setKey2 && setKey3) {
//                [popper setKeyboardTypeForTextFields:@[k1, k2, k3]];
//        }
//        else if (setKey1 && !setKey2 && setKey3) {
//                [popper setKeyboardTypeForTextFields:@[k1, @"", k3]];
//        }
//        else if (!setKey1 && setKey2 && !setKey3) {
//                [popper setKeyboardTypeForTextFields:@[@"", k2]];
//        }
//        else if (!setKey1 && !setKey2 && setKey3) {
//                [popper setKeyboardTypeForTextFields:@[@"", @"", k3]];
//        }
//        else if (!setKey1 && !setKey2 && !setKey3) {
                //none
        [popper setKeyboardTypeForTextFields:@[@"EMAIL"]];
//        }
//        else if (setKey1 && !setKey2 && setKey3) {
//                [popper setKeyboardTypeForTextFields:@[k1, @"", k3]];
//        }
//        else if (!setKey1 && setKey2 && setKey3) {
//                [popper setKeyboardTypeForTextFields:@[@"", k2, k3]];
//        }
        
        
        
}

- (void)figureOutTransitions {
        
//        UIButton *inBtn = (UIButton *)[self.view viewWithTag:99];
//        UIButton *outBtn = (UIButton *)[self.view viewWithTag:100];
//        
//        NSString *inTitle = inBtn.titleLabel.text;
//        NSString *outTitle = outBtn.titleLabel.text;
        
        //inTitle
//        if ([inTitle isEqualToString:@"BounceFromCenter"]) {
                incomingType = PopupIncomingTransitionTypeBounceFromCenter;
        /*
        }
        else if ([inTitle isEqualToString:@"SlideFromLeft"]) {
                incomingType = PopupIncomingTransitionTypeSlideFromLeft;
        }
        else if ([inTitle isEqualToString:@"SlideFromTop"]) {
                incomingType = PopupIncomingTransitionTypeSlideFromTop;
        }
        else if ([inTitle isEqualToString:@"SlideFromBottom"]) {
                incomingType = PopupIncomingTransitionTypeSlideFromBottom;
        }
        else if ([inTitle isEqualToString:@"SlideFromRight"]) {
                incomingType = PopupIncomingTransitionTypeSlideFromRight;
        }
        else if ([inTitle isEqualToString:@"EaseFromCenter"]) {
                incomingType = PopupIncomingTransitionTypeEaseFromCenter;
        }
        else if ([inTitle isEqualToString:@"AppearCenter"]) {
                incomingType = PopupIncomingTransitionTypeAppearCenter;
        }
        else if ([inTitle isEqualToString:@"FallWithGravity"]) {
                incomingType = PopupIncomingTransitionTypeFallWithGravity;
        }
        else if ([inTitle isEqualToString:@"GhostAppear"]) {
                incomingType = PopupIncomingTransitionTypeGhostAppear;
        }
        else if ([inTitle isEqualToString:@"ShrinkAppear"]) {
                incomingType = PopupIncomingTransitionTypeShrinkAppear;
        }
        else {
                incomingType = PopupIncomingTransitionTypeFallWithGravity;
        }
         */
        
        //outTitle
      //  if ([outTitle isEqualToString:@"BounceFromCenter"]) {
                outgoingType = PopupOutgoingTransitionTypeBounceFromCenter;
        /*
        }
        else if ([outTitle isEqualToString:@"SlideToLeft"]) {
                outgoingType = PopupOutgoingTransitionTypeSlideToLeft;
        }
        else if ([outTitle isEqualToString:@"SlideToTop"]) {
                outgoingType = PopupOutgoingTransitionTypeSlideToTop;
        }
        else if ([outTitle isEqualToString:@"SlideToBottom"]) {
                outgoingType = PopupOutgoingTransitionTypeSlideToBottom;
        }
        else if ([outTitle isEqualToString:@"SlideToRight"]) {
                outgoingType = PopupOutgoingTransitionTypeSlideToRight;
        }
        else if ([outTitle isEqualToString:@"EaseToCenter"]) {
                outgoingType = PopupOutgoingTransitionTypeEaseToCenter;
        }
        else if ([outTitle isEqualToString:@"DisappearCenter"]) {
                outgoingType = PopupOutgoingTransitionTypeDisappearCenter;
        }
        else if ([outTitle isEqualToString:@"FallWithGravity"]) {
                outgoingType = PopupOutgoingTransitionTypeFallWithGravity;
        }
        else if ([inTitle isEqualToString:@"GhostDisappear"]) {
                outgoingType = PopupOutgoingTransitionTypeGhostDisappear;
        }
        else if ([outTitle isEqualToString:@"GrowDisappear"]) {
                outgoingType = PopupOutgoingTransitionTypeGrowDisappear;
        }
        else {
                outgoingType = PopupOutgoingTransitionTypeBounceFromCenter;
        }
         */
}

- (void)setBlur:(id)sender {
        
        //UIButton *button = (UIButton *)sender;
//        UIButton *button5 = (UIButton *)[self.view viewWithTag:5];
//        UIButton *button6 = (UIButton *)[self.view viewWithTag:6];
//        UIButton *button7 = (UIButton *)[self.view viewWithTag:7];
//        UIButton *button8 = (UIButton *)[self.view viewWithTag:8];
        
//        if ([button tag] == 5) {
//                if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
//                        [button setBackgroundColor:[UIColor darkGrayColor]];
                        blurType = PopupBackGroundBlurTypeDark;
        /*
                }
                else {
                        blurType = PopupBackGroundBlurTypeNone;
                        [button setBackgroundColor:[UIColor lightGrayColor]];
                }
                [button6 setBackgroundColor:[UIColor lightGrayColor]];
                [button7 setBackgroundColor:[UIColor lightGrayColor]];
                [button8 setBackgroundColor:[UIColor lightGrayColor]];
        }
        else if ([button tag] == 6) {
                if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
                        [button setBackgroundColor:[UIColor darkGrayColor]];
                        blurType = PopupBackGroundBlurTypeLight;
                }
                else {
                        [button setBackgroundColor:[UIColor lightGrayColor]];
                        blurType = PopupBackGroundBlurTypeNone;
                }
                [button5 setBackgroundColor:[UIColor lightGrayColor]];
                [button7 setBackgroundColor:[UIColor lightGrayColor]];
                [button8 setBackgroundColor:[UIColor lightGrayColor]];
        }
        else if ([button tag] == 7) {
                if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
                        [button setBackgroundColor:[UIColor darkGrayColor]];
                        blurType = PopupBackGroundBlurTypeExtraLight;
                }
                else {
                        [button setBackgroundColor:[UIColor lightGrayColor]];
                        blurType = PopupBackGroundBlurTypeNone;
                }
                [button5 setBackgroundColor:[UIColor lightGrayColor]];
                [button6 setBackgroundColor:[UIColor lightGrayColor]];
                [button8 setBackgroundColor:[UIColor lightGrayColor]];
        }
        else if ([button tag] == 8) {
                if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
                        [button setBackgroundColor:[UIColor darkGrayColor]];
                        blurType = PopupBackGroundBlurTypeNone;
                }
                else {
                        [button setBackgroundColor:[UIColor lightGrayColor]];
                        blurType = PopupBackGroundBlurTypeNone;
                }
                [button5 setBackgroundColor:[UIColor lightGrayColor]];
                [button6 setBackgroundColor:[UIColor lightGrayColor]];
                [button7 setBackgroundColor:[UIColor lightGrayColor]];
        }
         */
        
        
}

- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
        isEmailSubscribe=NO;
        
        NSString *textFromBox1 = [stringArray objectAtIndex:0];
        
        isEmailSubscribe=[Alert validationEmail:[Alert trimString:textFromBox1]];
        subscribeEmail=[Alert trimString:textFromBox1];
        
//        NSString *textFromBox2 = [stringArray objectAtIndex:1];
//        NSString *textFromBox3 = [stringArray objectAtIndex:2];
        
        NSLog(@"valid is %d [%@]",isEmailSubscribe,textFromBox1);
        
}
-(void)buttonTittle:(NSString *)title selectedIndex:(int)index{
        
}

-(void)popup:(id)sender{
        
        //UIButton* button=(UIButton*)sender;
        
        
        popper = [[Popup alloc] initWithTitle:@"SUBSCRIBE OUR NEWSLETTER"
                                            subTitle:@""
                               textFieldPlaceholders:@[@"Enter your email address"]
                                         cancelTitle:@"CANCEL"
                                        successTitle:@"SUBSCRIBE"
                                         cancelBlock:^{
                                                 NSLog(@"Cancel block 1");
                                                 
                                         } successBlock:^{
                                                 NSLog(@"Success block 1");
                                                 NSString* message=@"Please enter valid email address !";
                                                 
                                                 if(isEmailSubscribe){
                                                         
                                                         [self subscribeWebService];
                                                 }
                                                 else{
                                                         [Alert alertWithMessage:message
                                                                      navigation:self.navigationController
                                                                        gotoBack:NO animation:YES second:2.0];
                                                 }
                                         }];

        [self figureOutSecure];
        [self figureOutTransitions];
        [self figureOutKeyboardType];
        [self setBlur:sender];
        
        [popper setDelegate:self];
        [popper setBackgroundBlurType:blurType];
        [popper setIncomingTransition:incomingType];
        [popper setOutgoingTransition:outgoingType];
        [popper setRoundedCorners:YES];
        [popper showPopup];
        
}

- (IBAction)subcribe:(id)sender {
        
        //[self popover:sender];
        
        [self popup:sender];
        
        
}


@end