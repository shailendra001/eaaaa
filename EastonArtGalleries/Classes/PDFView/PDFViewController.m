//
//  PDFViewController.m
//  iOSPDFRenderer
//
//  Created by Sandeep Kumar on 11/05/16.
//  Copyright © 2016 infoicon. All rights reserved.

#import "PDFViewController.h"
//#import "CoreText/CoreText.h"
#import "PDFRenderer.h"

@interface PDFViewController ()
{
        
        NSMutableArray *data;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        DataBaseHandler *dataManager;
        
}

@end

@implementation PDFViewController

#pragma mark - View controller life cycle

- (void)viewDidLoad{
        [super viewDidLoad];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
        
        
        
        //Generate PDF and will be save to file path
        NSString* fileName = [self getPDFFileName];
        [self createPDFWithFileName:fileName allInfo:self.allInfo];
        
        //Show PDF in Web view
        [self showPDFFile];
    
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

- (void)didReceiveMemoryWarning{
        // Releases the view if it doesn't have a superview.
        [super didReceiveMemoryWarning];
        
        // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Custom Methods

-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        self.lblTitle.text=[self.titleString uppercaseString];
        
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

-(void)rightNavBarConfiguration{
        /*
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
        
        */
        //Share icon
        UIImageView* shareImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        shareImageView.image=[UIImage imageNamed:@"share_icon.png"];
        
        
        UIButton * shareButton  = [ZFRippleButton buttonWithType:UIButtonTypeSystem];
        shareButton.frame = CGRectMake(0, 0, 30, 30);
        shareButton.layer.cornerRadius=shareButton.frame.size.width/2;
        [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* shareView=[[UIView alloc]initWithFrame:CGRectMake(15, 5, 30, 30)];
        shareView.backgroundColor=[UIColor clearColor];
        [shareView addSubview:shareImageView];
        [shareView addSubview:shareButton];
        
        
        
        UIView* rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        rightView.backgroundColor=[UIColor clearColor];
        
        [rightView addSubview:shareView];
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        [rightView alignmentRectInsets];
        
        
        self.navigationItem.rightBarButtonItem = rightBarItem;
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

-(IBAction)share:(id)sender{

        NSString* fileName = [self getPDFFileName];
        
        NSArray* imageArray=[Alert splitPDFIntoImages:[NSURL fileURLWithPath:fileName]
                                       withOutputName:[self.allInfo objectForKey:@"id"]
                                        intoDirectory:@"pdf"];
        
        if(imageArray){
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:imageArray applicationActivities:nil];
                
//                NSArray *excludeActivities = @[];
//                activityViewController.excludedActivityTypes = excludeActivities;
                
                [self presentViewController:activityViewController animated:YES completion:nil];
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

#pragma mark - PDF Methods

-(void)createPDFWithFileName:(NSString*)fileName allInfo:(NSDictionary*)allInfo{
        
        [PDFRenderer drawPDF:fileName allInfo:allInfo];
}

-(void)showPDFFile{
        NSString* pdfFileName = [self getPDFFileName];

        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(
                                                                     0,
                                                                     self.viContainerTitleBar.bounds.size.height,
                                                                     self.view.bounds.size.width,
                                                                     self.view.bounds.size.height-self.viContainerTitleBar.bounds.size.height)];

        NSURL *url = [NSURL fileURLWithPath:pdfFileName];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView setScalesPageToFit:YES];
        [webView loadRequest:request];



        [self.view addSubview:webView];
        
        [self.view insertSubview:self.viContainerTitleBar aboveSubview:webView];
   
}

-(NSString*)getPDFFileName{
    NSString* fileName = [[self.allInfo objectForKey:@"id"] stringByAppendingString:@".pdf"];
    
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;

}



@end
