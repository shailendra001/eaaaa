//
//  AddArtViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 16/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "AddArtViewController.h"
#import "UpdateProfileViewCell.h"
#import "UpdateProfileViewCell1.h"
#import "UpdateProfileViewCell2.h"
#import "UpdateProfileViewCell3.h"
#import "UpdateProfileViewCell4.h"
#import "AddArtViewCell1.h"
#import "AddArtViewCell2.h"
#import "AddArtViewCell3.h"
#import "AddArtViewCell4.h"
#import "PopFilterViewCell.h"
#import "ArtDetailCell4.h"
#import "AddArtTableViewCell.h"
#import "TOCropViewController.h"


#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"

#define STEP_1_ICON     @"step1.png"
#define STEP_2_ICON     @"step2.png"
#define STEP_3_ICON     @"step3.png"

#define DEFAULT_ICON    @"default_user.png"
#define DEFAULT_ICON1    @"default_user1.png"


#define ENTER_NAME_TEXT         @"* Name"
#define ENTER_EMAIL_TEXT        @"* Email"
#define SELECT_OPTION           @"* Select"
#define PLACEHOLDER_MESSAGE     @""

#define YOUTUBE_VIDEO_MESSAGE   @"Youtube Link"
#define WEBSITE_TEXT            @"http://www.example.com"
#define FACEBOOK_PAGE_TEXT      @"http://www.facebook.com/pages/fan_page"

#define CATEGORY                @"category"
#define CATEGORY_STYLE_NAME     @"stylename"
#define CATEGORY_COLOR_NAME     @"colorname"
#define CATEGORY_PRICE          @"price"
#define CATEGORY_SORT           @"sort"




@interface AddArtViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PickerViewDelegate,UITextViewDelegate,TTTAttributedLabelDelegate, TOCropViewControllerDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSMutableArray* arrData;
        NSString* baseURL;
        NSMutableArray* arrHeaderTitle;
        NSMutableArray* arrHearAbout;
        NSArray* arrCountryList;
        NSMutableArray* arrUnit;
        BOOL isUpdateHeight;
        
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        NSString* selectedCountry;
        id countrySender;
        int level;
        
        NSMutableArray* arrCategory;
        NSMutableArray* arrStyle;
        NSMutableArray* arrColor;
        NSMutableDictionary* addArt;
        
        NSMutableArray* arrSortOrder;
        UIImage* selectedImage;
        
        NSMutableArray* arrMultipleArt;
        NSMutableArray* arrYoutubeVideo;
        NSDictionary* selectedDic;
        
        
        NSMutableArray* arrAvailableForBid;
        BOOL isAvailableForBid;
        BOOL isDate;
        BOOL isTime;
        
        // Chandra
        BOOL isArtImage;
        NSIndexPath *indexPathForMultipleArt;
}

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation AddArtViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";
static NSString *CellIdentifier5 = @"Cell5";
static NSString *CellIdentifier6 = @"Cell6";
static NSString *CellIdentifier7 = @"Cell7";
static NSString *CellIdentifier8 = @"Cell8";
static NSString *CellIdentifier9 = @"Cell9";
static NSString *CellIdentifier10 = @"Cell10";
static NSString *CellIdentifier11 = @"Cell11";
static NSString *CellIdentifier12 = @"Cell12";



#pragma mark - View controller life cicle


- (void)viewDidLoad {
        
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self loadDataLevel1];
        
        [self loadDataLevel3];
        
        [self reSetStepIcon];
        
        [self countryList];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        if(YES/*![Alert getFromLocal:CATEGORY]*/){
                
                [self filterWebService];
        }
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
}

-(void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        [self config];
        
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - THSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
        
        return self.viewTitle ? self.viewTitle : self.title;
}

#pragma mark - Custom Methods

-(void)resizeTable {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints=YES;
        if([self isEditArt]){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height- self.tableView.frame.origin.y+1);
                
        }
}

-(BOOL)isEditArt {
        
        BOOL result = NO;
        if([self.fromVC isEqualToString:kManageArtViewController] && self.response)
                result=YES;
        return result;
}

-(void)config{
        
        if([self isEditArt]) [self resizeTable];
        
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        //        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        
}

