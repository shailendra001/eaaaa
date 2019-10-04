//
//  ContactUsViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 31/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ContactUsViewCell1.h"
#import "ContactUsViewCell2.h"
#import "ContactUsViewCell3.h"
#import "ContactUsViewCell4.h"

#define COLOR_CELL_BACKGROUND           @"#DEDEDD"
#define COLOR_CELL_TEXT                 @"#575656"
#define COLOR_CELL_CONTENT_BORRDER      @"#CBC9C9"
#define COLOR_CELL_TEXT_PLACEHOLDER     @"#8E8E8E"

#define PLACEHOLDER_MESSAGE             @"Enter your message"


@interface ContactUsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
        NSDictionary *data;
        UIActivityIndicatorView *activityIndicator;
        BOOL isUpdateHeight;
        NSMutableArray* arrTextData;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
}


@end

@implementation ContactUsViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";


#pragma mark - View controller life cycle


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
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        arrTextData=[[NSMutableArray alloc]init];
        
        for (int i=0; i<4; i++) {
                [arrTextData addObject:@""];
        }
        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        self.view.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
        [Alert setShadowOnViewAtTop:self.viContainerSend];
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
        
        [self.tableView registerClass:[ContactUsViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[ContactUsViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[ContactUsViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[ContactUsViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"ContactUsViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        //
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"ContactUsViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];

        UINib *contantsCellNib3 = [UINib nibWithNibName:@"ContactUsViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"ContactUsViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];

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
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ContactUs);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                // [dic setObject:self.artUserName forKey:@"artist_name"];//{"artist_name":"deepak"}
                
                
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
                                        
                                        NSArray*resPonsedataArray = (NSArray*)[result valueForKey:@"contactData"];
                                        
                                        if([resPonsedataArray isKindOfClass:[NSArray class]]){
                                                // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                        data=resPonsedataArray.count ? resPonsedataArray[0] :nil;
                                                        
                                                        [UIView transitionWithView:self.tableView
                                                                          duration:0.3
                                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                         
                                                                        animations:nil
                                                                        completion:nil];
                                                        
                                                        
                                                        
                                                        [self.tableView reloadData];
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


-(void)sendFeedbackWebService:(NSDictionary*)dic{
        
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_FeedBack);
                
                
//                {
//                        "name":"deepak",
//                        "email":"deepak@gmail.com",
//                        "phone":"9312367787",
//                        "message":"testssage",
//                        "status":"1",
//                        "ip":"17.20.253.12",
//                        "addede_on":"10-04-2016"
//                }
//                
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
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
                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
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
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                    
                                    [self showSuccessPopup:[result valueForKey:@"msg"]];
                                    
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                         [Alert alertWithMessage:[result valueForKey:@"msg"]
//                                                      navigation:self.navigationController
//                                                        gotoBack:YES animation:YES second:2.0];
//                                        });
                                    
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:YES animation:YES second:2.0];
                                        });
                                        
                                }
                                
                                else{
                                }
                                
                                
                                
                                
                        }
                        
                }
                
        });
        
}

