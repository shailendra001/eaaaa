//
//  OrderDetailViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailViewCell1.h"
#import "OrderDetailViewCell2.h"
#import "OrderDetailViewCell3.h"
#import "OrderDetailViewCell4.h"
#import "PDFViewController.h"

#define COLOR_CELL_BACKGROUND           @"#DEDEDD"
#define COLOR_CELL_TEXT                 @"#575656"
#define COLOR_CELL_HEADER               @"#3C3A3A"
#define PLACEHOLDER_MESSAGE_REVIEW      @"Write your review here"
#define PLACEHOLDER_MESSAGE_CANCELORDER @"Reason of cancellation"


@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,DLStarRatingDelegate>
{
        NSMutableArray *data;
        UIActivityIndicatorView *activityIndicator;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        DataBaseHandler *dataManager;
        
        CGRect frameReview;
        CGRect frameCancelOrder;
        
        float ratingResult;
        UIImage* selectedImage;
}

@end

@implementation OrderDetailViewController
@synthesize arrData;
@synthesize baseURL;

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";


#pragma mark - View controller life cycle

- (void)viewDidLoad {
        
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self setReviewAndRatingView];
        
        [self setCancelOrderView];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        if(self.orderID)
        {
                
                [self setActivityIndicator];
                [self.tableView reloadData];
                
                //ALL Order : {"id":"256"}
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:self.orderID     forKey:@"id"];
                
                [self getWebService:[dic mutableCopy]];
        }
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
        
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        [self loadCardCount];
        
        [self loadTable];
        
        
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

