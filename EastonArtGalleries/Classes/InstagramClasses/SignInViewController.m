//
//  SignInViewController.m
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
{
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        BOOL isCard;
}

@end

@implementation SignInViewController

#pragma mark -- ViewController life cycle

- (void)viewDidLoad{
        [super viewDidLoad];
    
        [self config];
        
        //[self rightNavBarConfiguration];
        
        
        
        [self loadSigninView];
    
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];

//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
        [self logout];
	
    
}

-(void)viewDidDisappear:(BOOL)animated{
 
        [super viewDidDisappear:animated];
        
        [_gAppDelegate showLoadingView:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
//	_ReleaseObject(_webView);
//    [super dealloc];
}

#pragma mark - Custom Methods

- (void)config{
        
        self.title = @"Instagram Login";
        
        [_webView sizeToFit];
        _webView.scrollView.scrollEnabled = NO;
}

-(void)setNav{
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}

-(void)loadSigninView{
        
        NSString* urlString = [kBaseURL stringByAppendingFormat:kAuthenticationURL,kInstagramClientID,kRedirectURI];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        if (![UIUtils checkNetworkConnection])
                return;
        
        [_webView loadRequest:request];

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

- (void) backBtnPressed{
    [_gAppDelegate showLoadingView:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Instagram

- (void) logout{
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://instagram.com/"]];
        NSArray *allCookies = [cookies cookies];
        for (NSHTTPCookie* cookie in allCookies)
        {
//                [cookies deleteCookie:cookie];
                if([[cookie domain] rangeOfString:@"instagram.com"].location != NSNotFound) {
                        [cookies deleteCookie:cookie];
                }
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark -- WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    NSURL *Url = [request URL];
    NSArray *UrlParts = [Url pathComponents];
    
    // runs a loop till the user logs in with Instagram and after login yields a token for that Instagram user
    // do any of the following here
    if ([UrlParts count] == 1)
    {
        NSRange tokenParam = [urlString rangeOfString: kAccessToken];
        if (tokenParam.location != NSNotFound)
        {
            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            // If there are more args, don't include them in the token:
            NSRange endRange = [token rangeOfString: @"&"];
            
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            
            if ([token length] > 0 )
            {
                // call the method to fetch the user's Instagram info using access token
                [_gAppData getUserInstagramWithAccessToken:token fileName:self.fileName image:self.shareImage];
            }
        }
        else
        {
            DLog(@"rejected case, user denied request");
        }
        return NO;
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView{
	[_gAppDelegate showLoadingView:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_gAppDelegate showLoadingView:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DLog(@"Code : %d \nError : %@",error.code, error.description);
    //Error : Error Domain=WebKitErrorDomain Code=102 "Frame load interrupted"
    if (error.code == 102)
        return;
    if (error.code == -1009 || error.code == -1005)
    {
        //        _completion(kNetworkFail,kPleaseCheckYourInternetConnection);
    }
    else
	{
        //        _completion(kError,error.description);
	}
    [UIUtils networkFailureMessage];
}

@end
