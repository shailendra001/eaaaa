//
//  BestSellingArtistsViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 26/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "BestSellingArtistsViewController.h"
#import "BestSellingArtistsViewCell.h"
#import "ArtistDetailViewController.h"
#import "SearchHeaderView.h"
#import "ArtCollectionViewCell.h"
#import "ArtDetailViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_TEXT         @"#575656"


@interface BestSellingArtistsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>
{
//        NSArray *resPonsedataArray;
        UIActivityIndicatorView *activityIndicator;
        NSString* searchResult;
        BOOL isSearch;
        NSArray* arrSearchResult;
    NSArray *artlistSearchResult;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
}
@property (strong, nonatomic) UISearchController *searchController;


@end


@implementation BestSellingArtistsViewController
@synthesize arrBestSellingArtistsList=_arrBestSellingArtistsList;


static NSString * const reuseIdentifier_artist = @"Cell";
static NSString * const reuseIdentifier_art = @"artCell";


#pragma mark - View controller life cicle

- (void)viewDidLoad {
        
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self config];
        
        
        if(self.isSearchArtist)
                [self setSearchBar];
        else{
        
                //[self rightNavBatCancel];//
                
                //[self leftNavBatBack];//
                [self setLogoImage];
                
                [self rightNavBarConfiguration];
                
               
        }
        
        if(!self.arrBestSellingArtistsList.count)
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

-(void)setSearchBar {
        
        // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case
        //UITableViewController *searchResultsController = [[UITableViewController alloc] init];
        
        // Init UISearchController with the search results controller
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        // Link the search controller
        self.searchController.searchResultsUpdater = self;
        
        // This is obviously needed because the search bar will be contained in the navigation bar
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        // Required (?) to set place a search bar in a navigation bar
        self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
        
        
        // This is where you set the search bar in the navigation bar, instead of using table view's header ...
        self.navigationItem.titleView = self.searchController.searchBar;
        
        // To ensure search results controller is presented in the current view controller
        self.definesPresentationContext = YES;
        
        
        [self.searchController.searchBar setBarTintColor:[UIColor blackColor]];
        [self.searchController.searchBar setTintColor:[UIColor whiteColor]];
        
        // Setting delegates and other stuff
        //searchResultsController.tableView.dataSource = self;
//        searchResultsController.tableView.delegate = self;
        self.searchController.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.searchBar.delegate = self;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
        
        searchController.view.backgroundColor=[UIColor whiteColor];
        if (!searchController.active) {
                return;
        }
        
       // NSLog(@"%@", searchController.searchBar.text);
        //self.filterString = searchController.searchBar.text;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
        
        NSLog(@"Result->%@",searchBar.text);
        isSearch=YES;
        searchResult=searchBar.text;
       // [self.searchController setActive:NO];
        
        [self searchArtistWebService];

}

-(void)reloadData {
        
        dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView transitionWithView:self.collectionView
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:nil];
                
                
                
                [self.collectionView reloadData];
        });
}

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.lblTitle.text=[self.titleString uppercaseString];//@"BEST SELLING ARTISTS";
        
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