-(void)setReviewAndRatingView{
        
        //        frameReview=self.viContainerReview.frame;
        
        
        //UI
        self.viContainerReview.backgroundColor=[UIColor whiteColor];
        self.viContainerReview.layer.cornerRadius=5.0;
        self.viContainerReview.layer.masksToBounds=YES;
        
        self.viContainerReviewClose.layer.cornerRadius=self.viContainerReviewClose.bounds.size.width/2;
        self.viContainerReviewClose.layer.masksToBounds=YES;
        self.viContainerReviewClose.backgroundColor=[UIColor clearColor];
        self.txtviReview.layer.borderWidth=1.0;
        self.txtviReview.layer.borderColor=[UIColor grayColor].CGColor;
        
        self.viContainerReviewSubmit.layer.cornerRadius=2.0;
        self.viContainerReviewSubmit.layer.masksToBounds=YES;
        
        self.txtviReview.tag=1;
        self.txtviReview.delegate=self;
        self.txtviReview.backgroundColor=[UIColor clearColor];
        
        self.btnReviewClose.tag=1;
        
        [Alert changeImageColor:self.imgReviewClose.image imageView:self.imgReviewClose andColor:[UIColor whiteColor]];
        
        
        
        [self.btnReviewClose addTarget:self action:@selector(popupClose:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnReviewSubmit addTarget:self action:@selector(submitReview:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
}

-(void)setCancelOrderView{
        
        //        frameReview=self.viContainerReview.frame;
        
        
        //UI
        self.viContainerCancelOrder.backgroundColor=[UIColor whiteColor];
        
        self.viContainerCancelOrderClose.layer.cornerRadius=self.viContainerCancelOrderClose.bounds.size.width/2;
        self.viContainerCancelOrderClose.layer.masksToBounds=YES;
        self.viContainerCancelOrderClose.backgroundColor=[UIColor clearColor];
        
        self.viContainerCancelOrderSubmit.layer.cornerRadius=2.0;
        self.viContainerCancelOrderSubmit.layer.masksToBounds=YES;
        
        self.txtviCancelOrder.layer.borderWidth=1.0;
        self.txtviCancelOrder.layer.borderColor=[UIColor grayColor].CGColor;
        self.txtviCancelOrder.tag=2;
        self.txtviCancelOrder.delegate=self;
        self.txtviReview.backgroundColor=[UIColor clearColor];
        
        self.btnCancelOrderClose.tag=2;
        
        [self.btnCancelOrderClose addTarget:self action:@selector(popupClose:) forControlEvents:UIControlEventTouchUpInside];
        
        self.viContainerBrowse.layer.borderWidth=1.0;
        self.viContainerBrowse.layer.borderColor=[UIColor grayColor].CGColor;
        self.viContainerBrowse.backgroundColor=[UIColor clearColor];
        self.viContainerBrowse.layer.cornerRadius=5.0;
        self.viContainerBrowse.layer.masksToBounds=YES;
        
        self.lblBrowse.textColor=[UIColor blackColor];
        self.lblBrowse.text=@"Choose file";
        
        [Alert changeImageColor:self.imgCancelOrderClose.image imageView:self.imgCancelOrderClose andColor:[UIColor whiteColor]];
        
        
        [self.btnBrowse addTarget:self action:@selector(choosePic:) forControlEvents:UIControlEventTouchUpInside];
        
}

-(void)showPopView:(UIView*)customView{
        
        //        customView.frame=frameReview;
        
        CGRect frame=customView.frame;
        frame.origin=CGPointMake(self.view.frame.size.width/2-frame.size.width/2,
                                 self.view.frame.size.height/3-frame.size.height/2);
        customView.frame=frame;
        customView.tag=1001;
        
        [Alert shadowAtBottom:customView];
        
        UIView* viBackground=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        viBackground.tag=1000;
        viBackground.backgroundColor=[UIColor clearColor];
        
        //        self.view.barStyle = UIBarStyleBlack; // this will give a black blur as in the original post
        viBackground.opaque = NO;
        viBackground.alpha = 0.5;
        viBackground.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self.view addSubview:viBackground];
        [self.view addSubview:customView];
        
        
        
        customView.hidden = NO;
        customView.alpha = 0.1;
        [UIView animateWithDuration:0.25 animations:^{
                customView.alpha = 1.0f;
        } completion:^(BOOL finished) {
                // do some
        }];
        
        customView.layer.cornerRadius=5.0;
        customView.layer.masksToBounds=YES;
}

-(void)removePopup{
        
        for (UIView* view in self.view.subviews) {
                if(view.tag==1000 || view.tag==1001)//if([view isKindOfClass:[AlertCustomView class]])
                {
                        [UIView animateWithDuration:0.25 animations:^{
                                [view setAlpha:0.1f];
                        } completion:^(BOOL finished) {
                                view.hidden = YES;
                                [view removeFromSuperview];
                        }];
                }
        }
        
        
}



-(void)config{
        
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        
        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        //self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        //        self.view.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
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
        
        [self.tableView registerClass:[OrderDetailViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[OrderDetailViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[OrderDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[OrderDetailViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"OrderDetailViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"OrderDetailViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"OrderDetailViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"OrderDetailViewCell4" bundle:nil];
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
        
        NSString* msg=@"No Data Found" ;
        
        messageLabel.text = msg;
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

-(BOOL)isFromMyOrder{
        
        return [self.fromVC isEqualToString:kMyOrderViewController] ?   YES : NO;
        
}

#pragma mark -
#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
        NSLog(@"%@",[NSString stringWithFormat:@"%0.1f star rating",rating]);
        ratingResult=rating;
}

-(void)setRating:(float)rate{
        DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:self.viRating.frame andStars:5 isFractional:YES];
        customNumberOfStars.delegate = self;
        customNumberOfStars.backgroundColor = [UIColor clearColor];
        customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        customNumberOfStars.rating = rate;
        [self.viContainerReview addSubview:customNumberOfStars];
        [self.viContainerReview insertSubview:customNumberOfStars aboveSubview:self.viRating];
}

-(void)removeRating:(NSArray*)subviews{
        
        for (UIView* view in subviews) {
                if([view isKindOfClass:[DLStarRatingControl class]])
                        [view removeFromSuperview];
        }
}

#pragma mark -Call WebService -

-(void)getWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_OrderDetail);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                NSMutableURLRequest *theRequest=[Alert getRequestUploadImageWithPostString:postString
                                                                                 urlString:urlString
                                                                                    images:nil];
                
                
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [self setBackgroundLabel];
                                
                        });
                }
                else
                {
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                
                        });
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self setBackgroundLabel];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                
                                if (success.boolValue) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self removeBackgroundLabel];
                                        });
                                        
                                        NSArray*resData = (NSArray*)[result valueForKey:@"orderDetails"];
                                        
                                        
                                        if([resData isKindOfClass:[NSArray class]]){
                                                arrData=resData.count ? [resData mutableCopy] :nil;
                                        }
                                        
                                        
                                        
                                        [self loadTable];
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

