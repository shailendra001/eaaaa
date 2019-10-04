//
//  ArtRegistrationViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 05/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "ArtRegistrationViewController.h"
#import "UpdateProfileViewCell.h"
#import "AddArtViewCell2.h"
#import "RegistrationViewCell.h"
#import "ArtRegisrtationTableViewCell1.h"
#import "ArtRegistrationTableViewCell2.h"
#import "ArtRegistrationTableViewCell3.h"
#import "AddArtViewCell1.h"
#import "AddArtViewCell3.h"
#import "BuyCertificateVC.h"
#import "TOCropViewController.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_TEXT         @"#575656"

#define STEP_1_ICON     @"step1.png"
#define STEP_2_ICON     @"step2.png"
#define STEP_3_ICON     @"step3.png"

#define CELL_CONTENT_LEFT_MARGIN        0
#define CELL_CONTENT_TOP_MARGIN         0

#define CELL_DESC_LEFT_MARGIN           41
#define CELL_DESC_RIGHT_MARGIN          8
#define CELL_DESC_HEIGHT_DEFAULT        80
#define CELL_DESC_TOP_MARGIN            7
#define CELL_CONTENT_BOTTOM_MARGIN      8

#define CELL_PICUTRE_LEFT_MARGIN        0
#define CELL_PICUTRE_HEIGHT_DEFAULT     180


@interface ArtRegistrationViewController ()<UITableViewDelegate,UITableViewDataSource,FPPopoverControllerDelegate,buttontitledelgate,PopupDelegate,UITextFieldDelegate,TTTAttributedLabelDelegate,PickerViewDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate, TOCropViewControllerDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        int level;
        
        NSMutableArray* arrData1;
        NSMutableArray* arrData2;
        NSMutableArray* arrData3;
        NSMutableArray* arrHeaderTitle1;
        NSMutableArray* arrHeaderTitle2;
        NSMutableArray* arrHeaderTitle3;
        NSMutableArray* arrMultipartDoc;
        NSMutableArray* arrMultipartPhoto;
        NSMutableArray* arrSelections;
        
        NSMutableArray* arrCat1;
        NSMutableArray* arrCat2;
        
        NSString* cat1;
        NSString* cat2;
        
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        BOOL isUpdateHeight;
        BOOL isPremiumPayment;
//      NSMutableDictionary *dicPhoto, *dicDoc;
        NSIndexPath *indexPathForMultiplart;
        NSDictionary *resPonsedataArray;
  
}

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ArtRegistrationViewController

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
        
        [self loadDataLevel2];
        
        [self loadDataLevel3];
        
        [self reSetStepIcon];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
    
        [self getWebService];

}

- (void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        
        [self loadCardCount];
        isPremiumPayment = NO;   // By CS RAI
        
}