-(void)showSuccessPopup:(NSString*)message{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"SUCCESS"
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0;
        
        
        switch (indexPath.row) {
                        
                case 0:
                        finalHeight= data ? 183.0f : 40;
                        break;
                case 1:
                        finalHeight= 80.0f;
                        break;
                case 2:
                        finalHeight= 44.0f;
                        break;
                case 3:
                        finalHeight= 92.0f;
                        break;
                default:
                        break;
        }
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
//        NSDictionary* data = [self.arrArtCategoryList objectAtIndex:indexPath.row];
        
        if(indexPath.row==0){
                ContactUsViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator1.frame = CGRectMake(cell.frame.size.width/2-15,
                                                     cell.frame.size.height/3-15,
                                                     30,
                                                     30);
                
                if(data==nil){
                        [activityIndicator1 startAnimating];
                        activityIndicator1.tag=indexPath.row;
                        
                        [activityIndicator1 removeFromSuperview];
                        [cell.contentView addSubview:activityIndicator1];
                        [cell.contentView insertSubview:activityIndicator1 aboveSubview:cell.viContainerAddress];
                }
                //
                //                else{
                //                        [activityIndicator stopAnimating];
                //                        [activityIndicator removeFromSuperview];
                //                }
                
                cell.viContainerAddress.hidden=
                cell.viContainerPhone.hidden=
                cell.viContainerEmail.hidden= data ? NO : YES;
                
                cell.lblAddress.text=[data objectForKey:@"address"];
                
                cell.lblPhone.text=[data objectForKey:@"phone"];
                
                cell.lblEmail.text=[data objectForKey:@"email"];
                
                [cell.btnPhone addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnEmail addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
                
//                [UIView transitionWithView:cell
//                                  duration:0.3
//                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                 
//                                animations:nil
//                                completion:nil];
                
                float defaultHeight=183.0f;
                cell.translatesAutoresizingMaskIntoConstraints=YES;
                CGRect frame=cell.frame;
                frame.size.height=data ? defaultHeight : 0;
                cell.frame=frame;
//                cell.lblSeparatorLine.hidden=YES;
                
                return cell;
        }
        
        else if(indexPath.row==1){
                ContactUsViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.txtName.tag=indexPath.row;
                
                cell.txtName.text=[arrTextData objectAtIndex:indexPath.row];
                
                cell.txtName.delegate=self;
                
                cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                
                cell.txtName.keyboardType = UIKeyboardTypeDefault;
                
                [cell.txtName addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingChanged];
                
                cell.viContainerName.layer.borderWidth=1.5f;
                cell.viContainerName.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;

                //Tint color
                cell.txtName.tintColor=[UIColor blackColor];
                
                //Text color
                cell.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your name" attributes:@{ NSForegroundColorAttributeName : [Alert colorFromHexString:COLOR_CELL_TEXT_PLACEHOLDER] }];
                
               return cell;
        }
        
        else if(indexPath.row==2){
                
                ContactUsViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.txtEmail.tag=indexPath.row;
                
                cell.txtEmail.text=[arrTextData objectAtIndex:indexPath.row];
                
                cell.txtEmail.delegate=self;
                
                cell.txtEmail.autocorrectionType=UITextAutocorrectionTypeNo;
                
                cell.txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
                
                [cell.txtEmail addTarget:self
                                  action:@selector(textFieldDidChange:)
                        forControlEvents:UIControlEventEditingChanged];
                
                cell.viContainerEmail.layer.borderWidth=1.5f;
                cell.viContainerEmail.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                
                //Tint color
                cell.txtEmail.tintColor=[UIColor blackColor];
                
                //Text color
                cell.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email address" attributes:@{ NSForegroundColorAttributeName : [Alert colorFromHexString:COLOR_CELL_TEXT_PLACEHOLDER] }];
                
                return cell;
        }
        
        else if(indexPath.row==3){
                
                
                ContactUsViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.txtviMessage.tag=indexPath.row;
                
                cell.txtviMessage.text=[arrTextData objectAtIndex:indexPath.row];
                
                cell.txtviMessage.delegate=self;
                
                cell.txtviMessage.autocorrectionType=UITextAutocorrectionTypeNo;
                
                
                cell.txtviMessage.keyboardType = UIKeyboardTypeDefault;
                
                cell.viContainerMessage.layer.borderWidth=1.5f;
                cell.viContainerMessage.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                
                //Tint color
                cell.txtviMessage.tintColor=[UIColor blackColor];
                
                //Text color
                
                cell.txtviMessage.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT_PLACEHOLDER];
                
                cell.txtviMessage.text=PLACEHOLDER_MESSAGE;
                
                
                return cell;
        }

        
        
        
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        
}


#pragma Mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        
        [textField resignFirstResponder];
        
        
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        
        return YES;
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
        
        
        
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
        
        if(textField.tag==1 && !IS_EMPTY(textField.text)){
                BOOL isName=[Alert validationString:textField.text];
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
        }
       else if(textField.tag==2 && !IS_EMPTY(textField.text)){
                BOOL isEmail=[Alert validationEmail:textField.text];
                
                if(!isEmail){
                        [Alert alertWithMessage:@"Invalid email ! Please enter valid email address."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
        }
       
        if(isUpdateHeight){
               self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                self.tableView.frame.origin.y,
                                                self.tableView.frame.size.width,
                                                self.view.frame.size.height-50);
        }
       
        isUpdateHeight=NO;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender{
//        isUpdate=YES;
//        //[self.btnUpdate setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        
//        //[Alert viewButtonCALayer:[UIColor grayColor] viewButton:self.btnUpdate];
//        self.btnUpdate.backgroundColor=[UIColor orangeColor];
//        
        BOOL isValid=NO;
//
        UITextField* txt=(UITextField*)sender;
        if(txt.tag==1)
                isValid=[Alert validationString:txt.text];
        if(txt.tag==2)
                isValid=[Alert validationEmail:txt.text];

        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
        
        arrTextData[txt.tag]=txt.text;
        
}


#pragma mark - TextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
        textView.backgroundColor = [UIColor whiteColor];
        //    textView.textColor=[UIColor blackColor];
        
        
        
        if([textView.text isEqualToString:PLACEHOLDER_MESSAGE]){
                textView.textColor = [UIColor blackColor];
                textView.text = @"";
        }
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textView.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
        //  NSLog(@"textViewShouldEndEditing:");
        
        // textView.textColor= [UIColor blackColor];
        return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
        //    NSLog(@"textViewDidEndEditing:");
        if(textView.text.length == 0){
                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT_PLACEHOLDER];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
        if(isUpdateHeight){
        
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-50);

        }
        isUpdateHeight=NO;
        
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
        NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
        NSUInteger location = replacementTextRange.location;
        
        if (textView.text.length + text.length > 140){
                if (location != NSNotFound){
                        [textView resignFirstResponder];
                }
                return NO;
        }
        else if (location != NSNotFound){
                [textView resignFirstResponder];
                return NO;
        }
        return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
        //    NSLog(@"textViewDidChangeSelection:");
}
-(void) textViewDidChange:(UITextView *)textView{
        
        //[self validateForNativeChat];
        
        if(textView.text.length == 0){
                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT_PLACEHOLDER];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
}