-(void)rateArtWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_RateArt);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                NSMutableURLRequest *theRequest=[Alert getRequestUploadImageWithPostString:postString
                                                                                 urlString:urlString
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
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                                                 error:nil];
                        
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [[SharedClass sharedObject] hudeHide];
                                        [Alert alertWithMessage:[result objectForKey:@"msg"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:3.0];
                                        
                                });
                                
                                if (success.boolValue) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                self.txtviReview.text=PLACEHOLDER_MESSAGE_REVIEW;
                                                [self removeRating:self.viContainerReview.subviews];
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

/*
 -(void)addArtWebService:(NSDictionary*)dic images:(NSArray*)images{
 
 const char* className=[NSStringFromSelector(_cmd) UTF8String];
 
 dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
 dispatch_async(myQueue, ^{
 
 
 NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_RateArt);
 
 NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
 
 
 NSLog(@" tempURL :%@---",urlString);
 
 
 
 NSMutableURLRequest *theRequest =[Alert getOnlyRequesteWithUrlString:urlString
 methodType:REQUEST_METHOD_TYPE_POST
 images:images];
 NSMutableData* httpBody=[Alert getBodyForMultipartDataWithPostString:postString images:images];
 
 self.session = [NSURLSession sharedSession];  // use sharedSession or create your own
 
 dispatch_async(dispatch_get_main_queue(), ^{
 [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
 
 });
 
 NSURLSessionTask *task = [self.session uploadTaskWithRequest:theRequest fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 
 NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data
 options:NSJSONReadingMutableContainers
 error:nil];
 
 dispatch_async(dispatch_get_main_queue(), ^{
 [[SharedClass sharedObject] hudeHide];
 
 });
 
 if ([result isKindOfClass:[NSNull class]] ||result == nil  || error)
 {
 dispatch_async(dispatch_get_main_queue(), ^{
 [Alert alertWithMessage:@"Something went wrong ! Please try later."
 navigation:self.navigationController
 gotoBack:NO animation:YES second:3.0];
 
 });
 
 }
 else
 {
 
 NSLog(@"Response : %@", result);
 NSString *success  = [result valueForKey:@"success"];
 NSString *error  = [result valueForKey:@"error"];
 
 if (success.boolValue) {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 
 [Alert alertWithMessage:[result objectForKey:@"msg"]
 navigation:self.navigationController
 gotoBack:NO animation:YES second:3.0];
 
 selectedImage=nil;
 
 [self loadDataLevel1];
 [self loadDataLevel2];
 [self reSetStepIcon];
 });
 
 }
 else if (error.boolValue) {
 
 }
 
 else{
 }
 
 
 }
 
 }];
 [task resume];
 
 });
 
 }
 */

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        
        switch (section) {
                        
                case 0:
                        rows=[self isFromMyOrder] && self.arrData.count ? 1 : 0;
                        break;
                case 1:
                        rows=self.arrData.count ? self.arrData.count : 0;
                        break;
                case 2:
                        rows=self.arrData.count ? 1  : 0;
                        break;
                        
                case 3:
                        rows=self.arrData.count ? 1  : 0;
                        break;
                        
                default:
                        break;
        }
        
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0.0f;
        
        switch (indexPath.section) {
                        
                case 0:
                        finalHeight=[self isFromMyOrder] ? 50.0f  : 0;
                        break;
                case 1:
                        finalHeight=174.0f- ([self isFromMyOrder] ? 0 : 41.0f);
                        break;
                case 2:
                        finalHeight=273.0f;
                        break;
                case 3:
                        finalHeight=121.0f;
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
                        
                        OrderDetailViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.btnDownload.tag=indexPath.row;
                        [cell.btnDownload addTarget:self action:@selector(downloadInvoice:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                        
                        
                }
                        break;
                case 1:
                {
                        OrderDetailViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        NSMutableDictionary* dic = [arrData objectAtIndex:indexPath.row];
                        
                        //Image
                        NSURL* url=[NSURL URLWithString:[dic objectForKey:@"art_image"]];
                        
                        for (id view in cell.contentView.subviews) {
                                
                                if([view isKindOfClass:[UIActivityIndicatorView class]])
                                        [view removeFromSuperview];
                        }
                        
                        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        activityIndicator1.frame = CGRectMake(cell.img.frame.size.width/2-15,
                                                              cell.img.frame.size.height/2-15,
                                                              30,
                                                              30);
                        [activityIndicator1 startAnimating];
                        activityIndicator1.tag=indexPath.row;
                        
                        [activityIndicator1 removeFromSuperview];
                        [cell.img addSubview:activityIndicator1];
                        //                [cell.contentView insertSubview:activityIndicator1 aboveSubview:cell.img];
                        
                        
                        cell.img.backgroundColor=[UIColor whiteColor];
                        
                        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
                        
                        __weak UIImageView *weakImgPic = cell.img;
                        [cell.img setImageWithURL:url
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
                                                 completion:NULL];
                                 
                         } failure:NULL];
                        
                        cell.backgroundColor=[UIColor clearColor];
                        cell.contentView.backgroundColor=[UIColor clearColor];
                        cell.lblArtName.text=[dic objectForKey:@"art_name"];
                        cell.lblTime.text=[dic objectForKey:@"order_date"];
                        cell.lblArtSize.text=[dic objectForKey:@"art_size"];
                        cell.lblQuantity.text=[NSString stringWithFormat:@"Quantity : %@",[dic objectForKey:@"quantity"]];
                        
                        
                        NSString* formatedPrice=[Alert getFormatedNumber:[dic objectForKey:@"price"]];
                        cell.lblPrice.text=[@"$" stringByAppendingString:formatedPrice];
                        
                        cell.btnReview.tag=indexPath.row;
                        cell.btnCancel.tag=indexPath.row;
                        [cell.btnReview addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.viContainerCell.translatesAutoresizingMaskIntoConstraints=
                        cell.viContainerCancel.translatesAutoresizingMaskIntoConstraints=
                        cell.viContainerReview.translatesAutoresizingMaskIntoConstraints=YES;
                        
                        CGRect frame=cell.viContainerCell.frame;
                        frame.size.height=[self isFromMyOrder] ?  157.0f : 116.0f;
                        cell.viContainerCell.frame=frame;
                        
                        
                        CGRect cancelframe=cell.viContainerCancel.frame;
                        cancelframe.size.height=[self isFromMyOrder] ? 25.0f : 0;
                        cell.viContainerCancel.frame=cancelframe;
                        
                        CGRect reviewframe=cell.viContainerReview.frame;
                        reviewframe.size.height=[self isFromMyOrder] ? 25.0f : 0;
                        cell.viContainerReview.frame=reviewframe;
                        
                        float totalPrice=[[dic objectForKey:@"price"] floatValue]*[[dic objectForKey:@"quantity"] floatValue];
                        
                        [dic setObject:[NSNumber numberWithFloat:totalPrice] forKey:@"total"];
                        
                        
                        return cell;
                }
                        break;
                case 2:
                {
                        
                        NSDictionary* dic=[arrData objectAtIndex:0];
                        
                        OrderDetailViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.lblFName.text=[dic objectForKey:@"first_name"];
                        cell.lblLName.text=[dic objectForKey:@"last_name"];
                        cell.lblEmail.text=[dic objectForKey:@"email"];
                        cell.lblPhone.text=[dic objectForKey:@"phone_number"];
                        cell.lblAddress1.text=[dic objectForKey:@"address1"];
                        cell.lblAddress2.text=[dic objectForKey:@"address2"];
                        cell.lblCity.text=[dic objectForKey:@"city"];
                        cell.lblCountry.text=[dic objectForKey:@"country"];
                        cell.lblPostCode.text=[dic objectForKey:@"post_code"];
                        
                        
                        
                        return cell;
                        
                        
                }
                        break;
                case 3:
                {
                        
                        
                        OrderDetailViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        NSArray* arr = arrData.count ? arrData : nil;
                        
                        
                        NSNumber* sum = [arr valueForKeyPath: @"@sum.total"];
                        
                        NSString* fc1=[Alert getFormatedNumber:[sum stringValue]];
                        cell.lblSubtotal.text=[@"$" stringByAppendingString:fc1];
                        
                        
                        // calculation of grand total locally according to tax rates
                        
                        float totalAmount=0;
                        
                        for (NSDictionary* dic in arrData) {
                                
                                float actualPrice=[[dic objectForKey:@"price"] longLongValue]*[[dic objectForKey:@"quantity"] longLongValue];
                                float taxOnProduct = [[dic objectForKey:@"tax"] longLongValue];
                                
                                if(taxOnProduct == 0) {
                                        
                                        taxOnProduct = 6;
                                }
                                
                                float priceWithTax = actualPrice * taxOnProduct/100 + actualPrice;
                                totalAmount+=priceWithTax;
                                
                        }
                        
                        NSNumber* sumGrandTotal ;
                        
                        sumGrandTotal = [NSNumber numberWithFloat:totalAmount];
                        NSString* formatedPrice=[Alert getFormatedNumber:[sumGrandTotal stringValue]];
                        
                        cell.lblGrandtotal.text=[@"$" stringByAppendingString:formatedPrice];
                        
                        
                        // Set grand total title according to first index tax rate...
                        
                        NSDictionary *dicFirstIndexInfo = [arrData objectAtIndex:0];
                        
                        float tax = [[dicFirstIndexInfo objectForKey:@"tax"] longLongValue];
                        if (tax == 0) {
                                tax = 6;
                        }
                        
                        NSString *strTax = [NSString stringWithFormat:@"%.0f", tax];
                        NSString *strTaxPrefix = [strTax stringByAppendingString:@"% sales tax)"];
                        NSString *strGrandTotalTitle = [@"Order Total: (Including " stringByAppendingString:strTaxPrefix];
                        cell.lblGrandTotalTitle.text = strGrandTotalTitle;
                        
                        
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

#pragma mark UITableViewDelegate methods
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 //        NSDictionary *sectionData = [arrHeaderTitle objectAtIndex:section];
 NSString *header = @"";
 
 
 return header;
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
 //Header View
 UIView *headerView = [[UIView alloc] init];
 headerView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
 //        headerView.backgroundColor=[UIColor clearColor];
 
 //Header Title
 UILabel *myLabel = [[UILabel alloc] init];
 myLabel.frame = CGRectMake(8, 16, tableView.frame.size.width-16, 20);
 myLabel.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:15];
 myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
 myLabel.textAlignment=NSTextAlignmentCenter;
 myLabel.textColor=[Alert colorFromHexString:COLOR_CELL_HEADER];
 myLabel.backgroundColor=[UIColor clearColor];
 [headerView addSubview:myLabel];
 
 
 return headerView;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 NSInteger height=0;
 
 
 
 return height;
 }
 */




