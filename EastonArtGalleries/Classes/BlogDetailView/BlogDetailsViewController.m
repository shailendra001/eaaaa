//
//  BlogDetailsViewController.m
//  EastonArtGalleries
//
//  Created by Infoicon on 26/10/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "BlogDetailsViewController.h"

#define IMAGE_BLOG_HEIGHT       165.0f
#define CELL_BLOG_CONTAINER_HEIGHT  299.0f
#define COLOR_CELL_TITLE        @"#840F16"

@interface BlogDetailsViewController ()
{
    
    DataBaseHandler *dataManager;
    UIView* cardViewGlobal;
    UIView* cardCountViewGlobal;
    NSInteger lastPageNumber;
}
@end

@implementation BlogDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self config];
    [self setLogoImage];
    
    [self rightNavBarConfiguration];
    
    [self setData];
    
    [self setNav];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self.viewDeckController setLeftLedge:65];
    
    [self loadCardCount];
}

#pragma mark - Custom Methods

-(void)config{
    dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
    
}
-(void)setNav{
    
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

-(void)setLogoImage{
    UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
    UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
    imgLogo.frame=CGRectMake(0, 0, 49, 44);
    
    UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
    [logoView addSubview:imgLogo];
    
    self.navigationItem.titleView =logoView;
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



-(void)setData{
    
    NSDictionary* dic = _dict;

    BOOL isImage=!IS_EMPTY([dic objectForKey:@"feature_image"]);
    //        isImage=indexPath.row==1 ? NO : YES;
    if(isImage){
        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator1.frame = CGRectMake(self.viContainerDetail.frame.size.width/2-15,
                                              self.viContainerDetail.frame.size.height/2-15,
                                              30,
                                              30);
        [activityIndicator1 startAnimating];
        
        //        [activityIndicator1 removeFromSuperview];
        [self.viContainerDetail addSubview:activityIndicator1];
        [self.viContainerDetail insertSubview:activityIndicator1 aboveSubview:self.img];
        
        
        NSString* path=_baseURL ?[_baseURL stringByAppendingString:[dic objectForKey:@"feature_image"]] : [dic objectForKey:@"feature_image"];
        
        NSURL* url=[NSURL URLWithString:path];
        
        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
        
        
        
        __weak UIImageView *weakImgPic = self.img;
        [self.img setImageWithURL:url
                 placeholderImage:imgPlaceHolder
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
             [activityIndicator1 stopAnimating];
             [activityIndicator1 removeFromSuperview];
             
             UIImageView *strongImgPic = weakImgPic;
             if (!strongImgPic) return;
             
             [UIView transitionWithView:strongImgPic
                               duration:0.3
                                options:UIViewAnimationOptionTransitionCrossDissolve
              
                             animations:^{
                                 strongImgPic.image=image;
                                 
                             }
                             completion:^(BOOL finish){
                             }];
             
             
         } failure:NULL];
        
        
        
//        //Image
//        CGRect imgFrame=self.img.frame;
//        imgFrame.size.height=IMAGE_BLOG_HEIGHT;
//        self.img.frame=imgFrame;
//
//        //Desc
//        CGRect descFrame=self.lblDesc.frame;
//        descFrame.origin.y=imgFrame.origin.y+imgFrame.size.height+8;
//        self.lblDesc.frame=descFrame;
//
//
//        //Desc
//        CGRect viFrame=self.viContainerDetail.frame;
//        viFrame.size.height=CELL_BLOG_CONTAINER_HEIGHT;
//        self.viContainerDetail.frame=viFrame;
        
    }
    else{
//        //Image
//        CGRect imgFrame=self.img.frame;
//        imgFrame.size.height=0;
//        self.img.frame=imgFrame;
//
//        //Desc
//        CGRect descFrame=self.lblDesc.frame;
//        descFrame.origin.y=imgFrame.origin.y;
//        self.lblDesc.frame=descFrame;
//
//
//        //Desc
//        CGRect viFrame=self.viContainerDetail.frame;
//        viFrame.size.height=CELL_BLOG_CONTAINER_HEIGHT-IMAGE_BLOG_HEIGHT;
//        self.viContainerDetail.frame=viFrame;
        
    }
    
    
    self.lblName.text=[dic objectForKey:@"title"];
    NSString* posted_on=[dic objectForKey:@"posted_on"];
    NSString* posted_by=[dic objectForKey:@"posted_by"];
    //reviewDate=[Alert getDateWithString:reviewDate getFormat:@"yyyy-MM-dd HH:mm:ss" setFormat:@"yyyy-MM-dd"];
    self.lblDate.text=[NSString stringWithFormat:@"Posted on %@ By %@",posted_on,posted_by];
    
    UIColor* color2=[Alert colorFromHexString:COLOR_CELL_TITLE];
    NSString* htmlString=[dic objectForKey:@"desc"];
    //NSString* text=[Alert removeHTMLTags:htmlString];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.textViewDesc.attributedText = attributedString;
    
   // self.textViewDesc.text=text;
    NSInteger lenght=[self.textViewDesc.text length];
    //int lines=(cell.lblDesc.frame.size.height+20)/cell.lblDesc.font.pointSize;
    int subLength=164;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