-(void)cellRegister{
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
	
	// register class and cell for artist
        [self.collectionView registerClass:[BestSellingArtistsViewCell class] forCellWithReuseIdentifier:reuseIdentifier_artist];
        
        UINib *cellNib = [UINib nibWithNibName:@"BestSellingArtistsViewCell" bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier_artist];
	
	// register class and cell for art
	[self.collectionView registerClass:[ArtCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier_art];
	
	UINib *artCellNib = [UINib nibWithNibName:@"ArtCollectionViewCell" bundle:nil];
	[self.collectionView registerNib:artCellNib forCellWithReuseIdentifier:reuseIdentifier_art];

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
        messageLabel.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:18];
        [messageLabel sizeToFit];
        
        self.collectionView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)removeBackgroundLabel{
        self.collectionView.backgroundView = nil;
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
        dotButton.layer.cornerRadius=dotButton.frame.size.width/2;
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

-(void)rightNavBatCancel{
        
        UIButton * dotButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        dotButton.frame = CGRectMake(0, 0, 50, 30);
        dotButton.titleLabel.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:15.0];
        dotButton.layer.cornerRadius=5;
        [dotButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        [dotButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [dotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIView* dotView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, 50, 30)];
        dotView.backgroundColor=[UIColor clearColor];
        [dotView addSubview:dotButton];
        
        UIView* rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        rightView.backgroundColor=[UIColor clearColor];
        
        [rightView addSubview:dotView];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        [rightView alignmentRectInsets];
        
        self.navigationItem.rightBarButtonItem = rightBarItem;
        
}

-(void)leftNavBatBack{
        
        
        
        UIView* rightView=[[UIView alloc]init];
        rightView.backgroundColor=[UIColor clearColor];
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        [rightView alignmentRectInsets];
        
        self.navigationItem.leftBarButtonItem = rightBarItem;
        
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

-(IBAction)cancel:(id)sender{
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        [self navigationBarConfiguration];
        
        isSearch=NO;
        [self.searchController setActive:NO];
        
        
        
        [self reloadData];
        
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
        
        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
        [data setObject:@"artist" forKey:@"page"];
        
        self.urlString=urlString;
        self.urlData=[data mutableCopy];
        self.dataAccesskey=@"Artist";
        
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
                                if(_arrBestSellingArtistsList.count)    [self removeBackgroundLabel];
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
                                        if(_arrBestSellingArtistsList.count)    [self removeBackgroundLabel];
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
                                        
                                        NSArray *resPonsedataArray = (NSArray*)[result valueForKey:self.dataAccesskey];
                                        
                                        if([urlString isEqualToString:JOIN_STRING(kPrefixUrl, kURL_Artist)]){
                                                
                                                NSDictionary* info=[Alert removedNullsWithString:@"" obj:result];
                                                [Alert saveToLocal:[info mutableCopy] key:@"artistlist"];
                                        }
                                        
                                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
                                                // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        _arrBestSellingArtistsList=[resPonsedataArray mutableCopy];
                                                        
                                                        [UIView transitionWithView:self.collectionView
                                                                          duration:0.3
                                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                         
                                                                        animations:nil
                                                                        completion:nil];
                                                        
                                                        
                                                        
                                                        [self.collectionView reloadData];
                                                });
                                                
                                        }
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        
                                }
                                
                                else{
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(_arrBestSellingArtistsList.count)    [self removeBackgroundLabel];
                                        else                                    [self setBackgroundLabel];
                                });
                        }
                        
                }
                
        });
        
}

-(void)searchArtistWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                [data setObject:@"artist"       forKey:@"page"];//{"page":"artist","search_data":"rohit"}
                [data setObject:searchResult    forKey:@"search_data"];
                
                NSString *postString =[Alert jsonStringWithDictionary:[data mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                
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
                                [[SharedClass sharedObject] hudeHide];
                                [self removeActivityIndicator];
                                [self setBackgroundLabel];
                                [self.searchController setActive:NO];
                        });
                        [self reloadData];
                        
                        
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                [self removeActivityIndicator];
                                [self.searchController setActive:NO];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self setBackgroundLabel];
                                });
                                [self reloadData];
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                       
                                        
                                        NSArray *resPonsedataArray = (NSArray*)[result valueForKey:@"Artist"];
                                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
                                                // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                                                
                                                arrSearchResult=[resPonsedataArray mutableCopy];
                                                
                                        }
                                    
                                    NSArray *artList = (NSArray *)[result valueForKey:@"Artlist"];
                                    if([artList isKindOfClass:[NSArray class]]) {
                                        artlistSearchResult = [artList mutableCopy];
                                    }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                               if(arrSearchResult.count)        [self removeBackgroundLabel];
                                               else                            [self setBackgroundLabel];
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
                                
                                [self reloadData];
                                
                                
                        }
                        
                }
                
        });
        
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        
	return (isSearch)?2:1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if(!isSearch) {
		return _arrBestSellingArtistsList.count;
	} else {
		if(section == 0) {
			return arrSearchResult.count;
		}
		return artlistSearchResult.count;
	}