#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
        textView.backgroundColor = [UIColor whiteColor];
        textView.textColor=[UIColor blackColor];
        NSString* placeholderMessage=textView.tag==1 ? PLACEHOLDER_MESSAGE_REVIEW : PLACEHOLDER_MESSAGE_CANCELORDER;
        
        if([textView.text isEqualToString:placeholderMessage]){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = @"";
        }
        //        if(!isUpdateHeight){
        //                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
        //                                                 self.tableView.frame.origin.y,
        //                                                 self.tableView.frame.size.width,
        //                                                 self.tableView.frame.size.height - 216);
        //        }
        //
        //        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textView.tag inSection:3];
        //        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //
        //        isUpdateHeight=YES;
        return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
        //  NSLog(@"textViewShouldEndEditing:");
        
        // textView.textColor= [UIColor blackColor];
        return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
        
        NSString* placeholderMessage=textView.tag==1 ? PLACEHOLDER_MESSAGE_REVIEW : PLACEHOLDER_MESSAGE_CANCELORDER;
        
        
        //    NSLog(@"textViewDidEndEditing:");
        if(textView.text.length == 0){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = placeholderMessage;
                [textView resignFirstResponder];
        }
        //        if(isUpdateHeight){
        //
        //                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
        //                                                 self.tableView.frame.origin.y,
        //                                                 self.tableView.frame.size.width,
        //                                                 self.view.frame.size.height- self.tableView.frame.origin.y-63);
        //
        //        }
        //        isUpdateHeight=NO;
        
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
- (void)textViewDidChange:(UITextView *)textView{
        textView.textColor=[UIColor blackColor];
        //        isUpdate=YES;
        //[self validateForNativeChat];
        NSString* placeholderMessage=textView.tag==1 ? PLACEHOLDER_MESSAGE_REVIEW : PLACEHOLDER_MESSAGE_CANCELORDER;
        
        if(textView.text.length == 0){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = placeholderMessage;
                [textView resignFirstResponder];
        }
        
        
}