-(NSString*)getNumber:(NSString*)string{
        
        NSArray* arr = [[string stringByReplacingOccurrencesOfString:@" " withString:@""]componentsSeparatedByString: @")"];
        if(arr.count==2){
                NSString* number=arr[1];
                number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                number=[@"0" stringByAppendingString:number];
                return number;
        }
        else if(arr.count==1){
                NSString* number=arr[0];
                number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return number;
        }
        return nil;
}

-(void)callPhone:(NSString*)number {
        
        NSString* call=[NSString stringWithFormat:@"tel:%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0)
        {
                if(alertView.tag==1000){
                        
                        NSString* mobile=[data objectForKey:@"phone"];
                        mobile=[mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSString* number=[self getNumber:mobile];
                        
                        [self callPhone:number];
                }
                
                
        }
}






#pragma mark - Action Mthods

-(IBAction)call:(id)sender{
        
        
        if (!TARGET_IPHONE_SIMULATOR) {
                
                
                UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil
                                                              message:@"Do you want call ?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Call"
                                                    otherButtonTitles:@"Cancel", nil];
                alrt.tag=1000;
                [alrt show];
        } else {
                UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"Your device doesn't support this feature."
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                notPermitted.tag=1001;
                [notPermitted show];;
        }
}


-(IBAction)email:(id)sender{
        
}

- (IBAction)send:(id)sender {
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        NSIndexPath* index1=[NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2=[NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath* index3=[NSIndexPath indexPathForRow:3 inSection:0];
        ContactUsViewCell2* cell2=[self.tableView cellForRowAtIndexPath:index1];
        NSString* name=[Alert trimString:cell2.txtName.text];
        ContactUsViewCell3* cell3=[self.tableView cellForRowAtIndexPath:index2];
        NSString* email=[Alert trimString:cell3.txtEmail.text];
        ContactUsViewCell4* cell4=[self.tableView cellForRowAtIndexPath:index3];
        NSString* msg=[Alert trimString:cell4.txtviMessage.text];
        
        NSString* date=[[Alert getDateFormatWithString:@"dd-MM-yyyy"] stringFromDate:[NSDate date]];
        
        
        if(IS_EMPTY(name) && IS_EMPTY(email) && [msg isEqualToString:PLACEHOLDER_MESSAGE]){
                
                [Alert alertWithMessage:@"Fields can not be blank! Please enter name, email and message."
                             navigation:self.navigationController
                               gotoBack:NO animation:YES second:3.0];
                return;
        }
        
        if(!IS_EMPTY(name)){
                
                BOOL isName=[Alert validationString:name];
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                        
                }
        }
        else if(!IS_EMPTY(email)){
                
                BOOL isEmail=[Alert validationEmail:email];
                
                if(!isEmail){
                        [Alert alertWithMessage:@"Invalid email ! Please enter valid email address."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
        }
        
        [dic setObject:name     forKey:@"name"];
        [dic setObject:email    forKey:@"email"];
        [dic setObject:msg      forKey:@"message"];
        
        [dic setObject:@"1"     forKey:@"status"];
        [dic setObject:@""      forKey:@"ip"];
        [dic setObject:@""      forKey:@"phone"];
        [dic setObject:date     forKey:@"addede_on"];
        
        [self sendFeedbackWebService:dic];
        
        
        //                {
        //                        "name":"deepak",
        //                        "email":"deepak@gmail.com",
        //                        "phone":"9312367787",
        //                        "message":"testssage",
        //                        "status":"1",
        //                        "ip":"17.20.253.12",
        //                        "addede_on":"10-04-2016"
        //                }
        //
}


@end