//        return isSearch ? arrSearchResult.count : _arrBestSellingArtistsList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	SearchHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SearchHeaderView" forIndexPath:indexPath];
	if(headerView != nil) {
		headerView.headerTitleLabel.text = (indexPath.section == 0)? @"Artist":@"Art";
		return headerView;
	}
	return [UICollectionReusableView new];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0) {
		BestSellingArtistsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier_artist forIndexPath:indexPath];
		
		
		for (id view in cell.viContainerImage.subviews) {
			
			if([view isKindOfClass:[UIActivityIndicatorView class]])
				[view removeFromSuperview];
		}
		
		for (id view in cell.contentView.subviews) {
			
			if([view isKindOfClass:[UIActivityIndicatorView class]])
				[view removeFromSuperview];
		}
		
		
		NSDictionary* data=[isSearch ? arrSearchResult : _arrBestSellingArtistsList objectAtIndex:indexPath.item];
		
		cell.lblName.text=[data objectForKey:@"name"];
		
		//Adjust Font
		cell.lblName.numberOfLines = 1;
		cell.lblName.minimumScaleFactor =  8./cell.lblName.font.pointSize;
		cell.lblName.adjustsFontSizeToFitWidth = YES;
		
		cell.lblCountry.text=[data objectForKey:@"country_name"];
		
		NSString* coverImage=[data objectForKey:@"coverImage"];
		
		//Cover image
		NSURL* url=[NSURL URLWithString:IS_EMPTY(coverImage) ? nil : coverImage ];
		
		
		UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator1.frame = CGRectMake(cell.imgCover.frame.size.width/2-15,
						      cell.imgCover.frame.size.height/2-15,
						      30,
						      30);
		[activityIndicator1 startAnimating];
		activityIndicator1.tag=indexPath.row;
		
		[activityIndicator1 removeFromSuperview];
		
		if(url){
			[cell.viContainerImage addSubview:activityIndicator1];
			[cell.viContainerImage insertSubview:activityIndicator1 aboveSubview:cell.imgCover];
		}
		
		
		cell.imgCover.contentMode=UIViewContentModeScaleAspectFit;
		cell.imgCover.backgroundColor=[UIColor whiteColor];
		
		UIImage* imgCoverPlaceHolder=[UIImage imageNamed:@"no_image.png"];
		
		__weak UIImageView *weakImgCoverPic = cell.imgCover;
		[cell.imgCover setImageWithURL:url
			      placeholderImage:imgCoverPlaceHolder
				       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
		 {
			 [activityIndicator1 stopAnimating];
			 [activityIndicator1 removeFromSuperview];
			 
			 UIImageView *strongImgPic = weakImgCoverPic;
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
						 
					 }];
			 
			 
		 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
			 
			 [activityIndicator1 stopAnimating];
			 [activityIndicator1 removeFromSuperview];
		 }];
		
		
		
		
		
		//Profile image
		NSURL* urlProfile=[NSURL URLWithString:[data objectForKey:@"profileImage"]];
		
		UIActivityIndicatorView *activityIndicator2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator2.frame = CGRectMake(cell.imgProfile.frame.size.width/2-15,
						      cell.imgProfile.frame.size.height/2-15,
						      30,
						      30);
		[activityIndicator2 startAnimating];
		activityIndicator2.tag=indexPath.row;
		
		[activityIndicator2 removeFromSuperview];
		//[cell.imgProfile addSubview:activityIndicator1];
		//        [cell.contentView insertSubview:activityIndicator1 aboveSubview:cell.imgProfile];
		
		cell.imgProfile.contentMode=UIViewContentModeScaleAspectFit;
		UIImage* imgProfilePlaceHolder=[UIImage imageNamed:@"default_user.png"];
		
		__weak UIImageView *weakImgProfilePic = cell.imgProfile;
		
		[cell.imgProfile setImageWithURL:urlProfile
				placeholderImage:imgProfilePlaceHolder
					 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
		 {
			 
			 [activityIndicator2 stopAnimating];
			 [activityIndicator2 removeFromSuperview];
			 
			 UIImageView *strongImgPic = weakImgProfilePic;
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
						 
					 }];
			 
			 
		 } failure:NULL];
		
		
		
		
		//        cell.backgroundColor=[UIColor yellowColor];
		cell.backgroundColor=[UIColor clearColor];
		cell.viContainerImage.backgroundColor=[UIColor clearColor];
		
		
		return cell;
	} else {
		ArtCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier_art forIndexPath:indexPath];
		
		
		for (id view in cell.viContainerImage.subviews) {
			
			if([view isKindOfClass:[UIActivityIndicatorView class]])
				[view removeFromSuperview];
		}
		
		NSDictionary* data=[artlistSearchResult objectAtIndex:indexPath.item];
		
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
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        
        //BestSellingArtistsViewCell *cell =(BestSellingArtistsViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
	if(indexPath.section == 0) {
        NSDictionary* data=[isSearch ? arrSearchResult: _arrBestSellingArtistsList objectAtIndex:indexPath.item];
        
        if(data!=nil){
                
                ArtistDetailViewController* vc=GET_VIEW_CONTROLLER(kArtistDetailViewController);
                vc.from=@"back";
                vc.artUserName=[data objectForKey:@"username"];
                vc.titleString=[data objectForKey:@"name"];
                [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                
        }
	} else {
		NSDictionary* data=[artlistSearchResult objectAtIndex:indexPath.item];
		
		if(data!=nil){
			
			ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
			vc.from=@"back";
			vc.artID=[data objectForKey:@"id"];
			[self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
		}

	}
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


@end