-(IBAction)popupClose:(id)sender{
        
        //        UIButton* button=(UIButton*)sender;
        [self removePopup];
        
        
}

-(IBAction)review:(id)sender{
        
        //        UIButton* buton=(UIButton*)sender;
        
        [self setRating:0];
        
        [self showPopView:self.viContainerReview];
        
        
        
        
}

-(IBAction)submitReview:(id)sender{
        
        [self removePopup];
        UIButton* button=(UIButton*)sender;
        
        NSDictionary* order=[arrData objectAtIndex:button.tag];
        
        NSString* review=![self.txtviReview.text isEqualToString:PLACEHOLDER_MESSAGE_REVIEW] ? self.txtviReview.text : @"";
        
        NSDate* date=[NSDate date];
        NSString* d=[[Alert getDateFormatWithString:@"yyyy-MM-dd"] stringFromDate:date];
        
        //{"rate":"4","review":"first","artistid":"144","user":"88","review_date":"2016-06-18"}
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user"];
        [dic setObject:[order objectForKey:@"user"]              forKey:@"artistid"];
        [dic setObject:[@(ratingResult) stringValue]            forKey:@"rate"];
        [dic setObject:review                                   forKey:@"review"];
        [dic setObject:d                                        forKey:@"review_date"];
        
        NSLog(@"%@",dic);
        [self rateArtWebService:[dic mutableCopy]];
        
}

