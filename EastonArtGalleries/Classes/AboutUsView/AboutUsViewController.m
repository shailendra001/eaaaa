//
//  AboutUsViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 31/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsViewCell.h"
#import "AboutUsViewCell1.h"
#import "CustomWebViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_TEXT         @"#575656"


@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,MFMailComposeViewControllerDelegate>
{
        NSDictionary *data;
        NSDictionary *contactData;
        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        float webViewHeight;
        BOOL isLoaded;

}

@end

@implementation AboutUsViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";

#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
    
        [self cellRegister];
        
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
        
        webViewHeight=0;
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[UIColor whiteColor];//[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
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
        
        [self.tableView registerClass:[AboutUsViewCell class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[AboutUsViewCell1 class] forCellReuseIdentifier:CellIdentifier2];
//        //        [self.tableView registerClass:[ArtDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
//        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"AboutUsViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
//
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"AboutUsViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
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

-(void)loadTable{
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:self.tableView
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:nil];
                
                
                
                [self.tableView reloadData];
        });

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
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AboutUs);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
               [dic setObject:@"about-us" forKey:@"page_url"];//{"page_url":"about-us"}
                
                
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
                                        
                                        NSArray*resPonsedataArray = (NSArray*)[result valueForKey:@"pageData"];
                                        NSArray*resContactData = (NSArray*)[result valueForKey:@"contactData"];
                                        
                                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
                                                data=resPonsedataArray.count ? resPonsedataArray[0] :nil;
                                                
                                        }
                                        if([resContactData isKindOfClass:[NSArray class]]){
                                                contactData=resContactData.count ? resContactData[0] :nil;
                                        }
                                        
                                        [self loadTable];

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
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
        switch (section) {
                case 0:
                        return 1;
                        break;
                case 1:
                        return 1;
                        break;
                default:
                        break;
        }
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        
        switch (indexPath.section) {
                
                case 0: finalHeight= webViewHeight;
                        break;
                        
                case 1:{
                        
                        float defaultHeight=21.0f,y=8.0f,bottom=64.0f;
                        if(NO/*data*/){
                                //                        ArtDetailViewCell3 *cell =(ArtDetailViewCell3*)[self.tableView cellForRowAtIndexPath:indexPath];
                                
                                UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-16, 21)];
                                label.font=[UIFont fontWithName:FONT_DOSIS_LIGHT size:13];
                                
                                NSString* htmlString=[data objectForKey:@"description"];
                                NSString* text=[Alert removeHTMLTags:htmlString];
                                
                                
                                label.text=text;
                                label.textAlignment=NSTextAlignmentLeft;
                                label.backgroundColor=[UIColor yellowColor];
                                float height=[Alert getLabelHeight:label];
                                
                                
                                finalHeight=MAX(height, defaultHeight);
                                
                                finalHeight+=y+bottom;
                                
                        }
                        else{
//                                finalHeight=defaultHeight+y+bottom+2;
                                finalHeight=96;
                        }
                        
                }
                        break;
                default:
                        break;
        }
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        //        NSDictionary* data = [self.arrArtCategoryList objectAtIndex:indexPath.row];
        
        if(indexPath.section==0){
                
                AboutUsViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                
                cell.contentView.backgroundColor=[UIColor clearColor];
                cell.contentView.translatesAutoresizingMaskIntoConstraints=
                cell.webView.translatesAutoresizingMaskIntoConstraints=YES;
                
                [cell.webView setFrame:CGRectMake(0, 0, cell.frame.size.width, webViewHeight)];
                
                cell.webView.delegate=self;
                
                
                NSString* htmlString=[data objectForKey:@"description"];
                
                if(!isLoaded)
                [cell.webView loadHTMLString:htmlString baseURL:nil];
                
                cell.webView.backgroundColor=[UIColor clearColor];

                
                cell.webView.scrollView.scrollEnabled = NO;
//                cell.webView.scrollView.bounces = NO;
                
                return cell;
        
        }
        else if(indexPath.section==1){
                AboutUsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.contentView.backgroundColor=[UIColor clearColor];
                cell.lblAboutUs.hidden=YES;
                
                for (id view in cell.contentView.subviews) {
                        
                        if([view isKindOfClass:[UIActivityIndicatorView class]])
                                [view removeFromSuperview];
                }
                
                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator1.frame = CGRectMake(cell.frame.size.width/2-15,
                                                     cell.frame.size.height/4-15,
                                                     30,
                                                     30);
                
                if(data==nil){
                        [activityIndicator1 startAnimating];
                        activityIndicator1.tag=indexPath.row;
                        
                        [activityIndicator1 removeFromSuperview];
                        [cell.contentView addSubview:activityIndicator1];
                        [cell.contentView insertSubview:activityIndicator1 aboveSubview:cell.lblAboutUs];
                }
//                
//                else{
//                        [activityIndicator stopAnimating];
//                        [activityIndicator removeFromSuperview];
//                }

                //NSString* htmlString=[data objectForKey:@"description"];
                //NSString* text=[Alert removeHTMLTags:htmlString];
                
//                cell.userInteractionEnabled=NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.lblAboutUs.text=text;
//                cell.lblAboutUs.text=[data objectForKey:@"description"];
                
                //                cell.btnShowDesc.tag=indexPath.row;
                
                //                [cell.btnShowDesc addTarget:self action:@selector(showDesc:) forControlEvents:UIControlEventTouchUpInside];
//                cell.lblAboutUs.translatesAutoresizingMaskIntoConstraints=YES;
//                cell.viContainerSocial.translatesAutoresizingMaskIntoConstraints=YES;
                
                float height=[Alert getLabelHeight:cell.lblAboutUs];
                
                float defaultHeight=21;
                
                float finalHeight=MAX(height, defaultHeight);
                
                CGRect aboutFrame=cell.lblAboutUs.frame;
                aboutFrame.size.height=finalHeight;
                //cell.lblAboutUs.frame=aboutFrame;
                
                CGRect socialFrame=cell.viContainerSocial.frame;
                socialFrame.origin.y=aboutFrame.origin.y+aboutFrame.size.height;
                
                //cell.viContainerSocial.frame=socialFrame;
//                cell.lblAboutUs.backgroundColor=[UIColor yellowColor];
                
                //Tag
                cell.btnFb.tag=1;
                cell.btnTw.tag=2;
                cell.btnInstagram.tag=3;
                cell.btnPInterest.tag=4;
                cell.btnYoutube.tag=5;
                cell.btnEmail.tag=6;
                
                //Target
                [cell.btnFb addTarget:self action:@selector(link:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnTw addTarget:self action:@selector(link:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnInstagram addTarget:self action:@selector(link:) forControlEvents:UIControlEventTouchUpInside];
                 [cell.btnPInterest addTarget:self action:@selector(link:) forControlEvents:UIControlEventTouchUpInside];
                 [cell.btnYoutube addTarget:self action:@selector(link:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnEmail addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
                
                [UIView transitionWithView:cell
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:nil];
                
                cell.lblSeparatorLine.hidden=YES;
                
                return cell;
        }
        
        
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
}

#pragma mark-
#pragma mark Web View Delegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
        
        NSString *result = [aWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
        
        webViewHeight = [result integerValue];
        
////        webViewHeight=aWebView.scrollView.contentSize.height;
//        CGSize goodSize = [aWebView sizeThatFits:aWebView.scrollView.contentSize];
//        webViewHeight=goodSize.height;
        
        
        isLoaded=data!=nil ? YES : NO;
        
        if(data && webViewHeight>0){
                webViewHeight+=10;
                [self.tableView reloadData];
        }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
        
        webViewHeight=0;
        [self loadTable];

}


#pragma mark - Email

-(void)email{
        if (!TARGET_IPHONE_SIMULATOR) {
                if(contactData){

                        NSString* to=[contactData objectForKey:@"email"];
                        
                        [Alert performBlockWithInterval:0.30 completion:^{
                                [self sendEmail:to];
                        }];
                }
                
        } else {
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"Your device doesn't support this feature."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [notPermitted show];;
        }
}

-(void)sendEmail:(NSString*)to{
        
        if ([MFMailComposeViewController canSendMail])
        {
                
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setSubject:@"Easton Art Galleries"];
                [mail setMessageBody:@"" isHTML:NO];
                [mail setToRecipients:@[to]];
                [self presentViewController:mail animated:YES completion:NULL];
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


#pragma mark - Action Methods

-(IBAction)link:(UIButton*)sender{
        
        NSString* key=@"";
        NSString* title=@"";
        switch (sender.tag) {
                case 1:
                        key=@"facebook_url";
                        title=@"Facebook";
                        
                        break;
                case 2:
                        key=@"twitter_url";
                        title=@"Twitter";
                        
                        break;
                case 3:
                        key=@"instagram_url";
                        title=@"Instagram";
                        break;
                case 4:
                        key=@"pinterest_url";
                        title=@"PInterest";
                        break;
                        
                case 5:
                        key=@"youtube_url";
                        title=@"YouTube";
                        break;
                default:
                        break;
        }
        if(contactData){
                CustomWebViewController* vc=GET_VIEW_CONTROLLER(kWebViewController);
                vc.titleString=title;
                vc.urlString=contactData ? [contactData objectForKey:key] : @"";
                vc.from=@"back";
                [Alert performBlockWithInterval:0.30 completion:^{

                        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                }];
        }
}
-(IBAction)email:(UIButton*)sender{
        
        [self email];
       
}

@end