- (void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
        
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

-(void)config{
        
        self.buttonDownload.layer.cornerRadius = 5.0f;
        self.buttonDownload.layer.masksToBounds = YES;
        self.textFieldCertificateNo.delegate = self;
        _textFieldCertificateNo.text = @"";

        //        level=1;
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.lblTitle.text=[self.titleString uppercaseString];// @"ART COLLECTION";
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        //        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        
}

-(void)setActivityIndicator {
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-15,
                                             [UIScreen mainScreen].bounds.size.height/3-15,
                                             30,
                                             30);
        [activityIndicator startAnimating];
        
        
        [activityIndicator removeFromSuperview];
        [self.tableView addSubview:activityIndicator];
        [self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
}

-(void)removeActivityIndicator {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}



-(void)loadDataLevel1 {
        
        level=1;
        //Header
        {
                arrHeaderTitle1=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle1 addObject:@"insurance companies will only pay an amount closer to the cost of materials - unless you could prove the higher value. Yet the disaster that took your art could easily claim your receipts or other documentation as well.\n\nRegister your fine art with Easton Art Galleries and your asset records that document value and ownership remain safe and available from any computer. Your online records can include a photo and supporting documents to permanently capture details for provenance, estate planning and asset statements"];
                [arrHeaderTitle1 addObject:@""];
                
                
        }
        
        //init data
        {
                arrData1=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"Title *"                                       forKey:@"title"];
                [dic setObject:@"Title *"                                       forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Artist *"                                      forKey:@"title"];
                [dic setObject:@"Artist *"                                      forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Category *"                                    forKey:@"title"];
                [dic setObject:@"Choose Category"                               forKey:@"title1"];
                [dic setObject:@"Sub Category"                                  forKey:@"title2"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Medium (Optional)"                             forKey:@"title"];
                [dic setObject:@"Medium (Optional)"                             forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"email_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Insurance (Optional)"                          forKey:@"title"];
                [dic setObject:@"Insurance (Optional)"                          forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Print Number (Optional)"                       forKey:@"title"];
                [dic setObject:@"Print Number (Optional)"                       forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
        }
        
        //Init category 1
        {
                arrCat1=[[NSMutableArray alloc]init];
                
             //   [arrCat1 addObject:@"Painting"];
        }
        
        //Init category 2
        {
                arrCat2=[[NSMutableArray alloc]init];
                
                [arrCat2 addObject:@"Oil"];
        }
        
        
}

-(void)loadDataLevel2{
        
//        level=2;
        //Header
        
        {
                arrHeaderTitle2=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle2 addObject:@"Dimensions"];
                [arrHeaderTitle2 addObject:@"Description and History. if known:"];
                [arrHeaderTitle2 addObject:@""];
                //                [arrHeaderTitle addObject:@""];
                
                
        }
        
        //init data
        {
                arrData2=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"Width *"                                       forKey:@"title"];
                [dic setObject:@"Width *"                                       forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Height *"                                      forKey:@"title"];
                [dic setObject:@"Height *"                                      forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Depth *"                                       forKey:@"title"];
                [dic setObject:@"Depth *"                                       forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Weight *"                                      forKey:@"title"];
                [dic setObject:@"Weight *"                                      forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"email_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@""                                              forKey:@"title"];
                [dic setObject:@""                                              forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Gallery or Agent Representing Owner:"          forKey:@"title"];
                [dic setObject:@"Gallery or Agent Representing Owner:"          forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Check to add \"Agent\" after owner's name"     forKey:@"title"];
                [dic setObject:@"Check to add \"Agent\" after owner's name"     forKey:@"msg"];
                [dic setObject:[NSNumber numberWithBool:NO]                     forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
        }
        
        
        [self.tableView reloadData];
}

-(void)loadDataLevel3{
        
//        level=3;
        
        //Header
        
        {
                arrHeaderTitle3=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle3 addObject:@"Supporting Files(Optional)"];
                [arrHeaderTitle3 addObject:@"Art for Sale - Details(Optional)"];
                [arrHeaderTitle3 addObject:@""];
                
                
        }
        // Photo
        
        arrMultipartPhoto = [[NSMutableArray alloc]init];
        
         NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:@"" forKey:@"path"];
        [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
        [arrMultipartPhoto addObject:dic];
        
        
        // Doc
        arrMultipartDoc = [[NSMutableArray alloc]init];
        NSMutableDictionary* dicDoc = [NSMutableDictionary dictionary];
        [dicDoc setObject:@"" forKey:@"path"];
        [dicDoc setObject:[[NSData alloc]init]           forKey:@"doc"];
        [arrMultipartDoc addObject:dicDoc];

        
//        //Multiple art
//        {
//                arrCertificates=[[NSMutableArray alloc]init];
//                
//                
//                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
//                [dic setObject:@""                                              forKey:@"path"];
//                [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
//                [arrCertificates addObject:dic];
//                
//                NSMutableDictionary* dic1 =[NSMutableDictionary dictionary];
//                [dic1 setObject:@""                                              forKey:@"path"];
//                [dic1 setObject:[[UIImage alloc] init]                           forKey:@"image"];
//                [arrCertificates addObject:dic1];
//               
//                
//        }

        
        //init data
        {
                arrData3=[[NSMutableArray alloc]init];
                
                
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        [dic setObject:@"$  Current Asking Price"                       forKey:@"title"];
                        [dic setObject:@"$  Current Asking Price"                       forKey:@"msg"];
                        [dic setObject:@""                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData3 addObject:dic];
                
        }
        
        
}


-(void)setLogoImage {
        
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

-(void)reSetStepIcon{
        
        self.imgStep.image=[UIImage imageNamed:(level==1 ? STEP_1_ICON : (level==2 ? STEP_2_ICON : STEP_3_ICON))];
        [self setDownloadCertificateViewPosition];
}


-(void)setDownloadCertificateViewPosition {

        if (level == 1) {
                
                self.viewDownloadcertificate.hidden = NO;
                self.constraintLevelViewTop.constant = 50;
        }
        if (level == 2) {
                
                self.viewDownloadcertificate.hidden = YES;
                self.constraintLevelViewTop.constant = 0;
        } else if (level == 3) {
                
                self.viewDownloadcertificate.hidden = YES;
                self.constraintLevelViewTop.constant = 0;
        }


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

-(void)cellRegister{
        
        [self.tableView registerClass:[UpdateProfileViewCell class]     forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[ArtRegisrtationTableViewCell1 class]           forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[AddArtViewCell2 class]           forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[RegistrationViewCell class]      forCellReuseIdentifier:CellIdentifier4];
        [self.tableView registerClass:[ArtRegistrationTableViewCell2 class]           forCellReuseIdentifier:CellIdentifier5];
        [self.tableView registerClass:[AddArtViewCell1 class]         forCellReuseIdentifier:CellIdentifier6];
        [self.tableView registerClass:[ArtRegistrationTableViewCell3 class]    forCellReuseIdentifier:CellIdentifier7];
        [self.tableView registerClass:[AddArtViewCell3 class]    forCellReuseIdentifier:CellIdentifier8];
        
        /*
         
         [self.tableView registerClass:[AddArtViewCell4 class]           forCellReuseIdentifier:CellIdentifier10];
         [self.tableView registerClass:[ArtDetailCell4 class]            forCellReuseIdentifier:CellIdentifier11];
         [self.tableView registerClass:[AddArtTableViewCell class]       forCellReuseIdentifier:CellIdentifier12];
         
         */
        UINib *contantsCellNib1 = [UINib nibWithNibName:NSStringFromClass([UpdateProfileViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        UINib *contantsCellNib2= [UINib nibWithNibName:NSStringFromClass([ArtRegisrtationTableViewCell1 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        UINib *contantsCellNib3= [UINib nibWithNibName:NSStringFromClass([AddArtViewCell2 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        UINib *contantsCellNib4 = [UINib nibWithNibName:NSStringFromClass([RegistrationViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        UINib *contantsCellNib5 = [UINib nibWithNibName:NSStringFromClass([ArtRegistrationTableViewCell2 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib5 forCellReuseIdentifier:CellIdentifier5];
        
        UINib *contantsCellNib6 = [UINib nibWithNibName:NSStringFromClass([AddArtViewCell1 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib6 forCellReuseIdentifier:CellIdentifier6];
        UINib *contantsCellNib7 = [UINib nibWithNibName:NSStringFromClass([ArtRegistrationTableViewCell3 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib7 forCellReuseIdentifier:CellIdentifier7];
        UINib *contantsCellNib8 = [UINib nibWithNibName:NSStringFromClass([AddArtViewCell3 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib8 forCellReuseIdentifier:CellIdentifier8];
        /*
         UINib *contantsCellNib5= [UINib nibWithNibName:@"UpdateProfileViewCell4" bundle:nil];
         [self.tableView registerNib:contantsCellNib5 forCellReuseIdentifier:CellIdentifier5];
         UINib *contantsCellNib10= [UINib nibWithNibName:@"AddArtViewCell4" bundle:nil];
         [self.tableView registerNib:contantsCellNib10 forCellReuseIdentifier:CellIdentifier10];
         UINib *contantsCellNib12= [UINib nibWithNibName:NSStringFromClass([AddArtTableViewCell class]) bundle:nil];
         [self.tableView registerNib:contantsCellNib12 forCellReuseIdentifier:CellIdentifier12];
         */
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemRemoveFromCollectionView:) name:@"didSelectItemRemoveFromCollectionView" object:nil];
}

-(void)createDatePicker:(BOOL)isList items:(NSArray*)list sender:(id)sender datePickerMode:(UIDatePickerMode) datePickerMode{
        
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
        
        CardDetailViewController*vc=GET_VIEW_CONTROLLER(kCardDetailViewController);
        vc.titleString=@"Your Cart";
        vc.from=@"back";
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
}

-(IBAction)dot:(id)sender{
        
        [[EAGallery sharedClass]popover:sender vc:self];
        
}

#pragma mark -Call WebService

-(void)artRegistrationWebService:(NSDictionary*)dic images:(NSArray*)images {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl,kURL_ART_REGISTRATION);
                
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
                                                                              images:images]; // Change
//                NSMutableData* httpBody=[Alert getBodyForMultipartDataWithPostString:postString images:images];
//                
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
                                                
                                                
                                                //                                                [Alert alertWithMessage:[result objectForKey:@"message"]
                                                //                                                             navigation:self.navigationController
                                                //                                                               gotoBack:NO animation:NO second:3.0];
                                                
                                                
                                                cat1=nil;
                                                cat2=nil;
                                                [self loadDataLevel1];
                                                [self loadDataLevel2];
                                                [self loadDataLevel3];
                                                [self reSetStepIcon];
                                                
                                                [self.tableView reloadData];
                                                
                                                NSLog(@"%@", result);
                                                [Alert alertWithMessage:[result objectForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:NO second:3.0];
                                                
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.1f * NSEC_PER_SEC),
                                                               dispatch_get_current_queue(), ^{
                                                                       
                                                                       BuyCertificateVC * vc = GET_VIEW_CONTROLLER(kBuyCertificateVC);
                                                                       vc.strRegId = [result objectForKey:@"reg_id"];
                                                                       vc.strFrom = @"back";
                                                                       MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                                                               });
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


#pragma mark - Calculate Custom Cell height

-(CGRect)getSizeFromText:(NSString*)text tableView:(UITableView*)tableView fontSize:(float)fontSize{
        
        text=IS_EMPTY(text) ? @"" : text;
        UIFont*font=[UIFont fontWithName:FONT_HELVETICA_NEUE_BOLD size:fontSize];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString : text
                                                                               attributes : @{
                                                                                              NSFontAttributeName : font
                                                                                              }];
        
        //its not possible to get the cell label width since this method is called before cellForRow so best we can do
        //is get the table width and subtract the default extra space on either side of the label.
        CGSize constraintSize = CGSizeMake(tableView.frame.size.width - CELL_CONTENT_LEFT_MARGIN*2-CELL_DESC_LEFT_MARGIN-CELL_DESC_RIGHT_MARGIN, MAXFLOAT);
        
        CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        
        
        return IS_EMPTY(text) ? CGRectZero : rect;
}

-(CGFloat)calculateCellHightWithIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView{
        
        int height=0;
        
        
        
        
        NSDictionary *item = [[arrSelections objectAtIndex:indexPath.row] copy];
        NSString* text1=@"";
        
        NSString* title=[item objectForKey:@"title"];
        text1=IS_EMPTY(title) ? @"" : title;
        
        
        CGRect rect = [self getSizeFromText:text1 tableView:tableView fontSize:13];
        rect.size.height=MIN(rect.size.height, CELL_DESC_HEIGHT_DEFAULT);
        float totalHeight=rect.size.height;
        
        //Add back in the extra padding above and below label on table cell.
        totalHeight = totalHeight +
        CELL_CONTENT_TOP_MARGIN+
        CELL_DESC_TOP_MARGIN+
        CELL_CONTENT_BOTTOM_MARGIN;
        
        height=totalHeight;
        //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
        //                height=rect.size.height;
        
        
        
        
        return height;
        
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        
        NSInteger section=0;
        switch (level) {
                case 1:
                        section=2;
                        break;
                case 2:
                        section=3;
                        break;
                case 3:
                        section=3;
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
                        switch (section) {
                                case 0:
                                        rows=6;
                                        break;
                                case 1:
                                        rows=1;
                                        break;
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (section) {
                                case 0:
                                        rows=4;
                                        break;
                                case 1:
                                        rows=3;
                                        break;
                                case 2:
                                        rows=1;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        switch (section) {
                                case 0:
                                        rows=2;
                                        break;
                                case 1:
                                case 2:
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
                        switch (indexPath.section) {
                                case 0:
                                case 1:
                                        
                                        height=44.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (indexPath.section) {
                                case 0:
                                case 1:
                                        height=44.0f;
                                        break;
                                case 2:
                                        height=44.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        switch (indexPath.section) {
                                case 0:
                                        
                                        height=44.0f;
                                        break;
                                case 1:
                                case 2:
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
                        switch (indexPath.section) {
                                case 0:
                                        switch (indexPath.row) {
                                                case 0:
                                                case 1:
                                                case 3:
                                                case 4:
                                                case 5:
                                                {
                                                        NSDictionary *item = [arrData1 objectAtIndex:indexPath.row];
                                                        
                                                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        
                                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                                        cell.txtName.text=[item objectForKey:@"value"];
                                                        cell.txtName.delegate=self;
                                                        cell.img.hidden=YES;
                                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                                        //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                                                        
                                                        
                                                        [Alert attributedString:cell.txtName
                                                                            msg:[item objectForKey:@"msg"]
                                                                          color:[item objectForKey:@"color"]];
                                                        
                                                        cell.txtName.tag=indexPath.row;
                                                        [cell.txtName addTarget:self
                                                                         action:@selector(textFieldDidChange:)
                                                               forControlEvents:UIControlEventEditingChanged];
                                                        
                                                        // cell.viContainerText.layer.borderWidth=1.5f;
                                                        // cell.viContainerText.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                                                        cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                                                        //Tint color
                                                        cell.txtName.tintColor=[UIColor blackColor];
                                                        cell.viContainerText.backgroundColor=[UIColor whiteColor];
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        return cell;
                                                        
                                                }
                                                        break;
                                                case 2:
                                                {
                                                        NSDictionary *item = [arrData1 objectAtIndex:indexPath.row];
                                                        
                                                        ArtRegisrtationTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        
                                                        cell.lblTitle.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                                        
                                                        cell.lblName1.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                                        cell.lblName2.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                                        
                                                        cell.img1.hidden=NO;
                                                        cell.img2.hidden=NO;
                                                        cell.lblSeparatorLine.hidden=YES;
                                                        
                                                        cell.lblName1.text= IS_EMPTY(cat1) ? [item objectForKey:@"title1"] : cat1;
                                                        cell.lblName2.text= IS_EMPTY(cat2) ? [item objectForKey:@"title2"] : cat2;
                                                        
                                                        cell.lblName1.textColor=[item objectForKey:@"color"];
                                                        cell.lblName2.textColor=[item objectForKey:@"color"];
                                                        
                                                        
                                                        cell.btnName1.tag=0;
                                                        cell.btnName2.tag=1;
                                                        
                                                        [cell.btnName1 addTarget:self
                                                                         action:@selector(chooseCat1:)
                                                               forControlEvents:UIControlEventTouchUpInside];
      //                                                [cell.btnName2 addTarget:self   action:@selector(chooseCat2:) forControlEvents:UIControlEventTouchUpInside];
                                                        
                                                        //Tint color
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        return cell;
                                                        
                                                }
                                                        break;
                                                default:
                                                        break;
                                        }
                                        break;
                                case 1:
                                {
                                        AddArtViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
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
                                {
                                        NSDictionary *item = [arrData2 objectAtIndex:indexPath.row];
                                        
                                        ArtRegistrationTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                        
                                        cell.txtLength.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                        cell.txtLength.text=[item objectForKey:@"value"];
                                        cell.txtLength.delegate=self;
                                        
                                        
                                        
//                                        [Alert attributedString:cell.txtLength
//                                                            msg:[item objectForKey:@"msg"]
//                                                          color:[item objectForKey:@"color"]];
                                        
                                        cell.txtLength.tag=indexPath.row;
                                        [cell.txtLength addTarget:self
                                                         action:@selector(textFieldDidChange:)
                                               forControlEvents:UIControlEventEditingChanged];
                                        
                                        cell.txtLength.autocorrectionType=UITextAutocorrectionTypeNo;
                                        //Tint color
                                        cell.txtLength.tintColor=[UIColor blackColor];
                                        cell.viContainerLength.backgroundColor=[UIColor whiteColor];
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        return cell;
                                        
                                }
                                        break;
                                case 1:
                                {
                                        switch (indexPath.row) {
                                                case 0:
                                                case 1:
                                                {
                                                        NSInteger rows=[tableView numberOfRowsInSection:0];
                                                        NSDictionary *item = [arrData2 objectAtIndex:indexPath.row+rows];
                                                        
                                                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        
                                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                                        cell.txtName.text=[item objectForKey:@"value"];
                                                        cell.txtName.delegate=self;
                                                        cell.img.hidden=YES;
                                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                                        //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                                                        
                                                        if(indexPath.row!=rows)
                                                                [Alert attributedString:cell.txtName
                                                                                    msg:[item objectForKey:@"msg"]
                                                                                  color:[item objectForKey:@"color"]];
                                                        
                                                        cell.txtName.tag=indexPath.row;
                                                        [cell.txtName addTarget:self
                                                                         action:@selector(textFieldDidChange:)
                                                               forControlEvents:UIControlEventEditingChanged];
                                                        
                                                        // cell.viContainerText.layer.borderWidth=1.5f;
                                                        // cell.viContainerText.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                                                        cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                                                        //Tint color
                                                        cell.txtName.tintColor=[UIColor blackColor];
                                                        cell.viContainerText.backgroundColor=[UIColor whiteColor];
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        return cell;

                                                }
                                                        break;
                                                case 2:
                                                {
                                                        ArtRegistrationTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier7 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        
                                                        NSInteger rows=[tableView numberOfRowsInSection:0];
                                                        NSDictionary* dic=[arrData2 objectAtIndex:indexPath.row+rows];
                                                        
                                                        NSNumber* isSelected=[dic objectForKey:@"value"];
                                                        
                                                        NSString* icon=[isSelected boolValue] ? SELECT_RADIO : UNSELECT_RADIO;
                                                        cell.img.image=[UIImage imageNamed:icon];
                                                        
                                                        NSString* name=[dic objectForKey:@"title"];
                                                        
                                                        
                                                        cell.lblTitle.text=name;
                                                        cell.lblTitle.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                                        cell.lblOptionTitle.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12];
                                                        
                                                        
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
                                        AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
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
                                        
                                      
                                        
                                        switch (indexPath.row) {
                                                        
                                                case 0:
                                                {
                                                        AddArtViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier8 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        cell.lblAddMore.text=@"BROWSE";
                                                        cell.btnChooseFile.tag = indexPath.row;
                                                        [cell.btnChooseFile addTarget:self action:@selector(chooseFile:) forControlEvents:UIControlEventTouchUpInside];
                                                        cell.btnAddMore.enabled=NO;
                                                        
                                                NSDictionary* dicPhoto=[arrMultipartPhoto objectAtIndex:0];
                                                        NSString * path = [dicPhoto objectForKey:@"path"];
                                                         cell.lblFileName.text=IS_EMPTY(path) ? @"Upload Photo": path;
                                                        
                                                        return cell;

                                                        
                                                }
                                                        break;
                                                case 1:
                                                {
                                                        AddArtViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier8 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        cell.lblAddMore.text=@"BROWSE";
                                                        cell.btnChooseFile.tag = indexPath.row;
                                                        [cell.btnChooseFile addTarget:self action:@selector(chooseFile:) forControlEvents:UIControlEventTouchUpInside];
                                                        cell.btnAddMore.enabled=NO;
                                                        
                                                        
                                                        NSDictionary* dicDoc=[arrMultipartDoc
                                                        objectAtIndex:0];
                                                        
                                                        NSString* path =
                                                        [dicDoc objectForKey:@"path"];
                                                        
                                                         cell.lblFileName.text=IS_EMPTY(path) ? @"Document": path;
                                                        
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
                                        NSDictionary *item = [arrData3 objectAtIndex:indexPath.row];
                                        
                                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                        cell.txtName.text=[item objectForKey:@"value"];
                                        cell.txtName.delegate=self;
                                        cell.img.hidden=YES;
                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                                        
                                        [Alert attributedString:cell.txtName
                                                            msg:[item objectForKey:@"msg"]
                                                          color:[item objectForKey:@"color"]];
                                        
                                        cell.txtName.tag=indexPath.row;
                                        [cell.txtName addTarget:self
                                                         action:@selector(textFieldDidChange:)
                                               forControlEvents:UIControlEventEditingChanged];
                                        
                                        // cell.viContainerText.layer.borderWidth=1.5f;
                                        // cell.viContainerText.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                                        cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                                        //Tint color
                                        cell.txtName.tintColor=[UIColor blackColor];
                                        cell.viContainerText.backgroundColor=[UIColor whiteColor];
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        return cell;
                                        
                                }
                                        break;
                                case 2:
                                {
                                        AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
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
        
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        switch (level) {
                        
                case 2:
                {
                        
                        switch (indexPath.section) {
                                case 1:
                                        switch (indexPath.row) {
                                                case 2:
                                                {
                                                        NSInteger rows=[tableView numberOfRowsInSection:0];
                                                        NSDictionary* dic=[arrData2 objectAtIndex:indexPath.row+rows];
                                                        
                                                        NSNumber* isSelected=[dic objectForKey:@"value"];
                                                        [dic setValue:[NSNumber numberWithBool:![isSelected boolValue]] forKey:@"value"];
                                                        
                                                        
                                                        [Alert reloadSection:indexPath.section table:tableView];
                                                        
                                                        
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
        
}


#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        NSString *header  = @"";
        
        switch (level) {
                case 1:
                        header=[arrHeaderTitle1 objectAtIndex:section];
                        break;
                        
                case 2:
                        header=[arrHeaderTitle2 objectAtIndex:section];
                        break;
                        
                case 3:
                        header=[arrHeaderTitle3 objectAtIndex:section];
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
        
        myLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:13];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textAlignment=NSTextAlignmentLeft;
        myLabel.textColor=[UIColor redColor];
        myLabel.backgroundColor=[UIColor clearColor];
        myLabel.numberOfLines=10;
        [headerView addSubview:myLabel];
        
        float height=0;
        switch (level) {
                case 1:
                        switch (section) {
                                case 0:
                                        myLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                        myLabel.numberOfLines=12;
                                        myLabel.textColor=[UIColor grayColor];
                                        height=140;
                                
                                        break;
                                case 1:
                                        height=34;
                                        break;
                                default:
                                        break;
                        }
                        break;
                case 2:
                        switch (section) {
                                case 0:
                                case 1:
                                case 2:
                                        height=14;
                                        break;
                                default:
                                        break;
                        }
                        break;
                case 3:
                        switch (section) {
                                        
                                case 0:
                                case 1:
                                case 2:
                                        height=14;
                                        break;
                                default:
                                        break;
                        }
                        break;
                        
                default:
                        break;
        }
        myLabel.frame = CGRectMake(15, 8, tableView.frame.size.width-23, height);
        
        /*
         if(level==2){
         NSInteger l1=myLabel.text.length;
         NSString* text2=@" *";
         myLabel.text=[myLabel.text stringByAppendingString:text2];
         NSInteger l2=text2.length;
         
         UIFont *font = [UIFont fontWithName:FONT_DOSIS_REGULAR size:15];
         NSDictionary *fontDic = [NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
         NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:myLabel.text attributes:fontDic];
         
         [string addAttribute:NSForegroundColorAttributeName value:myLabel.textColor range:NSMakeRange(0,l1)];
         [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(l1,l2)];
         myLabel.attributedText = string;
         }
         
         if(level==3 && section==5){
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
         */
        
        return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        NSInteger height=0;
        
        switch (level) {
                case 1:
                        switch (section) {
                                case 0:
                                        height=150.0f;
                                        break;
                                case 1:
                                        height=30.0f;
                                        break;
                                case 2:
                                       // height=30.0f;
                                        break;
                                default:
                                        break;
                        }
                        
                        break;
                case 2:
                        switch (section) {
                                case 0:
                                case 1:
                                case 2:
                                        height=30.0f;
                                        break;
                                default:
                                        break;
                        }
                        
                        break;
                case 3:
                        
                        switch (section) {
                                case 0:
                                case 1:
                                case 2:
                                        height=30.0f;
                                        
                                        
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
        /*
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
         */
        
        
        if(!isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 216);
        }
        
        
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight = YES;
        
        return YES;
        
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
        [textField resignFirstResponder];
        
        NSIndexPath *indexPathOriginal =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
        switch (level) {
                case 1:
                {
//                        UpdateProfileViewCell * cell;
                        RegistrationViewCell * cell;
                        
                        switch (indexPathOriginal.row) {
                                case 0:
                                        if(!IS_EMPTY(textField.text)) {
                                                
                                                BOOL isName = [Alert validationString:textField.text];
                                                
                                                if(!isName){
                                                        [Alert alertWithMessage:@"Invalid title ! Please enter valid title."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{
                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                                        [cell.txtName becomeFirstResponder];
                                                        
                                                }
                                        }
                                        break;
                                case 1:
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isName=[Alert validationString:textField.text];
                                                
                                                if(!isName){
                                                        [Alert alertWithMessage:@"Invalid artist name ! Please enter valid artist name."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{
                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+2 inSection:indexPathOriginal.section]];
                                                        [cell.txtName becomeFirstResponder];
                                                        
                                                }
                                        }
                                        break;
                                case 3:
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isEmail=[Alert validationString:textField.text];
                                                
                                                if(!isEmail){
                                                        [Alert alertWithMessage:@"Invalid medium ! Please enter valid medium."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{
                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                                        [cell.txtName becomeFirstResponder];
                                                        
                                                }
                                        }
                                        break;
                                case 4:
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isMobile=[Alert validationString:textField.text];
                                                
                                                if(!isMobile){
                                                        [Alert alertWithMessage:@"Invalid insurance ! Please enter valid insurance."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{
                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                                        [cell.txtName becomeFirstResponder];
                                                        
                                                }
                                        }
                                        break;
                                case 5:
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isMobile=[Alert validationString:textField.text];
                                                
                                                if(!isMobile){
                                                        [Alert alertWithMessage:@"Invalid print number ! Please enter print number."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{
//                                                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:indexPathOriginal.section];
//                                                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                    
                                                }
                                        }
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                        
                }
                        break;
                        
                case 2:
                {
                        
                        
                        switch (indexPathOriginal.section) {
                                case 0:
                                        
                                        if(!IS_EMPTY(textField.text)){
                                                
                                                
                                                BOOL isNumber=[Alert validateNumber:textField.text];
                                                
                                                if(!isNumber){
                                                        [Alert alertWithMessage:@"Invalid lenth ! Please enter valid lenth."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{
                                                        if(indexPathOriginal.row==3){
                                                                
                                                                RegistrationViewCell * cell;
                                                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPathOriginal.section+1]];
                                                                [cell.txtName becomeFirstResponder];
                                                        }
                                                        else{
                                                                ArtRegistrationTableViewCell2 * cell;
                                                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                                                [cell.txtLength becomeFirstResponder];
                                                        }
                                                }
                                        }
                                        break;
                                case 1:
                                        
                                        if(!IS_EMPTY(textField.text)){
                                                RegistrationViewCell * cell;
                                                
                                                if(indexPathOriginal.row==1){
                                                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:indexPathOriginal.section];
                                                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                }
                                                else{
                                                
                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                                        [cell.txtName becomeFirstResponder];
                                                }
                                                
                                                
                                                
                                                
                                        }
                                        break;
                                        
                                default:
                                        break;
                        }
                        
                        
                }
                        break;
                        
                        
                case 3:
                {
                        switch (indexPathOriginal.section) {
                                case 1:
                                        
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isNumber=[Alert validateNumber:textField.text];
                                                
                                                if(!isNumber){
                                                        [Alert alertWithMessage:@"Invalid price ! Please enter valid price."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                        [textField becomeFirstResponder];
                                                        
                                                }
                                                else{

                                                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:indexPathOriginal.section];
                                                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height+216);
                
        }
        
        isUpdateHeight = NO;
        self.tableView.scrollEnabled = YES;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender{
        
        //        isUpdate=YES;
        UITextField* txt=(UITextField*)sender;
        
        NSIndexPath *indexPath =[Alert getIndexPathWithTextfield:txt table:self.tableView];
        //
        switch (level) {
                case 1:
                {
                        BOOL isValid=NO;
                        //
                        
                        switch (indexPath.row) {
                                case 0:
                                case 1:
                                case 3:
                                case 4:
                                case 5:
                                        isValid=[Alert validationString:txt.text];
                                        break;
                                        
                                default:
                                        isValid=YES;
                                        break;
                        }
                        
                        
                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic=[arrData1 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                case 2:
                {
                        BOOL isValid=NO;
                        //
                        
                         switch (indexPath.section) {
                                 case 0:
                                         isValid=[Alert validateNumber:txt.text];
                                         break;
                                 case 1:
                                         isValid=[Alert validationString:txt.text];
                                         break;
                         
                                 default:
                                         isValid=YES;
                                         break;
                         }
                        
                        
                        
                        
                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                        
                        
                        NSInteger rows=[self.tableView numberOfRowsInSection:0];
                        
                        NSMutableDictionary* dic=[arrData2 objectAtIndex:indexPath.section==1 ? txt.tag+rows: txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                case 3:
                {
                        BOOL isValid=NO;
                        //
                        
                        switch (indexPath.section) {
                                case 1:
                                        isValid=[Alert validateNumber:txt.text];
                                        break;
                                        
                                default:
                                        isValid=YES;
                                        break;
                        }
                        
                        
                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic=[arrData3 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                        
                        
                default:
                        break;
        }
        
}



#pragma mark - DatePicker Custom Delegate methods

-(void)selectDateFromDatePicker:(NSDate *)date sender:(id)sender {
        
        [self removeDatePicker];
        NSLog(@"Selected Date->%@",date);
        
        
        //        lblAge.text=[NSString stringWithFormat:@"+%d",[Alert calculateAge:date]];
        
        
        //        txtDOB.text=[Alert getDateWithString:[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date]
        //                                   getFormat:GET_FORMAT_TYPE
        //                                   setFormat:SET_FORMAT_TYPE1];
        
        
        
        
        
        
        
        
        
        [Alert reloadSection:5 table:self.tableView];
        //[txtCountry becomeFirstResponder];
}

-(void)cancelDateFromDatePicker:(id)sender {
        
        [self removeDatePicker];
        // [txtCountry becomeFirstResponder];
}

#pragma mark - Custom List Item Picker Delegate Methods

-(void)selectItemFromList:(NSString *)item sender:(id)sender{
        
        NSLog(@"Selected item->%@",item);
        UIButton* button=(UIButton*)sender;
//        selectedCountry=item;
        
        [self removeDatePicker];
        
        
        
        //        NSLog(@"Country Key->[%@]",[Alert getSelectedCountryKeyWithValue:selectedCountry]);
        //        NSLog(@"Country Value->[%@]",[Alert getSelectedCountryValueWithKey:[Alert getSelectedCountryKeyWithValue:selectedCountry]]);
        
        
        NSIndexPath *indexPath = [Alert getIndexPathWithButton:button table:self.tableView];
        
        switch (button.tag) {
                case 0:
                {
//                        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag];
//                        
//                        [dic setObject:selectedCountry forKey:@"value"];
                        cat1=item;
                }
                        break;
                case 1:
                {
                        
                        cat2=item;
//                        NSInteger row=[self tableView:self.tableView numberOfRowsInSection:0];
//                        NSMutableDictionary* dic=[arrData objectAtIndex:button.tag+row];
//                        
//                        [dic setObject:selectedCountry forKey:@"value"];
                        
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
        
}




#pragma mark - Validate Levels

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

-(NSArray*)matchSelectionWithArray:(NSArray*)list{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value = 1"];
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

-(BOOL)isLevel1 {
        
        BOOL isValid=NO;
        
        NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* index1=[NSIndexPath indexPathForRow:1 inSection:0];
        
        if(!IS_EMPTY([[arrData1 objectAtIndex:0] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:1] objectForKey:@"value"]) &&
           !IS_EMPTY(cat1)/* &&  !IS_EMPTY(cat2)*/) {
                BOOL isTitle    =[Alert validationString:[[arrData1 objectAtIndex:0] objectForKey:@"value"]];
                BOOL isArtist   =[Alert validationString:[[arrData1 objectAtIndex:1] objectForKey:@"value"]];
                
                
                if(!isTitle){
                        [Alert alertWithMessage:@"Invalid title ! Please enter valid title."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        
                }
                else if(!isArtist){
                        [Alert alertWithMessage:@"Invalid artist name ! Please enter valid artist name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else
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
        
        BOOL isValid=NO;
        
        NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:1];
        
        if(!IS_EMPTY([[arrData2 objectAtIndex:0] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData2 objectAtIndex:1] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData2 objectAtIndex:2] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData2 objectAtIndex:3] objectForKey:@"value"]) ) {
                
                //                NSArray* arrCer= [self matchPathWithArray:arrCertificates];
                
                //                if (arrCer.count<2){
                //                        [Alert alertWithMessage:@"Missing file ! Please choose file ."
                //                                     navigation:self.navigationController
                //                                       gotoBack:NO animation:YES second:3.0];
                //                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                //                }
                //                else
                //                {
                isValid=YES;
                //                }
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

-(BOOL)isLevel3 {
        
        BOOL isValid=NO;
        
        if(!IS_EMPTY([[arrData3 objectAtIndex:0] objectForKey:@"value"]))
        {
                BOOL isPrice = [Alert validateNumber:[[arrData3 objectAtIndex:0] objectForKey:@"value"]];
                
                if(isPrice) {
                        
                        isValid = YES;

                }
                else{
                        
                        [Alert alertWithMessage:@"Invalid price ! Please enter valid price."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];

                }

        }
        else {
                isValid = YES;
        }
        
        
        return isValid;
}

-(BOOL)isValidateLevel {
        
        BOOL isValid=NO;
        
        
        switch (level) {
                case 1:
                        isValid=[self isLevel1];
            //            isValid = true;
                        break;
                case 2:
                        isValid=[self isLevel2];
                   //     isValid = true;
                        break;
                case 3:
                        isValid=[self isLevel3];
                     //   isValid = true;
                        break;
                        
                default:
                        break;
        }
        
        
        return isValid;
}


#pragma mark - Target Support methods

/*
-(void)addMoreFile{
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:@""                                              forKey:@"path"];
        [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
        [arrMultipleArt addObject:dic];
        
        switch (level) {
                case 1:
                {
                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                        break;
                default:
                        break;
        }
        
        
        
}


-(void)removeFile:(NSInteger)index{
        
        [arrMultipleArt removeObjectAtIndex:index];
}
*/

-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker

{
        documentPicker.delegate = self;
        [self presentViewController:documentPicker animated:YES completion:nil];
}



#pragma mark - Target Methods

-(IBAction)chooseCat1:(id)sender{
        
        [self.view endEditing:YES];
        [self setDefaultTableHeight];
        if(arrCat1.count)
                [self createDatePicker:YES items:arrCat1 sender:sender datePickerMode:nil];
}

-(IBAction)chooseCat2:(id)sender {
        
        [self.view endEditing:YES];
        [self setDefaultTableHeight];
        
        if(arrCat2.count)
                [self createDatePicker:YES items:arrCat2 sender:sender datePickerMode:nil];
}


-(IBAction)chooseFile:(id)sender {
        
        UIButton* button=(UIButton*)sender;
        
        
        if (button.tag == 0) {
                
                
                indexPathForMultiplart = [Alert getIndexPathWithButton:button table:self.tableView];
                
                __weak __typeof(self)weakSelf = self;
                
                [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
                        
                        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                        cropController.delegate = self;
                        [self presentViewController:cropController animated:YES completion:nil];
                        
                }];
                
                
                
        } else if(button.tag == 1) {
        
                    indexPathForMultiplart = [Alert getIndexPathWithButton:button table:self.tableView];
                
                NSArray *types = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeSpreadsheet,(NSString*)kUTTypePresentation,];
                
                //Create a object of document picker view and set the mode to Import
                UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
                
                
                //Set the delegate
                docPicker.delegate = self;
                //present the document picker
                [self presentViewController:docPicker animated:YES completion:nil];

        }
        
        /*
        UIDocumentPickerViewController* importMenu =
        [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                               inMode:UIDocumentPickerModeImport];
        
        importMenu.delegate = self;
        [self presentViewController:importMenu animated:YES completion:nil];
        */
        
        
}

#pragma mark - UIDocumentPickerDelegate -

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
        if (controller.documentPickerMode == UIDocumentPickerModeImport)
        {
                
                // Condition called when user download the file
                NSData *fileData = [NSData dataWithContentsOfURL:url];
                // NSData of the content that was downloaded - Use this to upload on the server or save locally in directory
                
                NSString *strFileName = url.absoluteString;;
                
                __weak __typeof(self)weakSelf = self;
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                
                dic = [arrMultipartDoc objectAtIndex:0];
                
                [dic setObject:strFileName forKey:@"path"];
                [dic setObject:fileData forKey:@"doc"];
                
                [Alert reloadSection:indexPathForMultiplart.section table:weakSelf.tableView];
                
                
                //Showing alert for success
                dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *alertMessage = [NSString stringWithFormat:@"Successfully downloaded file %@", [url lastPathComponent]];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"UIDocumentView"
                                                              message:alertMessage
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                });
        }else  if (controller.documentPickerMode == UIDocumentPickerModeExportToService)
        {
                // Called when user uploaded the file - Display success alert
                dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *alertMessage = [NSString stringWithFormat:@"Successfully uploaded file %@", [url lastPathComponent]];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"UIDocumentView"
                                                              message:alertMessage
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                });
        }
        
}

/**
 *  Delegate called when user cancel the document picker
 *
 *  @param controller - document picker object
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
        
}

/*
-(IBAction)addMore:(id)sender {
        
        UIButton* button=(UIButton*)sender;
        
        NSIndexPath *indexPath =[Alert getIndexPathWithButton:button table:self.tableView];
        switch (level) {
                case 1:
                        switch (indexPath.section) {
                                case 1:
                                {
                                        
                                        if(indexPath.row==0)
                                                [self addMoreFile];
                                        else
                                                [self removeFile:indexPath.row];
                                }
                                        break;
                                                                                break;
                                        
                                default:
                                        break;
                        }
                        break;
                default:
                        break;
        }
        
        
        
        [Alert reloadSection:indexPath.section table:self.tableView];
        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

*/

-(IBAction)backMove:(id)sender{
        
        if(level<=1) return;
        level-=1;
        
        [self reSetStepIcon];
        
        [self.tableView reloadData];
}

-(IBAction)next:(id)sender{
        
        [self.view endEditing:YES];
        if(![self isValidateLevel]) return;
        
        if(level==3){
                
               [self  artRegistration];

//                BuyCertificateVC* vc = GET_VIEW_CONTROLLER(kBuyCertificateVC);
//                vc.strFrom = @"back";
//                MOVE_VIEW_CONTROLLER(vc, YES);

        }
        if(level>=3) return;
        level += 1;
        
        [self reSetStepIcon];
        [self.tableView reloadData];
        
}

-(void)artRegistration {
        
        /*
         {
         "user_id": "92",
         "title": "title",
         "artist": "artist",
         "category1": "category1",
         "category2": "category2",
         "medium": "medium",
         "insurance": "insurance",
         "print_number": "print_number",
         "width": "10",
         "height": "10",
         "depth": "10",
         "weight": "10",
         "description_history": "description_history",
         "representing_owner": "representing_owner",
         "agent": "10",
         "asking_price": "110"
         }
         */
        //document,photo
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:[[EAGallery sharedClass] memberID] forKey:@"user_id"];
        
        //Step 1 :
        [dic setObject:[[arrData1 objectAtIndex:0] objectForKey:@"value"] forKey:@"title"];
        [dic setObject:[[arrData1 objectAtIndex:1] objectForKey:@"value"] forKey:@"artist"];
        [dic setObject:cat1 forKey:@"category1"];
       // [dic setObject:cat2 forKey:@"category2"];
        
        [dic setObject:[[arrData1 objectAtIndex:3] objectForKey:@"value"] forKey:@"medium"];
        [dic setObject:[[arrData1 objectAtIndex:4] objectForKey:@"value"] forKey:@"insurance"];
        [dic setObject:[[arrData1 objectAtIndex:5] objectForKey:@"value"] forKey:@"print_number"];
        
        
        //Step 2 :
        [dic setObject:[[arrData2 objectAtIndex:0] objectForKey:@"value"] forKey:@"width"];
        [dic setObject:[[arrData2 objectAtIndex:1] objectForKey:@"value"] forKey:@"height"];
        [dic setObject:[[arrData2 objectAtIndex:2] objectForKey:@"value"] forKey:@"depth"];
        [dic setObject:[[arrData2 objectAtIndex:3] objectForKey:@"value"] forKey:@"weight"];
        [dic setObject:[[arrData2 objectAtIndex:4] objectForKey:@"value"] forKey:@"description_history"];
        [dic setObject:[[arrData2 objectAtIndex:5] objectForKey:@"value"] forKey:@"representing_owner"];
        
        NSNumber* agent=[[arrData2 objectAtIndex:6] objectForKey:@"value"];
        [dic setObject:[agent stringValue] forKey:@"agent"];
        
        
        
        //Step 3 :
        [dic setObject:[[arrData3 objectAtIndex:0] objectForKey:@"value"] forKey:@"asking_price"];
        
        
        
        
        NSLog(@"%@",dic);
        
        //imagename
        //imagedata
        //imagekey
        
        
        NSMutableArray* arrImages=[[NSMutableArray alloc]init];

        /*
        NSArray* arrArts= [self matchPathWithArray:arrCertificates];
        NSMutableArray* arrImages=[[NSMutableArray alloc]init];
        int i=1;
        for (NSDictionary* dic in arrArts) {
                
                UIImage* image=[dic objectForKey:@"image"];
                NSString* fileName=[dic objectForKey:@"path"];
                NSData* imageData =image ? UIImageJPEGRepresentation(image, 90) : nil;
                
                if(imageData && i==1){
                        NSMutableDictionary* imageDic=[NSMutableDictionary dictionary];
                        [imageDic setObject:imageData           forKey:@"imagedata"];
                        [imageDic setObject:fileName            forKey:@"imagename"];
                        [imageDic setObject:@"photo"            forKey:@"imagekey"];
                        [arrImages addObject:imageDic];
                }
                i++;
        }
        
        */
        
       //  NSArray* arrImage = [self matchPathWithArray:arrMultipartPhoto];
        NSDictionary *dict = [arrMultipartPhoto objectAtIndex:0];
        // NSLog(@"%@",arrImages);
        UIImage* image = [dict objectForKey:@"image"];
        NSString* fileName=[dict objectForKey:@"path"];

        NSData* imageData =image ? UIImageJPEGRepresentation(image, 90) : nil;
        if(imageData)
        {
                NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
                [imageDic setObject:imageData           forKey:@"imagedata"];
                [imageDic setObject:fileName            forKey:@"imagename"];
                [imageDic setObject:@"photo"            forKey:@"imagekey"];
                [arrImages addObject:imageDic];
        }
        
        
        

        NSDictionary *dictDoc = [arrMultipartDoc objectAtIndex:0];
        // NSLog(@"%@",arrImages);
        NSData* doc = [dictDoc objectForKey:@"doc"];
        NSString* fileNameDoc = [dictDoc objectForKey:@"path"];

        if(doc)
        {
                NSMutableDictionary* imageDic = [NSMutableDictionary dictionary];
                [imageDic setObject:doc           forKey:@"imagedata"];
                [imageDic setObject:fileNameDoc            forKey:@"imagename"];
                [imageDic setObject:@"document"            forKey:@"imagekey"];
                [arrImages addObject:imageDic];
        }

        
        
        
        [self artRegistrationWebService:[dic mutableCopy] images:arrImages.count? arrImages : nil];
}


- (IBAction)buttonDownloadTapped:(id)sender {
        
         [self.view endEditing: YES];
        
        if(self.textFieldCertificateNo.text.length !=0) {
                
                [self getCertificate];
        }else {
                
                // Show error
               
                [Alert alertWithMessage:@" Please enter certificate no."
                             navigation:self.navigationController
                               gotoBack:NO animation:YES second:3.0];
                
        }
}

#pragma mark - Call webservices for download Certificate -

-(void)getCertificate {
        
        [self setActivityIndicator];
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_GET_CERTIFICATE);
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:_textFieldCertificateNo.text forKey:@"certificate_no"];//{"page_url":"about-us"}
                
                
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
                                        
                                        NSString *strImageUrl = [result objectForKey:@"image"];
                                        
                                        
                                        [strImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                        NSURL *imgURL = [NSURL URLWithString:strImageUrl];
                                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                                
                                                if (!connectionError) {
                                                        
                                                        UIImage *img = [[UIImage alloc] initWithData:data];
                                                        // pass the img to your imageview
                                                        self.textFieldCertificateNo.text = @"";
                                                        
                                                        [self showImageForDownload:img];
                                                }else{
                                                        NSLog(@"%@",connectionError);
                                                        self.textFieldCertificateNo.text = @"";
                                                        [Alert alertWithMessage:@"Something went wrong ! Please try later."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES second:3.0];
                                                }
                                        }];
                                        
                                        [self removeActivityIndicator];
                                        
                                }
                                else if (error.boolValue) {
                                        
                                        [self removeActivityIndicator];
                                        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@""
                                                                                             message:[result objectForKey:@"msg"]
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"OK"
                                                                                   otherButtonTitles:nil];
                                        [notPermitted show];
                                        
                                }
                                
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

//   Show Certificate Image For Download

-(void)showImageForDownload :(UIImage *)image {
        
        IDMPhoto *photo = [IDMPhoto photoWithImage:image];
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo] animatedFromView:self.view];
        [self presentViewController:browser animated:YES completion:nil];
}

-(void)setDefaultTableHeight {
        
        [self.view endEditing:YES];
        if(isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height+216);
                
        }
        
}


#pragma mark - Cropper Delegate Method -

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
        
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(0, 100.0, 40.0, 40.0) completion:^{
                __weak __typeof(self)weakSelf = self;
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                
                dic = [arrMultipartPhoto objectAtIndex:0] ;
                
                [dic setObject:[Alert getNameForImage] forKey:@"path"];
                [dic setObject:image forKey:@"image"];
                
                [Alert reloadSection:indexPathForMultiplart.section table:weakSelf.tableView];
        }];
        
}


#pragma mark -Call WebService

-(void)getWebService{
    
    const char* className=[NSStringFromSelector(_cmd) UTF8String];
    
    dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
    dispatch_async(myQueue, ^{
        
        
        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ArtCategory);
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
        [data setObject:@"category" forKey:@"page"];
        //                NSMutableDictionary* data=[NSMutableDictionary dictionary];
        //                [data setObject:@"15" forKey:@"limit"];
        
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
                    
                    resPonsedataArray = (NSDictionary*)[result valueForKey:self.dataAccesskey];
                    
                    if([resPonsedataArray isKindOfClass:[NSArray class]]){
                        // [self alerWithMessage:[webServiceDic valueForKey:@"msg"]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.arrArtCategoryList=[resPonsedataArray mutableCopy];
                            
                            [self setCategoryData];
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

-(void)setCategoryData{
    
    for (NSDictionary *data in self.arrArtCategoryList){
        
        [arrCat1 addObject:data[@"category_name"]];
    }
    
}


@end