-(IBAction)cancel:(id)sender{
        
        //UIButton* buton=(UIButton*)sender;
        
        [self showPopView:self.viContainerCancelOrder];
        
}

-(IBAction)choosePic:(id)sender{
        UIButton* button=(UIButton*)sender;
        
        NSIndexPath *indexPath =[Alert getIndexPathWithButton:button table:self.tableView];
        
        __weak __typeof(self)weakSelf = self;
        
        [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
                NSString* pathExt=[videoURL pathExtension];
                NSString* fileName=[@"1." stringByAppendingString:pathExt];
                weakSelf.lblSelectedFile.text=fileName;
                selectedImage=image;
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                
        }];
        
}


-(IBAction)downloadInvoice:(id)sender{
        
        //        UIButton* buton=(UIButton*)sender;
        
        NSLog(@"Download Invoice");
        PDFViewController* vc=GET_VIEW_CONTROLLER(kPDFViewController);
        vc.from=@"back";
        vc.titleString=@"Invoice";
        
        vc.allInfo=[self getInfo];
        
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
        
        
}

-(NSDictionary*)getInfo{
        
        NSDictionary* info=arrData[0];
        
        NSString* name=[NSString stringWithFormat:@"%@ %@",[info objectForKey:@"first_name"],[info objectForKey:@"last_name"]];
        
        
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        
        float totalAmount=0;
        
        
        {
                NSMutableArray* arrRecord=[[NSMutableArray alloc]init];
                
                NSArray* headers = [NSArray arrayWithObjects:@"S. No", @"Product Name", @"Quantity",@"Unit price", @"Sub Total", nil];
                
                [arrRecord addObject:headers];
                for (int i=0; i<arrData.count; i++) {
                        NSDictionary* dic=arrData[i];
                        NSMutableArray* record=[[NSMutableArray alloc]init];
                        
                        long totalPrice=[[dic objectForKey:@"price"] longLongValue]*[[dic objectForKey:@"quantity"] longLongValue];
                        
                        [record addObject:[@(i+1) stringValue]];
                        [record addObject:[dic objectForKey:@"art_name"]];
                        [record addObject:[dic objectForKey:@"quantity"]];
                        [record addObject:[@"$" stringByAppendingString:[dic objectForKey:@"price"]]];
                        [record addObject:[@"$" stringByAppendingString:[@(totalPrice) stringValue]]];
                        
                        [arrRecord addObject:record];
                        
                        totalAmount+=totalPrice;
                        
                }
                
                //                NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", @"Development", @"1", @"$1000", @"$1000", nil];
                //                NSArray* invoiceInfo2 = [NSArray arrayWithObjects:@"1", @"Development", @"1", @"$1000", @"$1000", nil];
                //                NSArray* invoiceInfo3 = [NSArray arrayWithObjects:@"1", @"Development", @"1", @"$1000", @"$1000", nil];
                //                NSArray* invoiceInfo4 = [NSArray arrayWithObjects:@"1", @"Development", @"1", @"$1000", @"$1000", nil];
                //
                //                NSArray* allInfo = [NSArray arrayWithObjects:headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4, nil];
                
                [dic setObject:arrRecord forKey:@"record"];
        }
        
        {
                NSArray* header1 = [NSArray arrayWithObjects:@"Total Amount", nil];
                NSArray* header2 = [NSArray arrayWithObjects:@"Bill Amount", nil];
                NSArray* allInfo = [NSArray arrayWithObjects:header1, header2, nil];
                
                [dic setObject:allInfo forKey:@"totalheader"];
        }
        
        
        NSString* subTotal=[@"$" stringByAppendingString:[@(totalAmount) stringValue]];
        
        
        NSNumber* grand=[NSNumber numberWithFloat:(totalAmount+totalAmount*6/100)];
        NSString* total=[@"$" stringByAppendingString:[grand stringValue]];
        
        {
                NSArray* invoiceInfo1 = [NSArray arrayWithObjects:subTotal, nil];
                NSArray* invoiceInfo2 = [NSArray arrayWithObjects: total, nil];
                NSArray* allInfo = [NSArray arrayWithObjects:invoiceInfo1, invoiceInfo2, nil];
                
                [dic setObject:allInfo forKey:@"total"];
        }
        
        
        
        
        
        
        
        
        [dic setObject:@"Eastonartgalleries."                   forKey:@"title"];
        [dic setObject:@"Art Collection Delray Beach, FL"       forKey:@"desc"];
        
        [dic setObject:@"Client Information"                    forKey:@"header1"];
        [dic setObject:name                                     forKey:@"name"];
        [dic setObject:[info objectForKey:@"phone_number"]      forKey:@"phone"];
        [dic setObject:[info objectForKey:@"email"]             forKey:@"email"];
        
        [dic setObject:@"Payment Details"                       forKey:@"header2"];
        [dic setObject:total                                    forKey:@"bill"];
        [dic setObject:[info objectForKey:@"order_date"]        forKey:@"date"];
        
        [dic setObject:@"Shipping Address"                      forKey:@"header3"];
        [dic setObject:[info objectForKey:@"country"]           forKey:@"country"];
        [dic setObject:@""                                      forKey:@"state"];
        [dic setObject:[info objectForKey:@"city"]              forKey:@"city"];
        [dic setObject:[info objectForKey:@"address1"]          forKey:@"address1"];
        [dic setObject:[info objectForKey:@"address2"]          forKey:@"address2"];
        [dic setObject:[info objectForKey:@"id"]                forKey:@"id"];
        
        
        
        
        return [dic mutableCopy];
        
}

@end