-(void)loadDataLevel1{
        
        level=1;
        //Header
        {
                arrHeaderTitle=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle addObject:@"ENTER YOUR ART DETAILS"];
                //                [arrHeaderTitle addObject:@""];
                //                [arrHeaderTitle addObject:@""];
                //                [arrHeaderTitle addObject:@""];
                
                
        }
        //init data
        {
                arrData=[[NSMutableArray alloc]init];
                
                //Fill art detail
                NSDictionary* artSize=[self isEditArt] ? ((NSArray*)[self.response objectForKey:@"artsizes"])[0]:nil;
                
                NSString* name          =[self isEditArt] ? [self.response objectForKey:@"art_name"] : @"";
                NSString* price         =[self isEditArt] ? [self.response objectForKey:@"art_price"]: @"";
                NSString* quantity      =[self isEditArt] ? [self.response objectForKey:@"art_quantity"]: @"";
                NSString* width         =[self isEditArt] ? [artSize objectForKey:@"width"]: @"";
                NSString* height        =[self isEditArt] ? [artSize objectForKey:@"height"]: @"";
                NSString* depth         =[self isEditArt] ? [artSize objectForKey:@"depth"]: @"";
                NSString* unity         =[self isEditArt] ? [artSize objectForKey:@"unit"]: @"";
                NSString* aboutArt      =[self isEditArt] ? [self.response objectForKey:@"description"]: @"";
                NSString* keywords      =[self isEditArt] ? [self.response objectForKey:@"keyword"]: @"";
                
                NSString* imageUrl      =[self isEditArt] ? [self.response objectForKey:@"art_image"]: @"";
                
                //////
                
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"Art Name"                                      forKey:@"title"];
                [dic setObject:@"Art Name"                                      forKey:@"msg"];
                [dic setObject:[self isEditArt] ? name : @""                    forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Art Price"                                     forKey:@"title"];
                [dic setObject:@"Art Price"                                     forKey:@"msg"];
                [dic setObject:[self isEditArt] ? price : @""                   forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Quantity"                                      forKey:@"title"];
                [dic setObject:@"Quantity"                                      forKey:@"msg"];
                [dic setObject:[self isEditArt] ? quantity : @""                forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Width"                                         forKey:@"title"];
                [dic setObject:@"Width"                                         forKey:@"msg"];
                [dic setObject:[self isEditArt] ? width : @""                   forKey:@"value"];
                [dic setObject:@"globe.png"                                     forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Height"                                        forKey:@"title"];
                [dic setObject:@"Height"                                        forKey:@"msg"];
                [dic setObject:[self isEditArt] ? height : @""                  forKey:@"value"];
                [dic setObject:@"biography.png"                                 forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Depth"                                         forKey:@"title"];
                [dic setObject:@"Depth"                                         forKey:@"msg"];
                [dic setObject:[self isEditArt] ? depth : @""                   forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Unit"                                          forKey:@"title"];
                [dic setObject:@"Unit"                                          forKey:@"msg"];
                [dic setObject:[self isEditArt] ? unity : SELECT_OPTION         forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"About Art"                                     forKey:@"title"];
                [dic setObject:@""                                              forKey:@"msg"];
                [dic setObject:[self isEditArt] ? aboutArt: PLACEHOLDER_MESSAGE forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Keywords"                                     forKey:@"title"];
                [dic setObject:@""                                              forKey:@"msg"];
                [dic setObject:[self isEditArt] ? keywords: PLACEHOLDER_MESSAGE forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Choose Art image"                              forKey:@"title"];
                [dic setObject:@""                                              forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:imageUrl                                         forKey:@"url"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                
                
        }
        
        //Selling in currency
        {
                arrUnit=[[NSMutableArray alloc]init];
                
                [arrUnit addObject:@"meter"];
                [arrUnit addObject:@"cm"];
                [arrUnit addObject:@"inch"];
                
                
        }
        
        //Multiple art
        {
                arrMultipleArt=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@""                                              forKey:@"path"];
                [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
                [arrMultipleArt addObject:dic];
        }
        
        //Youtube Video
        {
                arrYoutubeVideo=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:YOUTUBE_VIDEO_MESSAGE                            forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrYoutubeVideo addObject:dic];
        }
        
}

-(void)loadDataLevel2 {
        
        NSMutableDictionary* dic=[Alert getFromLocal:CATEGORY];
        addArt=[NSMutableDictionary dictionary];
        
        for (NSString* key in dic.allKeys) {
                
                if([key isEqualToString:CATEGORY] || [key isEqualToString:CATEGORY_COLOR_NAME] || [key isEqualToString:CATEGORY_STYLE_NAME])
                        [addArt setObject:[dic objectForKey:key] forKey:key];
        }
        
        arrCategory=nil;
        arrColor=nil;
        arrStyle=nil;
        if(!arrSortOrder) arrSortOrder=[[NSMutableArray alloc]init];
        
        [arrSortOrder addObject:CATEGORY];
        [arrSortOrder addObject:CATEGORY_COLOR_NAME];
        [arrSortOrder addObject:CATEGORY_STYLE_NAME];
        [arrSortOrder addObject:@""];
        [arrSortOrder addObject:@""];
        [arrSortOrder addObject:@""];
        
        //Fill art detail
        NSArray* cat=[self isEditArt] ? [self.response objectForKey:@"category_id"] : nil;
        NSArray* col=[self isEditArt] ? [self.response objectForKey:@"artcolor"] : nil;
        NSArray* sty=[self isEditArt] ? [self.response objectForKey:@"artsubject"] : nil;
        
        if(cat && cat.count){
                arrCategory=[[NSMutableArray alloc]init];
                for (NSString* value in cat) {
                        [arrCategory addObject:value];
                }
        }
        
        if(col && col.count){
                arrColor=[[NSMutableArray alloc]init];
                for (NSString* value in col) {
                        [arrColor addObject:value];
                }
        }
        
        if(sty && sty.count){
                arrStyle=[[NSMutableArray alloc]init];
                for (NSString* value in sty) {
                        [arrStyle addObject:value];
                }
        }
        
        ///
        
        
        [self.tableView reloadData];
}

-(void)loadDataLevel3{
        
        //        level=3;
        //init data
        {
                arrAvailableForBid = [[NSMutableArray alloc]init];
                
                
                NSArray* arrRes=[self.response objectForKey:@"auction_details"];
                NSDictionary* dicResp=arrRes.count ? [arrRes firstObject]: nil;
                isAvailableForBid=[self isEditArt] && dicResp ? YES : NO;
                
                //Fill art detail
                NSString* minPrice      =[self isEditArt] ? [dicResp objectForKey:@"bid_min_price"] : @"";
                NSString* maxPrice      =[self isEditArt] ? [dicResp objectForKey:@"bid_max_price"]: @"";
                NSString* startDate     =[self isEditArt] ? [dicResp objectForKey:@"bid_start_date"]: @"";
                NSString* endDate       =[self isEditArt] ? [dicResp objectForKey:@"bid_end_date"]: @"";
                
                minPrice=minPrice ? minPrice : @"";
                maxPrice=maxPrice ? maxPrice : @"";
                startDate=startDate ? startDate : @"";
                endDate=endDate ? endDate : @"";
                
                
                //////
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"Minimum Bidding Price $"                       forKey:@"title"];
                [dic setObject:@"Minimum Bidding Price"                         forKey:@"msg"];
                [dic setObject:[self isEditArt] ? minPrice : @""                forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrAvailableForBid addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Maximum Bidding Price $"                       forKey:@"title"];
                [dic setObject:@"Maximum Bidding Price"                         forKey:@"msg"];
                [dic setObject:[self isEditArt] ? maxPrice : @""                forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrAvailableForBid addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Bidding Start Date"                            forKey:@"title"];
                [dic setObject:@"Bidding Start Date"                            forKey:@"msg"];
                [dic setObject:[self isEditArt] ? startDate : @""               forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrAvailableForBid addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Bidding End Date"                              forKey:@"title"];
                [dic setObject:@"Bidding End Date"                              forKey:@"msg"];
                [dic setObject:[self isEditArt] ? endDate : @""                 forKey:@"value"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrAvailableForBid addObject:dic];
                
                
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

-(void)setNav{
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}

-(void)reSetStepIcon{
        
        self.imgStep.image=[UIImage imageNamed:(level==1 ? STEP_1_ICON : (level==2 ? STEP_2_ICON : STEP_3_ICON))];
}

-(void)cellRegister{
        
        [self.tableView registerClass:[UpdateProfileViewCell class]     forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[UpdateProfileViewCell1 class]    forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[AddArtViewCell1 class]           forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[AddArtViewCell2 class]           forCellReuseIdentifier:CellIdentifier4];
        [self.tableView registerClass:[UpdateProfileViewCell4 class]    forCellReuseIdentifier:CellIdentifier5];
        [self.tableView registerClass:[UpdateProfileViewCell2 class]    forCellReuseIdentifier:CellIdentifier6];
        [self.tableView registerClass:[PopFilterViewCell class]         forCellReuseIdentifier:CellIdentifier7];
        [self.tableView registerClass:[UpdateProfileViewCell3 class]    forCellReuseIdentifier:CellIdentifier8];
        [self.tableView registerClass:[AddArtViewCell3 class]           forCellReuseIdentifier:CellIdentifier9];
        [self.tableView registerClass:[AddArtViewCell4 class]           forCellReuseIdentifier:CellIdentifier10];
        [self.tableView registerClass:[ArtDetailCell4 class]            forCellReuseIdentifier:CellIdentifier11];
        [self.tableView registerClass:[AddArtTableViewCell class]       forCellReuseIdentifier:CellIdentifier12];
        
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"UpdateProfileViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"UpdateProfileViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"AddArtViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        UINib *contantsCellNib4= [UINib nibWithNibName:@"AddArtViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        UINib *contantsCellNib5= [UINib nibWithNibName:@"UpdateProfileViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib5 forCellReuseIdentifier:CellIdentifier5];
        UINib *contantsCellNib6 = [UINib nibWithNibName:@"UpdateProfileViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib6 forCellReuseIdentifier:CellIdentifier6];
        UINib *contantsCellNib7 = [UINib nibWithNibName:@"PopFilterViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib7 forCellReuseIdentifier:CellIdentifier7];
        UINib *contantsCellNib8 = [UINib nibWithNibName:@"UpdateProfileViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib8 forCellReuseIdentifier:CellIdentifier8];
        UINib *contantsCellNib9= [UINib nibWithNibName:@"AddArtViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib9 forCellReuseIdentifier:CellIdentifier9];
        UINib *contantsCellNib10= [UINib nibWithNibName:@"AddArtViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib10 forCellReuseIdentifier:CellIdentifier10];
        UINib *contantsCellNib12= [UINib nibWithNibName:NSStringFromClass([AddArtTableViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib12 forCellReuseIdentifier:CellIdentifier12];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemRemoveFromCollectionView:) name:@"didSelectItemRemoveFromCollectionView" object:nil];
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
        //[self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
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

-(void)createDatePicker:(BOOL)isList items:(NSArray*)list sender:(id)sender datePickerMode:(UIDatePickerMode) datePickerMode {
        
        cDatePicker=[[CustomDatePickerViewController alloc]initWithNibName:kCustomDatePickerViewController bundle:nil];
        
        cDatePicker.delegate=self;
        cDatePicker.isCustomList=isList;
        cDatePicker.arrItems= isList ? list :nil;
        cDatePicker.sender=sender;
        cDatePicker.datePickerMode=datePickerMode;
        cDatePicker.setDate=[NSDate date];
        [cDatePicker setPickerList];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        
        fullScreen=[[UIView alloc]initWithFrame:screenRect];
        fullScreen.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        //        CGRect fr=cDatePicker.view.frame;
        //        fr.size=self.view.bounds.size;
        //        cDatePicker.view.frame=fr;
        
        [fullScreen addSubview:cDatePicker.view];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:fullScreen];
        
        //    [self.view addSubview:cDatePicker.view];
}

-(void)removeDatePicker{
        [fullScreen removeFromSuperview];
        [cDatePicker.view removeFromSuperview];
        fullScreen=nil;
        cDatePicker=nil;
        
        
}

-(void)countryList{
        //    arrCountryList=[[NSArray alloc]init];
        
        NSDictionary* country=[Alert getCountryFromServerData];
        if(country){
                
                arrCountryList=[[country allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        
        
}

-(NSArray*)getValidUrl:(NSArray*)arr {
        
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        
        for (NSString* url in arr) {
                
                NSString* fileName=[url lastPathComponent];
                //video
                NSArray*arr=[fileName componentsSeparatedByString:@"="];
                
                if(arr.count==2)
                        [arrResult addObject:fileName];
        }
        
        return  arrResult.count ? arrResult : nil;
        
}

-(NSArray*)getValidImages:(NSArray*)arr {
        
        NSMutableArray* arrResult=[[NSMutableArray alloc]init];
        
        for (id url in arr) {
                
                if(!IS_EMPTY(url))      [arrResult addObject:url];
        }
        
        return  arrResult.count ? arrResult : nil;
        
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

#pragma mark - NSNotification to select table cell

- (void) didSelectItemRemoveFromCollectionView:(NSNotification *)notification{
        NSDictionary *cellData = [notification object];
        if (cellData)
        {
                selectedDic= cellData;
                
                if(cellData && [[cellData objectForKey:@"type"]isEqualToString:@"2"]){
                        //video
                        
                        NSLog(@"%@",[cellData objectForKey:@"cell"]);
                        
                        NSMutableArray* arrVideos=(NSMutableArray*)[self.response objectForKey:@"art_video"];
                        
                        NSIndexPath* ip=[cellData objectForKey:@"indexpath"];
                        
                        //{"art_id":"138","video" : ["https://www.youtube.com/watch?v=yAoLSRbwxL8","https://www.youtube.com/watch?v=yAoLSRbwxL8"]}
                        
                        
                        NSMutableDictionary* videoDic=[NSMutableDictionary dictionary];
                        [videoDic setObject:self.artID                          forKey:@"art_id"];
                        [videoDic setObject:@[[arrVideos objectAtIndex:ip.row]] forKey:@"videos"];
                        
                        [self removeVideoWebService:[videoDic mutableCopy]];
                        
                        
                        //[arrVideos removeObjectAtIndex:ip.row];
                        //[Alert reloadSection:2 table:self.tableView];
                }
                else{
                        //Image
                        
                        NSMutableArray* arrImages=(NSMutableArray*)[self.response objectForKey:@"art_more_image"];
                        NSIndexPath* ip=[cellData objectForKey:@"indexpath"];
                        
                        //{"art_id":"138","images" : ["http://www.eastonartgalleries.com/artwork/350_350/IMG_4323.JPG", "http://www.eastonartgalleries.com/artwork/350_350/download5.jpg"]}
                        
                        NSMutableDictionary* imageDic=[NSMutableDictionary dictionary];
                        [imageDic setObject:self.artID                          forKey:@"art_id"];
                        [imageDic setObject:@[[arrImages objectAtIndex:ip.row]] forKey:@"images"];
                        
                        [self removeImageWebService:[imageDic mutableCopy]];
                        
                        
                        
                        //[arrImages removeObjectAtIndex:ip.row];
                        //[Alert reloadSection:1 table:self.tableView];
                        
                        
                }
                
                
                NSLog(@"%@",cellData);
                
                
                
        }
}

- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:
                                 NSGregorianCalendar];
        
        unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit
        |  NSDayCalendarUnit;
        NSDateComponents *dateComponents = [gregorian components:unitFlagsDate
                                                        fromDate:date];
        unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit
        |  NSSecondCalendarUnit;
        NSDateComponents *timeComponents = [gregorian components:unitFlagsTime
                                                        fromDate:time];
        
        [dateComponents setSecond:[timeComponents second]];
        [dateComponents setHour:[timeComponents hour]];
        [dateComponents setMinute:[timeComponents minute]];
        
        NSDate *combDate = [gregorian dateFromComponents:dateComponents];
        
        return combDate;
}

#pragma mark - DatePicker Custom Delegate methods

-(void)selectDateFromDatePicker:(NSDate *)date sender:(id)sender{
        [self removeDatePicker];
        NSLog(@"Selected Date->%@",date);
        
        
        //        lblAge.text=[NSString stringWithFormat:@"+%d",[Alert calculateAge:date]];
        
        
        //        txtDOB.text=[Alert getDateWithString:[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date]
        //                                   getFormat:GET_FORMAT_TYPE
        //                                   setFormat:SET_FORMAT_TYPE1];
        
        
        
        NSString* dateStringFromDate=[[Alert getDateFormatWithString:DATE_FORMAT_UTC] stringFromDate:date];
        NSDate* dateFromDateString=[[Alert getDateFormatFromServerWithString:DATE_FORMAT_UTC] dateFromString:dateStringFromDate];
        
        
        if(isDate)
                selectedDate=dateFromDateString;
        
        
        
        
        UITextField*textField=(UITextField*)sender;
        
        //        NSIndexPath *indexPath =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        switch (level) {
                case 3:
                {
                        switch (textField.tag) {
                                case 2:
                                {
                                        if(isDate){
                                                isTime=YES;
                                                isDate=NO;
                                                
                                                [self createDatePicker:NO items:nil sender:sender datePickerMode:(UIDatePickerModeTime)];
                                        }
                                        else{
                                                
                                                NSDate* finalDate=[self combineDate:selectedDate withTime:dateFromDateString];
                                                NSString* dateString=[[Alert getDateFormatFromServerWithString:DATE_FORMAT_UTC] stringFromDate:finalDate];
                                                NSMutableDictionary* dic=[arrAvailableForBid objectAtIndex:textField.tag];
                                                [dic setObject:dateString forKey:@"value"];
                                                isDate=NO;
                                                isTime=NO;
                                                selectedDate=nil;
                                        }
                                        
                                        
                                        
                                        
                                }
                                        break;
                                case 3:
                                {
                                        if(isDate){
                                                isTime=YES;
                                                isDate=NO;
                                                
                                                [self createDatePicker:NO items:nil sender:textField datePickerMode:(UIDatePickerModeTime)];
                                        }
                                        else{
                                                
                                                NSDate* finalDate=[self combineDate:selectedDate withTime:dateFromDateString];
                                                NSString* dateString=[[Alert getDateFormatFromServerWithString:DATE_FORMAT_UTC] stringFromDate:finalDate];
                                                NSMutableDictionary* dic=[arrAvailableForBid objectAtIndex:textField.tag];
                                                [dic setObject:dateString forKey:@"value"];
                                                
                                                isDate=NO;
                                                isTime=NO;
                                                selectedDate=nil;
                                        }
                                        
                                        
                                        
                                        
                                }
                                        
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                }
                        break;
                        
                default:
                        break;
        }
        
        
        
        [Alert reloadSection:5 table:self.tableView];
        //[txtCountry becomeFirstResponder];
}

-(void)cancelDateFromDatePicker:(id)sender{
        isDate=NO;
        isTime=NO;
        selectedDate=nil;
        [self removeDatePicker];
        // [txtCountry becomeFirstResponder];
}

#pragma mark - Custom List Item Picker Delegate Methods

-(void)selectItemFromList:(NSString *)item sender:(id)sender{
        
        NSLog(@"Selected item->%@",item);
        UIButton* button=(UIButton*)sender;
        selectedCountry=item;
        
        [self removeDatePicker];
        
        
        
        //        NSLog(@"Country Key->[%@]",[Alert getSelectedCountryKeyWithValue:selectedCountry]);
        //        NSLog(@"Country Value->[%@]",[Alert getSelectedCountryValueWithKey:[Alert getSelectedCountryKeyWithValue:selectedCountry]]);
        
        
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        
        switch (indexPath.section) {
                case 0:
                {
                        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag];
                        
                        [dic setObject:selectedCountry forKey:@"value"];
                }
                        break;
                case 1:
                {
                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
                        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag+row];
                        
                        [dic setObject:selectedCountry forKey:@"value"];
                        
                }
                        break;
                        
                default:
                        break;
        }
        
        
        //countrySender=nil;
        
        
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
}

-(void)cancelItemFromCustomList:(id)sender{
        [self removeDatePicker];
        countrySender=nil;
}

#pragma mark -Call WebService

-(void)filterWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_CategorySearch);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:@"catSearch" forKey:@"page"];//{"page":"catSearch"}
                
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                
                NSMutableURLRequest *theRequest =[Alert getRequesteWithPostString:postString
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
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                                        
                                        NSDictionary*category = (NSDictionary*)[result valueForKey:@"data"];
                                        category = [Alert removedNullsWithString:@"" obj:category];
                                        
                                        /*BOOL isSave=*/[Alert saveToLocal:category key:CATEGORY];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self loadDataLevel2];
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

-(void)addArtWebService:(NSDictionary*)dic images:(NSArray*)images{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl,[self isEditArt]? kURL_UpdateArt: kURL_AddArt);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                //                if(images.count)
                //                        postString=[@"data=" stringByAppendingString:postString];
                
                
                NSLog(@" tempURL :%@---",urlString);
                
                /*
                 NSMutableURLRequest *theRequest =[Alert getRequesteWithPostString:postString
                 urlString:urlString
                 methodType:REQUEST_METHOD_TYPE_POST
                 images:images];
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
                 options:NSJSONReadingMutableContainers
                 error:nil];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                 [[SharedClass sharedObject] hudeHide];
                 
                 });
                 
                 if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                 
                 }
                 
                 */
                
                
                NSMutableURLRequest *theRequest =[Alert getOnlyRequesteWithUrlString:postString
                                                                           urlString:urlString
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
                                                               gotoBack:YES animation:YES second:3.0];
                                                
                                                selectedImage=nil;
                                                isAvailableForBid=NO;
                                                [self loadDataLevel1];
                                                [self loadDataLevel2];
                                                [self loadDataLevel3];
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

-(void)removeImageWebService:(NSDictionary*)dic{
        
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_RemoveImage);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
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
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:2.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                        //Image remove
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                NSMutableArray* arrImages=(NSMutableArray*)[self.response objectForKey:@"art_more_image"];
                                                NSIndexPath* ip=[selectedDic objectForKey:@"indexpath"];
                                                [arrImages removeObjectAtIndex:ip.row];
                                                
                                                [Alert reloadSection:1 table:self.tableView];
                                                
                                                selectedDic=nil;
                                                
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

-(void)removeVideoWebService:(NSDictionary*)dic{
        
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_RemoveVideo);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
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
                        
                        NSDictionary * result =[NSJSONSerialization JSONObjectWithData:returnData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
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
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:2.0];
                                });
                                
                                if (success.boolValue) {
                                        
                                        //Image remove
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                NSMutableArray* arrVideos=(NSMutableArray*)[self.response objectForKey:@"art_video"];
                                                
                                                NSIndexPath* ip=[selectedDic objectForKey:@"indexpath"];
                                                [arrVideos removeObjectAtIndex:ip.row];
                                                
                                                [Alert reloadSection:2 table:self.tableView];
                                                
                                                selectedDic=nil;
                                                
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        
        NSInteger section=0;
        switch (level) {
                case 1:
                        section=1;
                        break;
                case 2:
                        section=arrSortOrder.count;
                        break;
                case 3:
                        section=7;
                        break;
                default:
                        break;
        }
        return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
        
        
        NSInteger rows=0;
        switch (level) {
                case 1:
                        rows=8;
                        break;
                case 2:
                        switch (section) {
                                case 0:
                                case 1:
                                case 2:
                                {
                                        NSArray* arr=[addArt objectForKey:[arrSortOrder objectAtIndex:section]];
                                        
                                        rows= arr.count;
                                }
                                        break;
                                case 3:
                                        rows=1;
                                        break;
                                case 4:
                                        rows=1;
                                        break;
                                case 5:
                                        rows=1;
                                        break;
                                default:
                                        break;
                        }
                        break;
                case 3:
                        switch (section) {
                                case 0:
                                        rows=1;
                                        break;
                                case 1:
                                {
                                        NSArray* arrImages=[self.response objectForKey:@"art_more_image"];
                                        arrImages=[self getValidImages:arrImages];
                                        rows=arrImages.count ? 1 :0;
                                }
                                        break;
                                case 2:
                                {
                                        NSArray* arrVideos=[self.response objectForKey:@"art_video"];
                                        arrVideos=[self getValidUrl:arrVideos];
                                        rows=arrVideos.count ? 1 :0;
                                }
                                        break;
                                case 3:
                                        rows=arrMultipleArt.count;
                                        break;
                                case 4:
                                        rows=arrYoutubeVideo.count;
                                        break;
                                case 5:
                                        rows = 4; //isAvailableForBid ? 4 : 0;
                                        break;
                                case 6:
                                        rows=1;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                default:
                        break;
        }
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        NSInteger height=0;
        switch (level) {
                case 1:
                        height=44.0f;
                        break;
                case 2:
                        switch (indexPath.section) {
                                case 0:
                                case 1:
                                case 2:
                                        height=30.0f;
                                        break;
                                        
                                case 3:
                                        height=131.0f;
                                        break;
                                case 4:
                                        height=131.0f;
                                        break;
                                case 5:
                                        height=44.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        switch (indexPath.section) {
                                case 0:
                                        height=64.0f;
                                        break;
                                case 1:
                                {
                                        NSArray* arrImages=[self.response objectForKey:@"art_more_image"];
                                        arrImages=[self getValidImages:arrImages];
                                        height=arrImages.count ? 88.0f :0;
                                }
                                        
                                        break;
                                case 2:
                                {
                                        NSArray* arrVideos=[self.response objectForKey:@"art_video"];
                                        arrVideos=[self getValidUrl:arrVideos];
                                        height=arrVideos.count ? 88.0f :0;
                                }
                                        break;
                                        
                                case 3:
                                        height=40;
                                        break;
                                case 4:
                                        height=40;
                                        break;
                                case 5:
                                        height= 44.0; //isAvailableForBid ? 44.0f : 0;
                                        break;
                                case 6:
                                        height=44.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                        break;
                default:
                        break;
        }
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        switch (level) {
                case 1:
                        switch (indexPath.row) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                {
                                        NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                                        
                                        UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        cell.img.hidden=YES;
                                        cell.lblTitle.text = [item objectForKey:@"title"];
                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                        
                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        
                                        cell.lblTitle.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        cell.txtName.text = [item objectForKey:@"value"];
                                        cell.txtName.delegate=self;
                                        [Alert attributedString:cell.txtName
                                                            msg:[item objectForKey:@"msg"]
                                                          color:[item objectForKey:@"color"]];
                                        cell.txtName.tag=indexPath.row;
                                        cell.txtName.textColor = [UIColor blackColor];
                                        cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                                        
                                        //                                cell.txtName.keyboardType=indexPath.row==0 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
                                        [cell.txtName addTarget:self
                                                         action:@selector(textFieldDidChange:)
                                               forControlEvents:UIControlEventEditingChanged];
                                        cell.txtName.tintColor=[UIColor blackColor];
                                        
                                        cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                                        
                                        //Add ' * '
                                        NSString* text=[item objectForKey:@"title"];
                                        NSString* readMore=@" *";
                                        text = [text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 6:
                                {
                                        
                                        NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                                        UpdateProfileViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        cell.img.hidden=YES;
                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                        
                                        cell.lblName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        
                                        
                                        cell.lblName.text=[item objectForKey:@"value"];
                                        
                                        cell.lblName.tag        =
                                        cell.btnSelect.tag      =indexPath.row;
                                        
                                        
                                        [cell.btnSelect addTarget:self
                                                           action:@selector(selectUnit:)
                                                 forControlEvents:UIControlEventTouchUpInside];
                                        
                                        //Add ' * '
                                        NSString* text=[item objectForKey:@"title"];
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 7:
                                {
                                        AddArtViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        cell.lblTitle.text=@"NEXT";
                                        cell.btnClick.tag=indexPath.row;
                                        [cell.btnClick addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
                                        return cell;
                                }
                                        
                                        break;
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (indexPath.section) {
                                case 0:
                                case 1:
                                case 2:
                                {
                                        PopFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier7 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        NSString* title=[arrSortOrder objectAtIndex:indexPath.section];
                                        
                                        NSMutableDictionary* dic=[[addArt objectForKey:title] objectAtIndex:indexPath.row];
                                        
                                        
                                        NSString* icon;
                                        
                                        if([title isEqualToString:CATEGORY]){
                                                
                                                icon=[arrCategory containsObject:[dic objectForKey:@"id"]] ? SELECT_TICK : UNSELECT_TICK;
                                                
                                        }
                                        else if([title isEqualToString:CATEGORY_STYLE_NAME]){
                                                
                                                icon=[arrStyle containsObject:[dic objectForKey:@"id"]] ? SELECT_TICK : UNSELECT_TICK;
                                                
                                        }
                                        else if([title isEqualToString:CATEGORY_COLOR_NAME]){
                                                
                                                icon=[arrColor containsObject:[dic objectForKey:@"id"]] ? SELECT_TICK : UNSELECT_TICK;
                                                
                                        }
                                        
                                        cell.img.image=[UIImage imageNamed:icon];
                                        
                                        
                                        
                                        NSString* name;
                                        
                                        if([title isEqualToString:CATEGORY])                    name=@"category_name";
                                        else if([title isEqualToString:CATEGORY_STYLE_NAME])    name=@"style_name";
                                        else if([title isEqualToString:CATEGORY_COLOR_NAME])    name=@"color_name";
                                        else                                                    name=@"value";
                                        
                                        cell.lblName.text=[dic objectForKey:name];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 3:
                                {
                                        UpdateProfileViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        cell.img.hidden=YES;
                                        
                                        
                                        //                                        NSInteger rows=[tableView numberOfRowsInSection:0];
                                        NSInteger rows = 7;
                                        
                                        NSDictionary *item = [arrData objectAtIndex:rows];
                                        
                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        
                                        
                                        cell.vitxtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                                        cell.vitxtName.text=[item objectForKey:@"value"];
                                        cell.vitxtName.tag=1000;
                                        cell.vitxtName.delegate=self;
                                        
                                        //Add ' * '
                                        NSInteger l1=cell.lblTitle.text.length;
                                        NSString* text2=@" *";
                                        cell.lblTitle.text=[cell.lblTitle.text stringByAppendingString:text2];
                                        NSInteger l2=text2.length;
                                        
                                        UIFont *font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        NSDictionary *fontDic = [NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
                                        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblTitle.text attributes:fontDic];
                                        
                                        [string addAttribute:NSForegroundColorAttributeName value:cell.lblTitle.textColor range:NSMakeRange(0,l1)];
                                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(l1,l2)];
                                        cell.lblTitle.attributedText = string;
                                        
                                        
                                        return cell;
                                        
                                }
                                        
                                        break;
                                        
                                case 4:
                                {
                                        UpdateProfileViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        cell.img.hidden=YES;
                                        
                                        
                                        //                                        NSInteger rows=[tableView numberOfRowsInSection:0];
                                        NSInteger rows = 8;
                                        
                                        NSDictionary *item = [arrData objectAtIndex:rows];
                                        
                                        cell.lblTitle.text=  [item objectForKey:@"title"];
                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        
                                        
                                        cell.vitxtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                                        
                                        cell.vitxtName.text=[item objectForKey:@"value"];
                                        cell.vitxtName.tag=1001;
                                        cell.vitxtName.delegate=self;
                                        
                                        //Add ' * '
                                        NSInteger l1=cell.lblTitle.text.length;
                                        NSString* text2=@" *";
                                        cell.lblTitle.text=[cell.lblTitle.text stringByAppendingString:text2];
                                        NSInteger l2=text2.length;
                                        
                                        UIFont *font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        NSDictionary *fontDic = [NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
                                        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblTitle.text attributes:fontDic];
                                        
                                        [string addAttribute:NSForegroundColorAttributeName value:cell.lblTitle.textColor range:NSMakeRange(0,l1)];
                                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(l1,l2)];
                                        cell.lblTitle.attributedText = string;
                                        
                                        
                                        return cell;
                                        
                                }
                                        
                                        break;
                                        
                                case 5:
                                {
                                        AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        cell.lblLeft.text=@"BACK";
                                        cell.lblRight.text=@"NEXT";
                                        cell.btnLeft.tag=indexPath.row;
                                        cell.btnRight.tag=indexPath.row;
                                        [cell.btnLeft addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnRight addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
                                        return cell;
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        switch (indexPath.section) {
                                case 0:
                                {
                                        UpdateProfileViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier8 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        cell.isRectangular=YES;
                                        NSInteger rows=9;
                                        
                                        NSDictionary *item = [arrData objectAtIndex:rows];
                                        
                                        NSURL* url=[self isEditArt] ? [NSURL URLWithString:[item objectForKey:@"url"]] : nil;
                                        
                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                        //                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        cell.img.backgroundColor=[UIColor grayColor];
                                        
                                        UIImage* imgPlaceHolder=[UIImage imageNamed:cell.isRectangular ? DEFAULT_ICON1 : DEFAULT_ICON];
                                        cell.img.image=selectedImage ? selectedImage : nil;
                                        
                                        __weak UIImageView *weakImgPic = cell.img;
                                        [cell.img setImageWithURL:selectedImage ? nil: url
                                                 placeholderImage:cell.img.image==nil ? imgPlaceHolder : cell.img.image
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                                         {
                                                 
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
                                        
                                        
                                        cell.btnSelect.tag=indexPath.row;
                                        [cell.btnSelect addTarget:self action:@selector(choosePic:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        
                                        //Add ' * '
                                        NSInteger l1=cell.lblTitle.text.length;
                                        NSString* text2=@" *";
                                        cell.lblTitle.text=[cell.lblTitle.text stringByAppendingString:text2];
                                        NSInteger l2=text2.length;
                                        
                                        UIFont *font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                        NSDictionary *fontDic = [NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
                                        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblTitle.text attributes:fontDic];
                                        
                                        [string addAttribute:NSForegroundColorAttributeName value:cell.lblTitle.textColor range:NSMakeRange(0,l1)];
                                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(l1,l2)];
                                        cell.lblTitle.attributedText = string;
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 1:
                                {
                                        ArtDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier11 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                                        [dic setObject:@"1" forKey:@"type"];
                                        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"edit"];
                                        [dic setObject:[self.response objectForKey:@"base_url"] forKey:@"base_url"];
                                        
                                        [cell setCollectionInfo:dic];
                                        NSArray* arrImages=[self.response objectForKey:@"art_more_image"];
                                        
                                        arrImages=[self getValidImages:arrImages];
                                        [cell setCollectionData:[arrImages mutableCopy]];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                case 2:
                                {
                                        ArtDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier11 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                                        [dic setObject:@"2" forKey:@"type"];
                                        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"edit"];
                                        
                                        
                                        [cell setCollectionInfo:dic];
                                        NSArray* arrVideos=[self.response objectForKey:@"art_video"];
                                        arrVideos=[self getValidUrl:arrVideos];
                                        [cell setCollectionData:[arrVideos mutableCopy]];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                case 3:
                                {
                                        AddArtViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier9 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        NSDictionary* dic=[arrMultipleArt objectAtIndex:indexPath.row];
                                        
                                        NSString* path=[dic objectForKey:@"path"];
                                        
                                        cell.lblFileName.text=IS_EMPTY(path) ? @"No file Chosen" : path;
                                        cell.lblAddMore.text=(indexPath.row==0) ? @"ADD MORE" : @"REMOVE";
                                        
                                        cell.btnChooseFile.tag=indexPath.row;
                                        cell.btnAddMore.tag=indexPath.row;
                                        [cell.btnChooseFile addTarget:self action:@selector(chooseFile:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnAddMore addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        return cell;
                                }
                                        break;
                                case 4:
                                {
                                        AddArtViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier10 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        NSDictionary* dic=[arrYoutubeVideo objectAtIndex:indexPath.row];
                                        
                                        NSString* text=[dic objectForKey:@"value"];
                                        cell.txtField.tag=indexPath.row;
                                        cell.txtField.text=text;
                                        cell.txtField.delegate=self;
                                        [Alert attributedString:cell.txtField
                                                            msg:[dic objectForKey:@"msg"]
                                                          color:[dic objectForKey:@"color"]];
                                        
                                        cell.txtField.autocorrectionType=UITextAutocorrectionTypeNo;
                                        [cell.txtField addTarget:self
                                                          action:@selector(textFieldDidChange:)
                                                forControlEvents:UIControlEventEditingChanged];
                                        
                                        
                                        cell.btnAddMore.tag=indexPath.row;
                                        cell.lblAddMore.text=(indexPath.row==0) ? @"ADD MORE" : @"REMOVE";
                                        
                                        [cell.btnAddMore addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                        return cell;
                                }
                                        break;
                                case 5:
                                {
                                        NSDictionary *item = [arrAvailableForBid objectAtIndex:indexPath.row];
                                        
                                        AddArtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier12 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                        
//                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_REGULAR size:10];
                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];

                                        cell.txtName.text=[item objectForKey:@"value"];
                                        cell.txtName.delegate=self;
                                        [Alert attributedString:cell.txtName
                                                            msg:[item objectForKey:@"msg"]
                                                          color:[item objectForKey:@"color"]];
                                        cell.txtName.tag=indexPath.row;
                                        cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                                        
                                        //                                cell.txtName.keyboardType=indexPath.row==0 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
                                        [cell.txtName addTarget:self
                                                         action:@selector(textFieldDidChange:)
                                               forControlEvents:UIControlEventEditingChanged];
                                        cell.txtName.tintColor=[UIColor blackColor];
                                        
                                        cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                                        
                                        //Add ' * '
                                        NSString* text=[item objectForKey:@"title"];
                                        NSString* readMore=@" *";
                                        text=[text stringByAppendingString:readMore];
                                        cell.lblTitle.text=text;
                                        
                                        cell.lblTitle.delegate=self;
                                        NSURL *url = [NSURL URLWithString:@"action://Expand"];
                                        cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
                                                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
                                        
                                        NSRange r = [cell.lblTitle.text rangeOfString:readMore];
                                        [cell.lblTitle addLinkToURL:url withRange:r];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 6:
                                {
                                        AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        cell.lblLeft.text=@"BACK";
                                        cell.lblRight.text=@"SUBMIT";
                                        cell.btnLeft.tag=indexPath.row;
                                        cell.btnRight.tag=indexPath.row;
                                        [cell.btnLeft addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnRight addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
                                        return cell;
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                default:
                        break;
        }
        
        /*
         switch (indexPath.section) {
         case 0:
         {
         
         switch (indexPath.row) {
         case 0:
         case 1:
         case 2:
         case 3:
         case 4:
         case 5:
         {
         NSDictionary *item = [arrData objectAtIndex:indexPath.row];
         
         UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         
         cell.img.hidden=YES;
         cell.lblTitle.text=[item objectForKey:@"title"];
         cell.lblTitle.tintColor=[UIColor blackColor];
         
         cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
         
         cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
         cell.txtName.text=[item objectForKey:@"value"];
         cell.txtName.delegate=self;
         [Alert attributedString:cell.txtName
         msg:[item objectForKey:@"msg"]
         color:[item objectForKey:@"color"]];
         cell.txtName.tag=indexPath.row;
         cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
         
         //                                cell.txtName.keyboardType=indexPath.row==0 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
         [cell.txtName addTarget:self
         action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
         cell.txtName.tintColor=[UIColor blackColor];
         
         cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
         
         //Add ' * '
         NSString* text=[item objectForKey:@"title"];
         NSString* readMore=@" *";
         text=[text stringByAppendingString:readMore];
         cell.lblTitle.text=text;
         
         cell.lblTitle.delegate=self;
         NSURL *url = [NSURL URLWithString:@"action://Expand"];
         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
         
         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
         [cell.lblTitle addLinkToURL:url withRange:r];
         
         return cell;
         
         }
         break;
         case 6:
         {
         
         NSDictionary *item = [arrData objectAtIndex:indexPath.row];
         UpdateProfileViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         
         cell.img.hidden=YES;
         cell.lblTitle.text=[item objectForKey:@"title"];
         cell.lblTitle.tintColor=[UIColor blackColor];
         
         cell.lblName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
         
         
         cell.lblName.text=[item objectForKey:@"value"];
         
         cell.lblName.tag        =
         cell.btnSelect.tag      =indexPath.row;
         
         
         [cell.btnSelect addTarget:self
         action:@selector(selectUnit:)
         forControlEvents:UIControlEventTouchUpInside];
         
         //Add ' * '
         NSString* text=[item objectForKey:@"title"];
         NSString* readMore=@" *";
         text=[text stringByAppendingString:readMore];
         cell.lblTitle.text=text;
         
         cell.lblTitle.delegate=self;
         NSURL *url = [NSURL URLWithString:@"action://Expand"];
         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
         
         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
         [cell.lblTitle addLinkToURL:url withRange:r];
         
         return cell;
         
         }
         break;
         case 7:
         {
         AddArtViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         cell.lblTitle.text=@"NEXT";
         cell.btnClick.tag=indexPath.row;
         [cell.btnClick addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
         }
         
         break;
         default:
         break;
         }
         
         
         
         }
         break;
         case 1:
         {
         
         switch (indexPath.row) {
         case 0:
         {
         AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         cell.lblLeft.text=@"BACK";
         cell.lblRight.text=@"NEXT";
         cell.btnLeft.tag=indexPath.row;
         cell.btnRight.tag=indexPath.row;
         [cell.btnLeft addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
         [cell.btnRight addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
         }
         break;
         case 1:
         case 2:
         case 3:
         case 4:
         case 5:
         {
         NSDictionary *item = [arrData objectAtIndex:indexPath.row];
         
         UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         
         cell.img.hidden=YES;
         cell.lblTitle.text=[item objectForKey:@"title"];
         cell.lblTitle.tintColor=[UIColor blackColor];
         
         cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
         
         cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
         cell.txtName.text=[item objectForKey:@"value"];
         cell.txtName.delegate=self;
         [Alert attributedString:cell.txtName
         msg:[item objectForKey:@"msg"]
         color:[item objectForKey:@"color"]];
         cell.txtName.tag=indexPath.row;
         cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
         
         //                                cell.txtName.keyboardType=indexPath.row==0 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
         [cell.txtName addTarget:self
         action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
         cell.txtName.tintColor=[UIColor blackColor];
         
         cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
         
         //Add ' * '
         NSString* text=[item objectForKey:@"title"];
         NSString* readMore=@" *";
         text=[text stringByAppendingString:readMore];
         cell.lblTitle.text=text;
         
         cell.lblTitle.delegate=self;
         NSURL *url = [NSURL URLWithString:@"action://Expand"];
         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
         
         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
         [cell.lblTitle addLinkToURL:url withRange:r];
         
         return cell;
         
         }
         break;
         case 6:
         {
         
         NSDictionary *item = [arrData objectAtIndex:indexPath.row];
         UpdateProfileViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         
         cell.img.hidden=YES;
         cell.lblTitle.text=[item objectForKey:@"title"];
         cell.lblTitle.tintColor=[UIColor blackColor];
         
         cell.lblName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
         
         
         cell.lblName.text=[item objectForKey:@"value"];
         
         cell.lblName.tag        =
         cell.btnSelect.tag      =indexPath.row;
         
         
         [cell.btnSelect addTarget:self
         action:@selector(selectUnit:)
         forControlEvents:UIControlEventTouchUpInside];
         
         //Add ' * '
         NSString* text=[item objectForKey:@"title"];
         NSString* readMore=@" *";
         text=[text stringByAppendingString:readMore];
         cell.lblTitle.text=text;
         
         cell.lblTitle.delegate=self;
         NSURL *url = [NSURL URLWithString:@"action://Expand"];
         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
         
         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
         [cell.lblTitle addLinkToURL:url withRange:r];
         
         return cell;
         
         }
         break;
         case 7:
         {
         AddArtViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         cell.lblTitle.text=@"NEXT";
         cell.btnClick.tag=indexPath.row;
         [cell.btnClick addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
         }
         
         break;
         default:
         break;
         }
         
         
         
         }
         break;
         
         case 2:
         {
         
         switch (indexPath.row) {
         case 0:
         {
         AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         cell.lblLeft.text=@"BACK";
         cell.lblRight.text=@"SUBMIT";
         cell.btnLeft.tag=indexPath.row;
         cell.btnRight.tag=indexPath.row;
         [cell.btnLeft addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
         [cell.btnRight addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
         }
         break;
         case 1:
         case 2:
         case 3:
         case 4:
         case 5:
         {
         NSDictionary *item = [arrData objectAtIndex:indexPath.row];
         
         UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         
         cell.img.hidden=YES;
         cell.lblTitle.text=[item objectForKey:@"title"];
         cell.lblTitle.tintColor=[UIColor blackColor];
         
         cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
         
         cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
         cell.txtName.text=[item objectForKey:@"value"];
         cell.txtName.delegate=self;
         [Alert attributedString:cell.txtName
         msg:[item objectForKey:@"msg"]
         color:[item objectForKey:@"color"]];
         cell.txtName.tag=indexPath.row;
         cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
         
         //                                cell.txtName.keyboardType=indexPath.row==0 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
         [cell.txtName addTarget:self
         action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
         cell.txtName.tintColor=[UIColor blackColor];
         
         cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
         
         //Add ' * '
         NSString* text=[item objectForKey:@"title"];
         NSString* readMore=@" *";
         text=[text stringByAppendingString:readMore];
         cell.lblTitle.text=text;
         
         cell.lblTitle.delegate=self;
         NSURL *url = [NSURL URLWithString:@"action://Expand"];
         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
         
         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
         [cell.lblTitle addLinkToURL:url withRange:r];
         
         return cell;
         
         }
         break;
         case 6:
         {
         
         NSDictionary *item = [arrData objectAtIndex:indexPath.row];
         UpdateProfileViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         
         cell.img.hidden=YES;
         cell.lblTitle.text=[item objectForKey:@"title"];
         cell.lblTitle.tintColor=[UIColor blackColor];
         
         cell.lblName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
         
         
         cell.lblName.text=[item objectForKey:@"value"];
         
         cell.lblName.tag        =
         cell.btnSelect.tag      =indexPath.row;
         
         
         [cell.btnSelect addTarget:self
         action:@selector(selectUnit:)
         forControlEvents:UIControlEventTouchUpInside];
         
         //Add ' * '
         NSString* text=[item objectForKey:@"title"];
         NSString* readMore=@" *";
         text=[text stringByAppendingString:readMore];
         cell.lblTitle.text=text;
         
         cell.lblTitle.delegate=self;
         NSURL *url = [NSURL URLWithString:@"action://Expand"];
         cell.lblTitle.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor redColor],
         NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
         
         NSRange r = [cell.lblTitle.text rangeOfString:readMore];
         [cell.lblTitle addLinkToURL:url withRange:r];
         
         return cell;
         
         }
         break;
         case 7:
         {
         AddArtViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.contentView.backgroundColor=[UIColor whiteColor];
         cell.lblTitle.text=@"NEXT";
         cell.btnClick.tag=indexPath.row;
         [cell.btnClick addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
         }
         
         break;
         default:
         break;
         }
         
         
         
         }
         break;
         
         default:
         break;
         }
         */
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        switch (level) {
                case 2:
                {
                        NSDictionary* dic=[[addArt objectForKey:[arrSortOrder objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                        
                        NSString* title=[arrSortOrder objectAtIndex:indexPath.section];
                        
                        if([title isEqualToString:CATEGORY]){
                                if(!arrCategory) arrCategory=[[NSMutableArray alloc]init];
                                
                                if([arrCategory containsObject:[dic objectForKey:@"id"]])
                                        [arrCategory removeObject:[dic objectForKey:@"id"]];
                                else
                                        [arrCategory addObject:[dic objectForKey:@"id"]];
                                
                                //                                [self.delegate filterOption:arrCategory title:title finish:NO];
                        }
                        else if([title isEqualToString:CATEGORY_STYLE_NAME]){
                                if(!arrStyle) arrStyle=[[NSMutableArray alloc]init];
                                
                                if([arrStyle containsObject:[dic objectForKey:@"id"]])
                                        [arrStyle removeObject:[dic objectForKey:@"id"]];
                                else
                                        [arrStyle addObject:[dic objectForKey:@"id"]];
                                
                                //                                [self.delegate filterOption:arrStyle title:title finish:NO];
                        }
                        else if([title isEqualToString:CATEGORY_COLOR_NAME]){
                                if(!arrColor) arrColor=[[NSMutableArray alloc]init];
                                
                                if([arrColor containsObject:[dic objectForKey:@"id"]])
                                        [arrColor removeObject:[dic objectForKey:@"id"]];
                                else
                                        [arrColor addObject:[dic objectForKey:@"id"]];
                                
                                //                                [self.delegate filterOption:arrColor title:title finish:NO];
                        }
                        
                        [self.tableView reloadData];
                }
                        break;
                        
                default:
                        break;
        }
        
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        NSString *header  = @"";
        
        switch (level) {
                case 1:
                        header=[arrHeaderTitle objectAtIndex:section];
                        break;
                        
                case 2:
                {
                        
                        header=[arrSortOrder objectAtIndex:section];
                        if([header isEqualToString:CATEGORY])
                                header=@"Categories";
                        if([header isEqualToString:CATEGORY_STYLE_NAME])
                                header=@"Subject";
                        if([header isEqualToString:CATEGORY_COLOR_NAME])
                                header=@"Color";
                        
                }
                        break;
                case 3:
                        switch (section) {
                                case 1:
                                case 3:
                                        header=@"Multiple Art";
                                        break;
                                case 2:
                                case 4:
                                        header=@"Youtube Video";
                                        break;
                                case 5:
                                        header=@"Available For Bid";
                                        break;
                                default:
                                        break;
                        }
                        break;
                default:
                        break;
        }
        return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        //Header View
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor=[UIColor whiteColor];
        
        //Header Title
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, 20);
        myLabel.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:14];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.textColor = [UIColor blackColor];
        myLabel.backgroundColor=[UIColor clearColor];
        [headerView addSubview:myLabel];
        
        if(level==2) {
                
                NSInteger l1 = myLabel.text.length;
                NSString* text2 = @" *";
                myLabel.text = [myLabel.text stringByAppendingString:text2];
                NSInteger l2 = text2.length;
                
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
                NSDictionary *fontDic = [NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:myLabel.text attributes:fontDic];
                
                [string addAttribute:NSForegroundColorAttributeName value:myLabel.textColor range:NSMakeRange(0,l1)];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(l1,l2)];
                myLabel.attributedText = string;
        }
        
        if(level==3 && section==5) {
                
                UIView* viTick=[[UIView alloc]initWithFrame:CGRectMake(8, 6, 18, 18)];
                viTick.backgroundColor=[UIColor clearColor];
                
                UIImageView* img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
                img.image=[UIImage imageNamed:isAvailableForBid ? SELECT_TICK : UNSELECT_TICK];
                
                
                UIButton* btnSelectTick=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
                btnSelectTick.tag=section;
                [btnSelectTick addTarget:self action:@selector(availableForBid:) forControlEvents:UIControlEventTouchUpInside];
                
                [viTick addSubview:img];
                [viTick addSubview:btnSelectTick];
                [headerView addSubview:viTick];
                
        }
        
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        
        NSInteger height=0;
        
        switch (level) {
                case 1:
                        height=36.0f;
                        break;
                case 2:
                        switch (section) {
                                case 0:
                                case 1:
                                case 2:
                                        height=30.0f;
                                        break;
                                case 3:
                                        height=0;
                                        break;
                                case 4:
                                        height=0;
                                        break;
                                default:
                                        break;
                        }
                        
                        break;
                case 3:
                        
                        switch (section) {
                                case 1:
                                {
                                        NSArray* arrImages=[self.response objectForKey:@"art_more_image"];
                                        arrImages=[self getValidImages:arrImages];
                                        height=arrImages.count ? 30.0f :0;
                                }
                                        break;
                                case 2:
                                {
                                        NSArray* arrVideos=[self.response objectForKey:@"art_video"];
                                        arrVideos=[self getValidUrl:arrVideos];
                                        height=arrVideos.count ? 30.0f :0;
                                }
                                        break;
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                        height=30.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                default:
                        break;
        }
        
        return height;
}

#pragma Mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        
        [textField resignFirstResponder];
        
        NSIndexPath *indexPath =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
        switch (level) {
                case 3:
                {
                        switch (indexPath.section) {
                                case 5:
                                {
                                        switch (indexPath.row) {
                                                case 2:
                                                {
                                                        isDate=YES;
                                                        [self createDatePicker:NO items:nil sender:textField datePickerMode:(UIDatePickerModeDate)];
                                                        return NO;
                                                }
                                                        break;
                                                case 3:
                                                {
                                                        isDate=YES;
                                                        [self createDatePicker:NO items:nil sender:textField datePickerMode:(UIDatePickerModeDate)];
                                                        return NO;
                                                }
                                                        break;
                                                        
                                                default:
                                                        
                                                        break;
                                        }
                                        
                                        
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                }
                        break;
                        
                default:
                        break;
        }
        
        
        
        if(!isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        
        return YES;
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
        
        
        
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
        
        NSIndexPath *indexPathOriginal =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
        
        
        switch (level) {
                case 1:
                {
                        UpdateProfileViewCell * cell;
                        if(textField.tag==0 && !IS_EMPTY(textField.text)){
                                BOOL isName=[Alert validationString:textField.text];
                                
                                if(!isName){
                                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES];
                                        [textField becomeFirstResponder];
                                        
                                }
                                else{
                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                                        [cell.txtName becomeFirstResponder];
                                        
                                }
                        }
                        else if(textField.tag==1 && !IS_EMPTY(textField.text)){
                                BOOL isNumber=[Alert validateNumber:textField.text];
                                
                                if(!isNumber){
                                        [Alert alertWithMessage:@"Invalid Price ! Please enter valid price."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES];
                                        [textField becomeFirstResponder];
                                        
                                }
                                else{
                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                                        [cell.txtName becomeFirstResponder];
                                        
                                }
                        }
                        else if(textField.tag==2 && !IS_EMPTY(textField.text)){
                                BOOL isNumber=[Alert validateNumber:textField.text];
                                
                                if(!isNumber){
                                        [Alert alertWithMessage:@"Invalid Quantity ! Please enter valid quantity."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES];
                                        [textField becomeFirstResponder];
                                        
                                }
                                else{
                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                                        [cell.txtName becomeFirstResponder];
                                }
                        }
                        else if(textField.tag==3 && !IS_EMPTY(textField.text)){
                                //BOOL isNumber=[Alert validateNumber:textField.text];
                                //
                                //                if(!isNumber){
                                //                        [Alert alertWithMessage:@"Invalid Quantity ! Please enter valid quantity."
                                //                                     navigation:self.navigationController
                                //                                       gotoBack:NO animation:YES];
                                //                        [textField becomeFirstResponder];
                                //
                                //                }
                                //                else{
                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                                [cell.txtName becomeFirstResponder];
                                //                }
                        }
                        else if(textField.tag==4 && !IS_EMPTY(textField.text)){
                                //BOOL isNumber=[Alert validateNumber:textField.text];
                                
                                //                if(!isNumber){
                                //                        [Alert alertWithMessage:@"Invalid Quantity ! Please enter valid quantity."
                                //                                     navigation:self.navigationController
                                //                                       gotoBack:NO animation:YES];
                                //                        [textField becomeFirstResponder];
                                //
                                //                }
                                //                else{
                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                                [cell.txtName becomeFirstResponder];
                                //                }
                        }
                        else if(textField.tag==5 && !IS_EMPTY(textField.text)){
                                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                
                                
                                
                        }
                        
                }
                        break;
                        
                case 3:
                {
                        switch (indexPathOriginal.section) {
                                case 4:
                                        
                                        [self.tableView scrollToRowAtIndexPath:indexPathOriginal atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                        break;
                                case 5:
                                        switch (indexPathOriginal.row) {
                                                case 0:
                                                {
                                                        if(!IS_EMPTY(textField.text)){
                                                                BOOL isNumber=[Alert validateNumber:textField.text];
                                                                
                                                                if(!isNumber){
                                                                        [Alert alertWithMessage:@"Invalid Price ! Please enter valid price."
                                                                                     navigation:self.navigationController
                                                                                       gotoBack:NO animation:YES];
                                                                        [textField becomeFirstResponder];
                                                                        
                                                                }
                                                                else{
                                                                        AddArtTableViewCell * cell;
                                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:5]];
                                                                        [cell.txtName becomeFirstResponder];
                                                                        
                                                                }
                                                        }
                                                }
                                                        break;
                                                case 1:
                                                {
                                                        if(!IS_EMPTY(textField.text)){
                                                                BOOL isNumber=[Alert validateNumber:textField.text];
                                                                
                                                                if(!isNumber){
                                                                        [Alert alertWithMessage:@"Invalid Price ! Please enter valid price."
                                                                                     navigation:self.navigationController
                                                                                       gotoBack:NO animation:YES];
                                                                        [textField becomeFirstResponder];
                                                                        
                                                                }
                                                                else{
                                                                        [self.tableView scrollToRowAtIndexPath:indexPathOriginal atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                                        
                                                                }
                                                        }
                                                }
                                                        break;
                                                        
                                                        
                                                default:
                                                        break;
                                        }
                                        break;
                                        
                                default:
                                        break;
                        }
                }
                        break;
                        
                default:
                        break;
        }
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height- self.tableView.frame.origin.y- ([self isEditArt] ? 0 : 63));
                
        }
        
        isUpdateHeight=NO;
        
        
        return YES;
}

-(void)textFieldDidChange:(id)sender {
        
        //        isUpdate=YES;
        UITextField* txt=(UITextField*)sender;
        
        NSIndexPath *indexPath =[Alert getIndexPathWithTextfield:txt table:self.tableView];
        //
        switch (level) {
                case 1:
                {
                        BOOL isValid=NO;
                        //
                        if(txt.tag==0)
                                isValid=[Alert validationString:txt.text];
                        else if(txt.tag==1 || txt.tag==2 || txt.tag==3 || txt.tag==4 || txt.tag==5)
                                isValid=[Alert validateNumber:txt.text];
                        else isValid=YES;
                        
                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic=[arrData objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                case 3:
                {
                        switch (indexPath.section) {
                                case 4:
                                {
                                        NSMutableDictionary* dic=[arrYoutubeVideo objectAtIndex:txt.tag];
                                        
                                        [dic setObject:txt.text forKey:@"value"];
                                        
                                }
                                        break;
                                case 5:
                                {
                                        BOOL isValid=NO;
                                        switch (indexPath.row) {
                                                case 0:
                                                case 1:
                                                {
                                                        isValid=[Alert validateNumber:txt.text];
                                                }
                                                        break;
                                                        
                                                default:
                                                        isValid=YES;
                                                        break;
                                        }
                                        
                                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                                        
                                        NSMutableDictionary* dic=[arrAvailableForBid objectAtIndex:txt.tag];
                                        
                                        [dic setObject:txt.text forKey:@"value"];
                                        
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                }
                        break;
                        
                default:
                        break;
        }
        
}


#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
        
        textView.backgroundColor = [UIColor whiteColor];
        textView.textColor=[UIColor blackColor];
        
        
        if([textView.text isEqualToString:PLACEHOLDER_MESSAGE]){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = @"";
        }
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        
        if (textView.tag == 1000) {
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:3];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                isUpdateHeight=YES;
                return YES;
                
        }
        else if(textView.tag == 1001) {
                
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:4];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                isUpdateHeight=YES;
                return YES;
        }else
                return NO;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
        //  NSLog(@"textViewShouldEndEditing:");
        
        // textView.textColor= [UIColor blackColor];
        return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
        //    NSLog(@"textViewDidEndEditing:");
        if(textView.text.length == 0){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
        if(isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height- self.tableView.frame.origin.y-63);
                
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
- (void)textViewDidChange:(UITextView *)textView{
        textView.textColor=[UIColor blackColor];
        //        isUpdate=YES;
        //[self validateForNativeChat];
        
        if(textView.text.length == 0){
                //                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
        //        NSInteger rows=[self.tableView numberOfRowsInSection:0];
        
        if (textView.tag == 1000) {
                
                NSInteger rows = 7;
                NSMutableDictionary* dic=[arrData objectAtIndex:rows];
                [dic setObject:textView.text forKey:@"value"];
                
                
        }
        if (textView.tag == 1001)  {
                
                NSInteger rows1 = 8;
                NSMutableDictionary* dic1=[arrData objectAtIndex:rows1];
                [dic1 setObject:textView.text forKey:@"value"];
        }
        
        
}


-(NSArray*)matchPathWithArray:(NSArray*)list{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path.length > 0"];
        NSArray *matchingObjs = [list filteredArrayUsingPredicate:predicate];
        
        if ([matchingObjs count] == 0)
        {
                //NSLog(@"No match");
                return nil;
        }
        else
        {
                //NSLog(@"Matched");
                return matchingObjs;
        }
}
-(NSArray*)matchValueWithArray:(NSArray*)list{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value.length > 0"];
        NSArray *matchingObjs = [list filteredArrayUsingPredicate:predicate];
        
        if ([matchingObjs count] == 0)
        {
                //NSLog(@"No match");
                return nil;
        }
        else
        {
                //NSLog(@"Matched");
                return matchingObjs;
        }
}

#pragma mark - Validate Levels

-(BOOL)isLevel1{
        BOOL isValid=NO;
        
        NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* index1=[NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2=[NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath* index3=[NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath* index4=[NSIndexPath indexPathForRow:4 inSection:0];
        NSIndexPath* index5=[NSIndexPath indexPathForRow:5 inSection:0];
        
        if(!IS_EMPTY([[arrData objectAtIndex:0] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData objectAtIndex:1] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData objectAtIndex:2] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData objectAtIndex:3] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData objectAtIndex:4] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData objectAtIndex:5] objectForKey:@"value"]) &&
           ![[[arrData objectAtIndex:6] objectForKey:@"value"] isEqualToString:SELECT_OPTION]) {
                BOOL isName     =[Alert validationString:[[arrData objectAtIndex:0] objectForKey:@"value"]];
                BOOL isPrice    =[Alert validateNumber:[[arrData objectAtIndex:1] objectForKey:@"value"]];
                BOOL isQuantity =[Alert validateNumber:[[arrData objectAtIndex:2] objectForKey:@"value"]];
                BOOL isWidth    =[Alert validateNumber:[[arrData objectAtIndex:3] objectForKey:@"value"]];
                BOOL isHeight   =[Alert validateNumber:[[arrData objectAtIndex:4] objectForKey:@"value"]];
                BOOL isDepth    =[Alert validateNumber:[[arrData objectAtIndex:5] objectForKey:@"value"]];
                
                
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        
                }
                else if(!isPrice){
                        [Alert alertWithMessage:@"Invalid Price ! Please enter valid price."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isQuantity){
                        [Alert alertWithMessage:@"Invalid Quantity ! Please enter valid quantity."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isWidth){
                        [Alert alertWithMessage:@"Invalid Width ! Please enter valid width."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index3 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isHeight){
                        [Alert alertWithMessage:@"Invalid Height ! Please enter valid height."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index4 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isDepth){
                        [Alert alertWithMessage:@"Invalid Depth ! Please enter valid depth."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:2.0];
                        [self.tableView scrollToRowAtIndexPath:index5 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else
                {
                        isValid=YES;
                }
        }
        else
        {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Mandatory (*) Fields can not be blank!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil]show];
                
                
        }
        
        
        
        return isValid;
        
}

-(BOOL)isLevel2 {
        
        BOOL isValid = NO;
        
        NSInteger rows = 7;
        NSMutableDictionary* dic=[arrData objectAtIndex:rows];
        
        NSInteger rows1 = 8;
        NSMutableDictionary* dic1=[arrData objectAtIndex:rows1];
        
        
        if((arrCategory.count && arrStyle.count && arrColor.count && ![[dic objectForKey:@"value"] isEqualToString:PLACEHOLDER_MESSAGE]   )   &&  (arrCategory.count && arrStyle.count && arrColor.count && ![[dic1 objectForKey:@"value"] isEqualToString:PLACEHOLDER_MESSAGE])) isValid=YES;
        else
        {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Mandatory (*) Fields can not be blank!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil]show];
                
                
        }
        
        
        
        return isValid;
}

-(BOOL)isLevel3 {
        
        BOOL isValid=NO;
        
        NSInteger rows=9;
        
        NSDictionary *item = [arrData objectAtIndex:rows];
        
        if(selectedImage || ([self isEditArt] && !IS_EMPTY([item objectForKey:@"url"])))
        {
                if(isAvailableForBid){
                        
                        NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:5];
                        NSIndexPath* index1=[NSIndexPath indexPathForRow:1 inSection:5];
                        
                        if(!IS_EMPTY([[arrAvailableForBid objectAtIndex:0] objectForKey:@"value"]) &&
                           !IS_EMPTY([[arrAvailableForBid objectAtIndex:1] objectForKey:@"value"]) &&
                           !IS_EMPTY([[arrAvailableForBid objectAtIndex:2] objectForKey:@"value"]) &&
                           !IS_EMPTY([[arrAvailableForBid objectAtIndex:3] objectForKey:@"value"])) {
                                BOOL isMinPrice =[Alert validateNumber:[[arrAvailableForBid objectAtIndex:0] objectForKey:@"value"]];
                                BOOL isMaxPrice =[Alert validateNumber:[[arrAvailableForBid objectAtIndex:1] objectForKey:@"value"]];
                                NSString* startDateString       =[[arrAvailableForBid objectAtIndex:2] objectForKey:@"value"];
                                NSString* endDateString         =[[arrAvailableForBid objectAtIndex:3] objectForKey:@"value"];
                                
                                NSDate* sDate=[Alert getDateWithDateString:startDateString setFormat:DATE_FORMAT_UTC];
                                NSDate* eDate=[Alert getDateWithDateString:endDateString setFormat:DATE_FORMAT_UTC];
                                BOOL isSame=([sDate compare:eDate] == NSOrderedAscending);
                                if(!isMinPrice){
                                        [Alert alertWithMessage:@"Invalid Price ! Please enter valid minimum price."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:2.0];
                                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                        
                                }
                                else if(!isMaxPrice){
                                        [Alert alertWithMessage:@"Invalid Price ! Please enter valid maximum price.."
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:2.0];
                                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                }
                                else if(!isSame){
                                        
                                        [Alert alertWithMessage:@"Please select valid Ends Date ! "
                                                     navigation:self.navigationController
                                                       gotoBack:NO animation:YES second:2.0];
                                }
                                else
                                {
                                        isValid=YES;
                                }
                        } else {
                                
                                [[[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Mandatory (*) Fields can not be blank!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil]show];
                                
                                
                        }
                        
                }
                
                else if (!isAvailableForBid) {
                        
                        isValid = YES;
                }
                
                else    isValid=YES;
        }
        else
        {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Mandatory (*) Fields can not be blank!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil]show];
                
                
        }
        
        
        return isValid;
}

-(BOOL)isValidateLevel {
        
        BOOL isValid=NO;
        
        
        switch (level) {
                case 1:
                        isValid=[self isLevel1];
                        break;
                case 2:
                        isValid=[self isLevel2];
                        break;
                case 3:
                        isValid=[self isLevel3];
                        break;
                        
                default:
                        break;
        }
        
        
        return isValid;
}

#pragma mark - Target Support methods

-(void)addMoreFile{
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:@""                                              forKey:@"path"];
        [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
        [arrMultipleArt addObject:dic];
        
        
}

-(void)removeFile:(NSInteger)index{
        
        [arrMultipleArt removeObjectAtIndex:index];
}

-(void)addMoreYoutubeVideo{
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:YOUTUBE_VIDEO_MESSAGE                            forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrYoutubeVideo addObject:dic];
        
        
}

-(void)removeYoutubeVideo:(NSInteger)index{
        
        [arrYoutubeVideo removeObjectAtIndex:index];
}

#pragma mark - Target Methods

-(IBAction)selectUnit:(id)sender{
        
        //        UIButton* button=(UIButton*)sender;
        
        //NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        
        if(arrUnit.count)
                [self createDatePicker:YES items:arrUnit sender:sender datePickerMode:nil];
}

-(IBAction)backMove:(id)sender{
        
        if(level<=1) return;
        level-=1;
        
        [self reSetStepIcon];
        
        [self.tableView reloadData];
}

-(IBAction)next:(id)sender{
        
        if(![self isValidateLevel]) return;
        
        if(level==3){
                
                [self  addArts];
                
        }
        if(level>=3) return;
        level+=1;
        
        [self reSetStepIcon];
        [self.tableView reloadData];
}

-(IBAction)choosePic:(id)sender {
        
        isArtImage = YES;
//        UIButton* button=(UIButton*)sender;
//        
//        NSIndexPath *indexPath =[Alert getIndexPathWithButton:button table:self.tableView];
        
//        __weak __typeof(self)weakSelf = self;
        
        [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
                
                
                TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                cropController.delegate = self;
                [self presentViewController:cropController animated:YES completion:nil];
        }];

        
//                selectedImage=image;
//                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                
    //    }];
        
}



-(IBAction)chooseFile:(id)sender {
        
        isArtImage = NO;
        UIButton* button=(UIButton*)sender;
        
        indexPathForMultipleArt =[Alert getIndexPathWithButton:button table:self.tableView];
        
        __weak __typeof(self)weakSelf = self;
        
        [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
                
                
                TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                cropController.delegate = self;
                [self presentViewController:cropController animated:YES completion:nil];

                
//                NSMutableDictionary* dic=[arrMultipleArt objectAtIndex:indexPath.row];
//                [dic setObject:[Alert getNameForImage] forKey:@"path"];
//                [dic setObject:image forKey:@"image"];
//                
//                [Alert reloadSection:indexPath.section table:weakSelf.tableView];
                
        }];
        
}


#pragma mark - Cropper Delegate Method -

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
        
        //        self.imageUser.image = image;
        //        self.imageUserSelected = image;
        //        self.imageUser.hidden = YES;
        //        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(self.imageUser.frame.origin.x, self.imageUser.frame.origin.y + 64, self.imageUser.frame.size.width, self.imageUser.frame.size.height) completion:^{
        //                self.imageUser.hidden = NO;
        //        }];
        
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(0, 100.0, 40.0, 40.0) completion:^{
                
                if (isArtImage) {
                        
                        selectedImage=image;
                        __weak __typeof(self)weakSelf = self;
                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                        
                        __weak __typeof(self)weakSelf = self;
                        
                        
                        NSMutableDictionary* dic = [arrMultipleArt objectAtIndex:indexPathForMultipleArt.row];
                        [dic setObject:[Alert getNameForImage] forKey:@"path"];
                        [dic setObject:image forKey:@"image"];
                        
                        [Alert reloadSection:3 table:weakSelf.tableView];
                        indexPathForMultipleArt = nil;
                }
                
        }];
        
}



-(IBAction)addMore:(id)sender {
        
        UIButton* button=(UIButton*)sender;
        
        NSIndexPath *indexPath =[Alert getIndexPathWithButton:button table:self.tableView];
        
        switch (indexPath.section) {
                case 3:
                {
                        
                        if(indexPath.row==0)
                                [self addMoreFile];
                        else
                                [self removeFile:indexPath.row];
                }
                        break;
                case 4:
                {
                        
                        if(indexPath.row==0)
                                [self addMoreYoutubeVideo];
                        else
                                [self removeYoutubeVideo:indexPath.row];
                }
                        break;
                        
                default:
                        break;
        }
        
        [Alert reloadSection:indexPath.section table:self.tableView];
        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(IBAction)availableForBid:(id)sender{
        
        isAvailableForBid=!isAvailableForBid;
        
        [Alert reloadSection:5 table:self.tableView];
}


-(void)addArts {
        
        NSArray* arrVideo= [self matchPathWithArray:arrMultipleArt];
        NSArray* arrLink= [self matchValueWithArray:arrYoutubeVideo];
        NSArray* arrCat=[arrCategory mutableCopy];
        NSArray* arrCol=[arrColor mutableCopy];
        NSArray* arrSty=[arrStyle mutableCopy];
        
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:[[EAGallery sharedClass] memberID] forKey:@"user_id"];
        [dic setObject:arrCat forKey:@"cat_name"];
        [dic setObject:arrCol forKey:@"art_col"];
        [dic setObject:arrSty forKey:@"style_name"];
        [dic setObject:[[arrData objectAtIndex:0] objectForKey:@"value"] forKey:@"artname"];
        [dic setObject:[[arrData objectAtIndex:1] objectForKey:@"value"] forKey:@"artprice"];
        [dic setObject:[[arrData objectAtIndex:2] objectForKey:@"value"] forKey:@"quantity"];
        [dic setObject:[[arrData objectAtIndex:3] objectForKey:@"value"] forKey:@"artwidth"];
        [dic setObject:[[arrData objectAtIndex:4] objectForKey:@"value"] forKey:@"artheight"];
        [dic setObject:[[arrData objectAtIndex:5] objectForKey:@"value"] forKey:@"artdepth"];
        [dic setObject:[[arrData objectAtIndex:6] objectForKey:@"value"] forKey:@"unit"];
        [dic setObject:[[arrData objectAtIndex:7] objectForKey:@"value"] forKey:@"aboutart"];
        [dic setObject:[[arrData objectAtIndex:8] objectForKey:@"value"] forKey:@"keyword"];
        //        "bidding":"1","bid_min_price":"150","bid_max_price":"160","bid_start_date":"2017-05-15 14:50:00","bid_end_date":"2017-08-15 14:50:00"}
        
        //        NSArray* arrRes=[self.response objectForKey:@"auction_details"];
        //        NSDictionary* dicResp=arrRes.count ? [arrRes firstObject]: nil;
        
        [dic setObject:isAvailableForBid ? @"1" : @"0" forKey:@"bidding"];
        [dic setObject:isAvailableForBid ? [[arrAvailableForBid objectAtIndex:0] objectForKey:@"value"] : @"" forKey:@"bid_min_price"];
        [dic setObject:isAvailableForBid ? [[arrAvailableForBid objectAtIndex:1] objectForKey:@"value"] : @"" forKey:@"bid_max_price"];
        [dic setObject:isAvailableForBid ? [[arrAvailableForBid objectAtIndex:2] objectForKey:@"value"] : @"" forKey:@"bid_start_date"];
        [dic setObject:isAvailableForBid ? [[arrAvailableForBid objectAtIndex:3] objectForKey:@"value"] : @"" forKey:@"bid_end_date"];
        
        
        [dic setObject:arrLink.count ? [arrLink valueForKeyPath:@"value"] :@[] forKey:@"input"];
        
        if([self isEditArt])    [dic setObject:self.artID forKey:@"art_id"];
        
        NSLog(@"%@",dic);
        
        //imagename
        //imagedata
        //imagekey
        
        NSMutableArray* arrImages=[[NSMutableArray alloc]init];
        for (NSDictionary* dic in arrVideo) {
                
                UIImage* image=[dic objectForKey:@"image"];
                NSString* fileName=[dic objectForKey:@"path"];
                NSData* imageData =image ? UIImageJPEGRepresentation(image, 90) : nil;
                
                if(imageData){
                        NSMutableDictionary* imageDic=[NSMutableDictionary dictionary];
                        [imageDic setObject:imageData                forKey:@"imagedata"];
                        [imageDic setObject:fileName                   forKey:@"imagename"];
                        [imageDic setObject:@"uploadedimages[]"        forKey:@"imagekey"];
                        [arrImages addObject:imageDic];
                }
        }
        
        
        
        NSData* imageData =selectedImage ? UIImageJPEGRepresentation(selectedImage, 90) : nil;
        
        if(imageData){
                NSMutableDictionary* imageDic=[NSMutableDictionary dictionary];
                [imageDic setObject:imageData                forKey:@"imagedata"];
                [imageDic setObject:[Alert getNameForImage]  forKey:@"imagename"];
                [imageDic setObject:@"artimage"              forKey:@"imagekey"];
                [arrImages addObject:imageDic];
        }
        
        // NSLog(@"%@",arrImages);
        
        
        
        [self addArtWebService:[dic mutableCopy] images:arrImages.count? arrImages : nil];
        
        //Add Art
        //Note: send image in multipart/form-data, filed name is : artimage
        //        {"user_id":"53",
        //        "cat_name":["4","8","6"],
        //        "art_col":["5","6"],
        //        "style_name":["5","8"],
        //        "artname":" inida vistion of art ",
        //        "artwidth":"12",
        //        "artheight":"12",
        //        "artdepth":"1",
        //        "unit":"cm",
        //        "artprice":"1200",
        //        "aboutart":" IT IS THE INDIA BEST ART",
        //        "quantity":"10",
        //        "input":["youtube","youtube1"]}
        
        //Edit Art
        
        //        {
        //                "art_id": "466",
        //                "user_id": "203",
        //                "cat_name": ["4", "8", "6"],
        //                "art_col": ["5", "6"],
        //                "style_name": ["5", "8"],
        //                "artname": " inida vistion of art ",
        //                "artwidth": "12",
        //                "artheight": "12",
        //                "artdepth": "1",
        //                "unit": "cm",
        //                "artprice": "1200",
        //                "aboutart": " IT IS THE INDIA BEST ART",
        //                "quantity": "10",
        //                "input": ["youtube", "youtube1"]
        //        }
        
        
}

@end
