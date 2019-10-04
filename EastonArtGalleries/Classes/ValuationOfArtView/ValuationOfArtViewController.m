//
//  ValuationOfArtViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 01/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "ValuationOfArtViewController.h"
#import "UpdateProfileViewCell.h"
#import "AddArtViewCell3.h"
#import "AddArtViewCell2.h"
#import "AddArtViewCell1.h"
#import "RegistrationViewCell.h"
#import "PopFilterViewCell.h"
#import "ValuationPremiumButtonTVCell.h"
#import "ValuationOfArtWorkClickHereTVCell.h"
#import "ArtCategoryViewCell.h"
#import "AppDelegate.h"
#import "TOCropViewController.h"

#define kPayPalEnvironment PayPalEnvironmentProduction

#define PAYPAL_TRANSACTION_MEMBER_ID            @"member"
#define PAYPAL_TRANSACTION_CURRENCY             @"currency"
#define PAYPAL_TRANSACTION_ID                   @"transaction_id"
#define PAYPAL_TRANSACTION_TYPE                 @"transaction_type"
#define PAYPAL_TRANSACTION_AMOUNT               @"transaction_amount"
#define PAYPAL_TRANSACTION_STATUS               @"transaction_status"
#define PAYPAL_TRANSACTION_CARD                 @"transaction_card"
#define PAYPAL_TRANSACTION_BILLING_FIRST_NAME   @"billing_firstName"
#define PAYPAL_TRANSACTION_BILLING_LAST_NAME    @"billing_lastName"
#define PAYPAL_TRANSACTION_BILLING_ADDRESS      @"billing_address"
#define PAYPAL_TRANSACTION_BILLING_CITY         @"billing_city"
#define PAYPAL_TRANSACTION_BILLING_STATE        @"billing_state"
#define PAYPAL_TRANSACTION_BILLING_POST_CODE    @"billing_post_code"
#define PAYPAL_TRANSACTION_BILLING_COUNTRY      @"billing_country"
#define PAYPAL_TRANSACTION_DESCRIPTION          @"description"
#define PAYPAL_TRANSACTION_TIME                 @"added_on"
#define PAYPAL_TRANSACTION_METHOD               @"transaction_method"


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




@interface ValuationOfArtViewController ()<UITableViewDelegate,UITableViewDataSource,FPPopoverControllerDelegate,buttontitledelgate,PopupDelegate,UITextFieldDelegate,PickerViewDelegate, TTTAttributedLabelDelegate, TransactionDeletgate, TOCropViewControllerDelegate>
{
        DataBaseHandler *dataManager;
        UIView* cardViewGlobal;
        UIView* cardCountViewGlobal;
        int level;
        
        NSMutableArray* arrData1;
        NSMutableArray* arrData2;
        NSMutableArray* arrData2_2;
        NSMutableArray* arrData2_3;
        
        NSMutableArray* arrData3;
        NSMutableArray* arrHeaderTitle1;
        NSMutableArray* arrHeaderTitle2;
        NSMutableArray* arrHeaderTitle3;
        NSMutableArray* arrMultipleArt;
        NSMutableArray* arrCertificates;
        NSMutableArray* arrSelections;
        NSMutableArray* arrSelectionsForLevel2;
        
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        
        BOOL isUpdateHeight;
        BOOL isUpdate;
        BOOL isPremium;
        BOOL isThisYourArt;
        BOOL isTheArtAppraisedInThePast; // Level 3 section 5th
        NSIndexPath *indexPathForMultipleArt;

}

@property (nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property(nonatomic, strong) AppDelegate* appDelegate;


@end

@implementation ValuationOfArtViewController

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
static NSString *CellIdentifier13 = @"Cell13";
static NSString *cellIdentifier14 = @"Cell14";
static NSString *cellIdentifier15 = @"Cell15";



#pragma mark  App delegate

- (AppDelegate *)appDelegate {
        
        return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - View controller life cicle

- (void)viewDidLoad {
        
        [super viewDidLoad];
        
        [self setStaticText];
        
        [self defaultPropertyInitializationForLevel_2];  // property initialization for Level 2
        
        [self cellRegister];
        
        [self loadDataLevel1];
        
        [self loadDataLevel2];
        
        [self loadDataLevel2_2];
        
        [self loadDataLevel3];
        
        [self reSetStepIcon];
        
        [self configPayPal];
        
        [self config];
        
        [self setLogoImage];
        
        [self rightNavBarConfiguration];
        
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
        
}

-(void)setStaticText {
        
        self.strTermsOfServices = @"GENERAL TERMS AND CONDITIONS \n\n The information provided in the evaluation by Easton Galleries is to be considered for informational purposes only. It is NOT to be considered a formal,written appraisal for legal, insurance or other reasons.The evaluation given by Easton Galleries is based upon:\n 1) Information provided by the client\n 2) Current records and information available in online and written sources relative to the artist, sales records, auction records and any other information to be deemed relevant at the sole determination of Easton Galleries. If the client needs a legal, written appraisal, this must be conducted by a state licensed appraiser of the client’s choosing.The client ag The client agrees to indemnify and hold harmless Easton Galleries, its employees, heirs and assigns from any liability as the result of errors, omissions or opinions expressed in the provided reports.The client agrees that any and all final decisions about the value of a work of art are made at the sole discretion of the artist or owner of said work.";
        
        self.strTermsOfServicesNonPremium = @"BASIC EVALUATION \n\n Ideal for artists who would like to know how to best price their work. Ideal for the work of other artists for whom there are not any or few online records of sales.The basic are evaluation will provide the following:\n 1. For artists who are evaluating the prices of their own work: Recommended pricing strategies,recommended marketing vehicles and sales strategies \n 2. A comparison of the prices of similar work from other artists Also ideal for: For a collector who is evaluating the work of an artist without published sales and gallery records, a suggested value of the artwork. This will be based upon many factors, including but not limited to the price of similar works by emerging artists, the price of decorative art sold by online sources, general price information existing in the current art market.";
        
        self.strTermsOfServicesPremium = @"DELUXE EVALUATION\n\n Ideal for art by artists with an established record or sales, either online, at retail galleries or for which there are public auction records or other records of sales.The deluxe evaluation will provide the following:\n 1. An approximate valuation of the work, based upon the following;\n A. Public auction records \n B. Current gallery prices,both asking prices and selling prices \n C. Historical market and growth factors as may be relevant, to be determined by Easton Galleries.\n 2. A report showing any past sales of the artist's work or that of similar artists, culled from sales, research and auction databases \n 3. A report showing current pieces of work available for sale either at galleries, online auctions or websites, if applicable.";
        
}


-(void)defaultPropertyInitializationForLevel_2 {
        
        
        //        self.strArtistName = @"";
        //        self.strArtWorkSize = @"";
        //        self.strArtworkMedium = @"";
//                self.strDateArtWorkCompleted = @"";
        
        
        self.strPurchaseTime = @"";
        self.strPurchasePlace = @"";
        self.strPurchasePrice = @"";
        
        
        self.strDateStartAsAnArtist = @"";
        self.strCurrentPriceOfArtwork = @"";
        self.strPicesYouSold = @"";
        self.strOnlineSourcesDoYouUse = @"";
        
        self.strByWhome = @"";
        self.strByDate = @"";
        
        //      When Is this your art is selected
        
        self.strGalleryThatSellYourWork = @"";
        self.strWhereYouExhibited = @"";
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
}

#pragma mark - Custom Methods

- (void)showPopup : (NSString *)strDescription  {
        
        [self.viewPopup setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.viewPopupInner.layer.cornerRadius = 5.0f;
        self.viewPopupInner.layer.masksToBounds = YES;
        self.textViewPopupDesc.editable = NO;
        self.textViewPopupDesc.scrollEnabled = YES;
        self.textViewPopupDesc.text = strDescription;
        [self.view addSubview:self.viewPopup];
        
        self.viewPopup.hidden = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        //  [UIView setAnimationDelay:2.0];
        [UIView commitAnimations];
}

-(void)config {
        
        
        //        level=1;
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        self.lblTitle.text=[self.titleString uppercaseString];// @"ART COLLECTION";
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        // self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.frame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.1f)];
        
        
        //        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        
}


-(void)loadDataLevel1 {
        
        level=1;
        //Header
        {
                arrHeaderTitle1=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle1 addObject:@"Elements to determine value of your art, please complete to the best of your knowledge in order to enable us to give you our best-considered opinion.Art works accepted are limited to Fine art,Sculpture and Decorative art."];
                [arrHeaderTitle1 addObject:@"Upload at least 3 HD quality pictures-art front, 3 HD pictures-art back"];
                [arrHeaderTitle1 addObject:@""];
                //                [arrHeaderTitle addObject:@""];
                
                
        }
        
        //init data
        {
                arrData1=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"First Name"                                    forKey:@"title"];
                [dic setObject:@"Enter your first name"                         forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Middle Name"                                   forKey:@"title"];
                [dic setObject:@"Enter your middle name"                        forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Last Name"                                     forKey:@"title"];
                [dic setObject:@"Enter your last name"                          forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Email"                                         forKey:@"title"];
                [dic setObject:@"Enter your email"                              forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"email_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Phone"                                         forKey:@"title"];
                [dic setObject:@"Enter your phone number "                      forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"value"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData1 addObject:dic];
                
        }
        
        
        //Multiple art
        {
                arrMultipleArt=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@""                                              forKey:@"path"];
                [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
                [arrMultipleArt addObject:dic];
        }
        
        
        
}

-(void)loadDataLevel2 {
        
        //        level=2;
        //Header
        
        {
                arrHeaderTitle2 = [[NSMutableArray alloc]init];
                
                [arrHeaderTitle2 addObject:@""];
                [arrHeaderTitle2 addObject:@"Upload art authenticity certificates if any"];
                [arrHeaderTitle2 addObject:@"Upload quality close-up photo of signature if possible"];
                [arrHeaderTitle2 addObject:@"Is this your art ?"];
                
                isThisYourArt ? [arrHeaderTitle2 addObject:@"Do your currently sell your work ?"] : [arrHeaderTitle2 addObject:@"Has the art been professionally appraised in the past ?"];
                
                [arrHeaderTitle2 addObject:@""];
                //                [arrHeaderTitle addObject:@""];
                
                
        }
        
        //init data
        {
                arrData2=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@""                                              forKey:@"title"];
                [dic setObject:@"Artist name if known"                          forKey:@"msg"];
                //                [dic setObject:self.strArtistName                                              forKey:@"value"];
                [dic setObject:@""                                              forKey:@"value"];
                
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@""                                              forKey:@"title"];
                [dic setObject:@"* Artwork Size"                                  forKey:@"msg"];
                //                [dic setObject:self.strArtWorkSize                                              forKey:@"value"];
                [dic setObject:@""                                              forKey:@"value"];
                
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@""                                              forKey:@"title"];
                [dic setObject:@"* Artwork Medium"                                forKey:@"msg"];
                //                [dic setObject:self.strArtworkMedium                                              forKey:@"value"];
                [dic setObject:@""                                              forKey:@"value"];
                
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@""                                              forKey:@"title"];
                [dic setObject:@"Date artwork completed if known"               forKey:@"msg"];
                //                [dic setObject:self.strDateArtWorkCompleted                                              forKey:@"value"];
                [dic setObject:@""                                              forKey:@"value"];
                
                [dic setObject:@"email_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData2 addObject:dic];
        }
        
        
        
        
        
        //Selection
        {
                arrSelectionsForLevel2 = [[NSMutableArray alloc]init];
                
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                /*
                 [dic setObject:@"* We may contact you if additional information is required or additional charges may apply based on submitted artwork in cases where extensive research may be required."                                              forKey:@"title"];
                 [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                 [arrSelections addObject:dic];
                 
                 dic=[NSMutableDictionary dictionary];
                 [dic setObject:@"* All information you have submitted is true and correct for the artwork submitted."                                              forKey:@"title"];
                 [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                 [arrSelections addObject:dic];
                 
                 dic=[NSMutableDictionary dictionary];
                 [dic setObject:@"* This appraisal is an Initial opinion based on photographic images and information submitted we would email you within 5-10 business days of our results."                                              forKey:@"title"];
                 [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                 [arrSelections addObject:dic];
                 */
                [dic setObject:@"Is this your art ?" forKey:@"title"];
                [dic setObject:[NSNumber numberWithBool:isThisYourArt]     forKey:@"value"];
                [arrSelectionsForLevel2 addObject:dic];
                
                if (isThisYourArt) {
                        
                        [dic setObject:@"Do your currently sell your work ?" forKey:@"title"];
                        [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                        [arrSelectionsForLevel2 addObject:dic];
                } else {
                        
                        [dic setObject:@"Has the art been professionally appraised in the past ?" forKey:@"title"];
                        [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                        [arrSelectionsForLevel2 addObject:dic];
                }
        }
        
        //Multiple art
        {
                arrCertificates=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                [dic setObject:@""                                              forKey:@"path"];
                [dic setObject:[[UIImage alloc] init]                           forKey:@"image"];
                [arrCertificates addObject:dic];
                
                 NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
                [dic1 setObject:@""                                              forKey:@"path"];
                [dic1 setObject:[[UIImage alloc] init]                           forKey:@"image"];
                [arrCertificates addObject:dic1];
                
        }
        
}


-(void)loadDataLevel2_2 {
        
        {
                if (!isThisYourArt) {
                        
                        arrData2_2=[[NSMutableArray alloc]init];
                        
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"When was the art purchased"                          forKey:@"msg"];
                        [dic setObject:self.strPurchaseTime                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"Where was it purchased"                                  forKey:@"msg"];
                        [dic setObject:self.strPurchasePlace                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"What was the puchase price"                                forKey:@"msg"];
                        [dic setObject:self.strPurchasePrice                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                } else {
                        arrData2_2 = [[NSMutableArray alloc]init];
                        
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"Date Started As ana Artist"
                                forKey:@"msg"];
                        [dic setObject:self.strDateStartAsAnArtist                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"What are your current prices on your artwork"                                  forKey:@"msg"];
                        [dic setObject:self.strCurrentPriceOfArtwork                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"How many pieces have you sold"                                forKey:@"msg"];
                        [dic setObject:self.strPicesYouSold                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"What online sources do you use to advertise sell or display your work"                                forKey:@"msg"];
                        [dic setObject:self.strOnlineSourcesDoYouUse                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_2 addObject:dic];
                        
                }
                
        }
        [self loadDataLevel2_3];
        [self.tableView reloadData];
        
}

-(void)loadDataLevel2_3 {
        
        {
                if (!isThisYourArt && isTheArtAppraisedInThePast) {
                        
                        arrData2_3=[[NSMutableArray alloc]init];
                        
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"By whom"                          forKey:@"msg"];
                        [dic setObject:self.strByWhome                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_3 addObject:dic];
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"By date"                                  forKey:@"msg"];
                        [dic setObject:self.strByDate                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_3 addObject:dic];
                        
                        
                        
                } else if (isThisYourArt && isTheArtAppraisedInThePast){
                        
                        arrData2_3=[[NSMutableArray alloc]init];
                        
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"Gallery that sell your work"
                                forKey:@"msg"];
                        [dic setObject:self.strGalleryThatSellYourWork                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_3 addObject:dic];
                        
                        dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@"Shows where you exhibited"                                  forKey:@"msg"];
                        [dic setObject:self.strWhereYouExhibited                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData2_3 addObject:dic];
                        
                        
                } else {
                        
                        arrData2_3 = [[NSMutableArray alloc]init];
                        
                }
        }
        [self.tableView reloadData];
}

-(void)loadDataLevel3 {
        
        //        level=3;
        
        //Header
        
        {
                arrHeaderTitle3=[[NSMutableArray alloc]init];
                
                [arrHeaderTitle3 addObject:@"Please provide any addditional information about the artwork including provenance:"];
                
                //                [arrHeaderTitle3 addObject:@"Art provenance (is the chronology of the ownership, custody or location of art work) if known"];
                //                [arrHeaderTitle3 addObject:@"Place Art was purchased and price if known"];
                //                [arrHeaderTitle3 addObject:@"If any Exhibitions, galleries, museum or corporate, related to Art work "];
                //                [arrHeaderTitle3 addObject:@"Place /city /country art work originated or executed if known"];
                //                [arrHeaderTitle3 addObject:@"Any additional art work /size /medium sold by artist in Auction if known"];
                //                [arrHeaderTitle3 addObject:@"Any additional art work /size /medium sold by artist and price it was sold for"];
                //                [arrHeaderTitle3 addObject:@"Any other related info you want to share"];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                [arrHeaderTitle3 addObject:@""];
                
        }
        
        //init data
        {
                arrData3=[[NSMutableArray alloc]init];
                
                
                for (int i=0; i<1; i++) {
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        [dic setObject:@""                                              forKey:@"title"];
                        [dic setObject:@""                                              forKey:@"msg"];
                        [dic setObject:@""                                              forKey:@"value"];
                        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                        [arrData3 addObject:dic];
                }
                
        }
        
        //Selection
        {
                arrSelections=[[NSMutableArray alloc]init];
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                /*
                 [dic setObject:@"* We may contact you if additional information is required or additional charges may apply based on submitted artwork in cases where extensive research may be required."                                              forKey:@"title"];
                 [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                 [arrSelections addObject:dic];
                 
                 dic=[NSMutableDictionary dictionary];
                 [dic setObject:@"* All information you have submitted is true and correct for the artwork submitted."                                              forKey:@"title"];
                 [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                 [arrSelections addObject:dic];
                 
                 dic=[NSMutableDictionary dictionary];
                 [dic setObject:@"* This appraisal is an Initial opinion based on photographic images and information submitted we would email you within 5-10 business days of our results."                                              forKey:@"title"];
                 [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                 [arrSelections addObject:dic];
                 */
                [dic setObject:@"I agree to the Terms and Conditions" forKey:@"title"];
                [dic setObject:[NSNumber numberWithBool:NO]     forKey:@"value"];
                [arrSelections addObject:dic];
                
                
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

-(void)setNav {
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}

-(void)rightNavBarConfiguration {
        
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

-(void)reSetStepIcon {
        
        self.imgStep.image=[UIImage imageNamed:(level==1 ? STEP_1_ICON : (level==2 ? STEP_2_ICON : STEP_3_ICON))];
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

-(NSInteger)getCardCount {
        
        NSArray* arrCard=[dataManager getCardDetails];
        
        return  arrCard ? arrCard.count : 0;
}

-(void)loadCardCount {
        
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
        
        
}

-(void)removeCardCount {
        
        for (id view in cardViewGlobal.subviews) {
                
                if(![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UIButton class]] )
                        [view removeFromSuperview];
        }
}

-(void)cellRegister{
        
        [self.tableView registerClass:[UpdateProfileViewCell class]     forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[AddArtViewCell3 class]           forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[AddArtViewCell2 class]           forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[RegistrationViewCell class]      forCellReuseIdentifier:CellIdentifier4];
        [self.tableView registerClass:[AddArtViewCell1 class]           forCellReuseIdentifier:CellIdentifier5];
        [self.tableView registerClass:[PopFilterViewCell class]         forCellReuseIdentifier:CellIdentifier6];
        [self.tableView registerClass:[ValuationPremiumButtonTVCell class]         forCellReuseIdentifier:CellIdentifier13];
        [self.tableView registerClass:[ValuationOfArtWorkClickHereTVCell class]         forCellReuseIdentifier:cellIdentifier14];
        
        [self.tableView registerClass:[ArtCategoryViewCell class]         forCellReuseIdentifier:cellIdentifier15];
      
        UINib *contantsCellNib1 = [UINib nibWithNibName:NSStringFromClass([UpdateProfileViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        UINib *contantsCellNib2= [UINib nibWithNibName:NSStringFromClass([AddArtViewCell3 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        UINib *contantsCellNib3= [UINib nibWithNibName:NSStringFromClass([AddArtViewCell2 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        UINib *contantsCellNib4 = [UINib nibWithNibName:NSStringFromClass([RegistrationViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        UINib *contantsCellNib5 = [UINib nibWithNibName:NSStringFromClass([AddArtViewCell1 class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib5 forCellReuseIdentifier:CellIdentifier5];
        UINib *contantsCellNib7 = [UINib nibWithNibName:NSStringFromClass([PopFilterViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib7 forCellReuseIdentifier:CellIdentifier6];
        
        UINib *contantsCellNib13 = [UINib nibWithNibName:NSStringFromClass([ValuationPremiumButtonTVCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib13 forCellReuseIdentifier:CellIdentifier13];
        
        UINib *contantsCellNib14 = [UINib nibWithNibName:NSStringFromClass([ValuationOfArtWorkClickHereTVCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib14 forCellReuseIdentifier:cellIdentifier14];
        
        UINib *contantsCellNib15 = [UINib nibWithNibName:NSStringFromClass([ArtCategoryViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib15 forCellReuseIdentifier:cellIdentifier15];
        
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

-(void)valuationOfArtWebService:(NSDictionary*)dic  images:(NSArray*)images
{
        
        NSLog(@"%@", images);
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl,kURL_VALUATION_OF_ART);
                
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
                NSMutableData* httpBody = [Alert getBodyForMultipartDataWithPostString:postString images:images];
                
                self.session = [NSURLSession sharedSession];  // use sharedSession or create your own
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                        
                });
                
                NSURLSessionTask *task = [self.session uploadTaskWithRequest:theRequest fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                        
                        NSLog(@"%@", result);
                        dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil  || error)
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
                                [[SharedClass sharedObject] hudeHide];
                                if (success.boolValue) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                
                                                [Alert alertWithMessage:[result objectForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:YES animation:YES second:3.0];
                                                
                                                [self loadDataLevel1];
                                                [self loadDataLevel2];
                                                [self loadDataLevel2_2];
                                                [self loadDataLevel3];
                                                [self reSetStepIcon];
                                                [self.tableView reloadData];
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
        UIFont*font=[UIFont fontWithName:FONT_MONTSERRAT_SEMIBOLD size:fontSize];
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
        NSInteger section = 0;
        switch (level) {
                case 1:
                        section = 3;
                        break;
                case 2:
                        //   section = 4;
                        section = 6;
                        
                        break;
                case 3:
                        section = 9;
                        break;
                default:
                        break;
        }
        return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        NSInteger rows = 0;
        switch (level) {
                        
                case 1:
                        switch (section) {
                                case 0:
                                        rows=5;
                                        break;
                                case 1:
                                        rows = arrMultipleArt.count;
                                        break;
                                case 2:
                                        rows=1;
                                        break;
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (section) {
                                case 0:
                                        rows = 4;
                                        break;
                                case 1:
                                        rows=1;
                                        break;
                                case 2:
                                        rows=1;
                                        break;
                                case 3:
                                        rows = isThisYourArt? 4:3;
                                        break;
                                case 4:
                                        rows = isTheArtAppraisedInThePast? 2:0 ;
                                        break;
                                case 5:
                                        rows=1;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        rows = 1;
                        break;
                default:
                        break;
        }
        return rows;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        
        return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        NSInteger height = 0;
        switch (level) {
                        
                case 1:
                        switch (indexPath.section) {
                                case 0:
                                        height = 44.0f;
                                        break;
                                case 1:
                                        height = 40;
                                        break;
                                case 2:
                                        height = 44.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 2:
                        switch (indexPath.section) {
                                case 0:
                                        height = 40.0;
                                        break;
                                        
                                case 1:
                                case 2:
                                        height = 40.0f;
                                        break;
                                        
                                case 3:
                                case 4:
                                        height = 40.0f;
                                        break;
                                        
                                case 5:
                                        height = 40.0f;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        switch (indexPath.section) {
                                                        case 1:
                                        
                                        height = 40.0;
                                        
                                        break;
                                        
                                case 3:
                                        
                                        height = 100.0;
                                        
                                        break;
                                        
                                default:
                                        
                                        height = 50.0f;
                                        
                                        break;
                        }
                        
                        
                        break;
                default:
                        break;
        }
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        switch (level) {
                        
                case 1:
                        switch (indexPath.section) {
                                case 0:
                                        switch (indexPath.row) {
                                                case 0:
                                                case 1:
                                                case 2:
                                                case 3:
                                                case 4:
                                                {
                                                        NSDictionary *item = [arrData1 objectAtIndex:indexPath.row];
                                                        
                                                        UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                                        
                                                        cell.img.hidden=NO;
                                                        cell.lblTitle.text=[item objectForKey:@"title"];
                                                        cell.lblTitle.tintColor=[UIColor blackColor];
                                                        
                                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                                        
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
                                                        if(indexPath.row!=1 && indexPath.row!=2 && indexPath.row!=4){
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
                                                        }
                                                        
                                                        return cell;
                                                        
                                                }
                                                        break;
                                                        
                                                        break;
                                                default:
                                                        break;
                                        }
                                        break;
                                case 1:
                                {
                                        AddArtViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        NSDictionary* dic=[arrMultipleArt objectAtIndex:indexPath.row];
                                        
                                        NSString* path=[dic objectForKey:@"path"];
                                        cell.btnAddMore.enabled=YES;
                                        cell.lblFileName.text=IS_EMPTY(path) ? @"No file Chosen" : path;
                                        cell.lblAddMore.text=(indexPath.row==0) ? @"ADD MORE" : @"REMOVE";
                                        
                                        cell.btnChooseFile.tag=indexPath.row;
                                        cell.btnAddMore.tag=indexPath.row;
                                        [cell.btnChooseFile addTarget:self action:@selector(chooseFile:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnAddMore addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
                                        return cell;
                                }
                                        break;
                                case 2:
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
                                        
                                        //Tint color
                                        cell.txtName.tintColor=[UIColor blackColor];
                                        cell.viContainerText.backgroundColor=[UIColor whiteColor];
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 1:
                                case 2:
                                {
                                        AddArtViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        NSDictionary* dic=[arrCertificates objectAtIndex:indexPath.section==1 ? 0 : 1 ];
                                        
                                        NSString* path = [dic objectForKey:@"path"];
                                        
                                        cell.lblFileName.text=IS_EMPTY(path) ? @"No file Chosen" : path;
                                        //                                                cell.lblAddMore.text=(indexPath.row==0) ? @"ADD MORE" : @"REMOVE";
                                        cell.lblAddMore.text=@"BROWSE";
                                        cell.btnChooseFile.tag=indexPath.row;
                                        cell.btnAddMore.tag=indexPath.row;
                                        [cell.btnChooseFile addTarget:self action:@selector(chooseFile:) forControlEvents:UIControlEventTouchUpInside];
                                        cell.btnAddMore.enabled=NO;
                                        // [cell.btnAddMore addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
                                        return cell;
                                }
                                        break;
                                        
                                case 3:
                                {
                                        NSDictionary *item = [arrData2_2 objectAtIndex:indexPath.row];
                                        
                                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        //       cell.txtName.autocorrectionType = NO;
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
                                        
                                        //Tint color
                                        cell.txtName.tintColor=[UIColor blackColor];
                                        cell.viContainerText.backgroundColor=[UIColor whiteColor];
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        
                                        
                                        return cell;
                                        
                                }
                                        
                                case 4:
                                {
                                        NSDictionary *item = [arrData2_3 objectAtIndex:indexPath.row];
                                        
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
                                        
                                        cell.txtName.tag =indexPath.row;
                                        
                                        /*
                                         if (!isThisYourArt) {
                                         
                                         if (isTheArtAppraisedInThePast) {
                                         
                                         switch (indexPath.row) {
                                         
                                         case 1:
                                         [cell.txtName addTarget:self action:@selector(openDatePickerOnBeginEditing:) forControlEvents:UIControlEventTouchUpInside];
                                         break;
                                         
                                         default:
                                         break;
                                         }
                                         
                                         } else {
                                         [cell.txtName addTarget:self
                                         action:@selector(textFieldDidChange:)
                                         forControlEvents:UIControlEventEditingChanged];
                                         }                          }
                                         else
                                         {
                                         
                                         [cell.txtName addTarget:self
                                         action:@selector(textFieldDidChange:)
                                         forControlEvents:UIControlEventEditingChanged];
                                         }
                                         
                                         */
                                        
                                        [cell.txtName addTarget:self
                                                         action:@selector(textFieldDidChange:)
                                               forControlEvents:UIControlEventEditingChanged];
                                        // cell.viContainerText.layer.borderWidth=1.5f;
                                        // cell.viContainerText.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                                        
                                        //Tint color
                                        cell.txtName.tintColor=[UIColor blackColor];
                                        cell.viContainerText.backgroundColor = [UIColor whiteColor];
                                        cell.contentView.backgroundColor = [UIColor whiteColor];
                                        
                                        return cell;
                                        
                                }
                                        
                                case 5:
                                {
                                        AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                                        [cell.btnRight removeTarget:nil
                                                             action:NULL
                                                   forControlEvents:UIControlEventAllEvents];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        cell.lblLeft.text=@"BACK";
                                        cell.lblRight.text=@"NEXT";
                                        cell.btnLeft.tag=indexPath.row;
                                        cell.btnRight.tag=indexPath.row;
                                        [cell.btnLeft addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
                                        [cell.btnRight addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
                                        cell.btnLeft.userInteractionEnabled = YES;
                                        cell.btnRight.userInteractionEnabled = YES;
                                        
                                        return cell;
                                }
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                case 3:
                        switch (indexPath.section) {
                                        
                                        /*
                                         case 0:
                                         
                                         {
                                         NSDictionary *item = [arrData3 objectAtIndex:indexPath.section];
                                         
                                         RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         
                                         cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
                                         cell.txtName.text=[item objectForKey:@"value"];
                                         cell.txtName.delegate=self;
                                         cell.img.hidden=YES;
                                         cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                         //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                                         
                                         
                                         [Alert attributedString:cell.txtName
                                         msg:@""
                                         color:[item objectForKey:@"color"]];
                                         
                                         cell.txtName.tag=indexPath.section;
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
                                         case 1:
                                         {
                                         PopFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         cell.contentView.backgroundColor=[UIColor whiteColor];
                                         
                                         NSDictionary* dic=[arrSelections objectAtIndex:indexPath.row];
                                         
                                         NSNumber* isSelected=[dic objectForKey:@"value"];
                                         
                                         NSString* icon=[isSelected boolValue] ? SELECT_TICK : UNSELECT_TICK;
                                         cell.img.image=[UIImage imageNamed:icon];
                                         
                                         NSString* name=[dic objectForKey:@"title"];
                                         
                                         CGRect rect = [self getSizeFromText:name tableView:tableView fontSize:15];
                                         rect.size.height=MIN(rect.size.height, CELL_DESC_HEIGHT_DEFAULT);
                                         float totalHeight=rect.size.height;
                                         
                                         [Alert updateConstraintsWithView:cell.lblName
                                         constant:totalHeight ? totalHeight : 0
                                         constraintType:(NSLayoutAttributeHeight)];
                                         
                                         
                                         cell.lblName.text=name;
                                         cell.lblName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:13];
                                         
                                         
                                         return cell;
                                         
                                         break;
                                         
                                         }
                                         break;
                                         case 2:
                                         {
                                         AddArtViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                                         
                                         [cell.btnRight removeTarget:nil
                                         action:NULL
                                         forControlEvents:UIControlEventAllEvents];
                                         
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         cell.contentView.backgroundColor=[UIColor whiteColor];
                                         cell.lblLeft.text=@"BACK";
                                         cell.lblRight.text=@"SUBMIT ($99)";
                                         cell.btnLeft.tag=indexPath.row;
                                         cell.btnRight.tag=indexPath.row;
                                         [cell.btnLeft addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
                                         [cell.btnRight addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                         return cell;
                                         }
                                         break;
                                         
                                         case 3:
                                         {
                                         
                                         ValuationPremiumButtonTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier13 forIndexPath:indexPath];
                                         
                                         
                                         
                                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                         cell.contentView.backgroundColor=[UIColor whiteColor];
                                         cell.lblTitle.backgroundColor = [UIColor redColor];
                                         cell.btnClick.backgroundColor = [UIColor clearColor];
                                         [cell.btnClick setTitle:@"" forState:UIControlStateNormal];
                                         cell.lblTitle.text=@"PREMIUM ($249)";
                                         [cell.lblTitle setTextColor:[UIColor whiteColor]];
                                         cell.btnClick.tag = indexPath.row;
                                         [cell.btnClick addTarget:self action:@selector(prmiumButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                         return cell;
                                         
                                         
                                         }
                                         break;
                                         */
                                        
                                        
                                        
                                case 0: {
                                        
                                        NSDictionary *item = [arrData3 objectAtIndex:indexPath.section];
                                        
                                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        
                                        cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:11];
                                        cell.txtName.text=[item objectForKey:@"value"];
                                        cell.txtName.delegate=self;
                                        cell.img.hidden=YES;
                                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                                        
                                        
                                        [Alert attributedString:cell.txtName
                                                            msg:@""
                                                          color:[item objectForKey:@"color"]];
                                        
                                        cell.txtName.tag=indexPath.section;
                                        [cell.txtName addTarget:self
                                                         action:@selector(textFieldDidChange:)
                                               forControlEvents:UIControlEventEditingChanged];
                                        
                                        // cell.viContainerText.layer.borderWidth=1.5f;
                                        // cell.viContainerText.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_CONTENT_BORRDER].CGColor;
                                        cell.txtName.autocorrectionType =UITextAutocorrectionTypeNo;
                                        //Tint color
                                        cell.txtName.tintColor = [UIColor blackColor];
                                        cell.viContainerText.backgroundColor=[UIColor whiteColor];
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        return cell;
                                        
                                }
                                        break;
                                case 1: {
                                        
                                        PopFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        NSDictionary* dic=[arrSelections objectAtIndex:indexPath.row];
                                        
                                        NSNumber* isSelected=[dic objectForKey:@"value"];
                                        
                                        NSString* icon=[isSelected boolValue] ? SELECT_TICK : UNSELECT_TICK;
                                        cell.img.image=[UIImage imageNamed:icon];
                                        
                                        NSString* name=[dic objectForKey:@"title"];
                                        
                                        CGRect rect = [self getSizeFromText:name tableView:tableView fontSize:15];
                                        rect.size.height=MIN(rect.size.height, CELL_DESC_HEIGHT_DEFAULT);
                                        float totalHeight=rect.size.height;
                                        
                                        [Alert updateConstraintsWithView:cell.lblName
                                                                constant:totalHeight ? totalHeight : 0
                                                          constraintType:(NSLayoutAttributeHeight)];
                                        
                                        
                                        cell.lblName.text=name;
                                        cell.lblName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:13];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                        
                                case 2:
                                case 6:
                                case 8: {
                                        
                                        ValuationOfArtWorkClickHereTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier14 forIndexPath:indexPath];
                                        
                                        if(indexPath.section == 2) {
                                                
                                        }
                                        else if (indexPath.section == 6) {
                                                
                                        }
                                        else if (indexPath.section == 8) {
                                                
                                                
                                        }
                                        
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        cell.button.tag = indexPath.section + 999;
                                        [cell.button setTitle:@"Click here to view" forState:UIControlStateNormal];
                                        [cell.button setBackgroundColor:[UIColor clearColor]];
                                        [cell.button addTarget:self action:@selector(buttonClickHereToViewTapped:) forControlEvents:UIControlEventTouchUpInside];
                                        //cell.lblName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:13];
                                        
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 3: {
                                        
                                        ArtCategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier15 forIndexPath:indexPath];
                                        
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.lblName.numberOfLines = 0;
                                        cell.lblName.lineBreakMode = NSLineBreakByWordWrapping;
                                        cell.lblName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:13];
                                        cell.lblName.text = @"For any reason we are unable to give you our considered opinion we reserve the right to refuse your application, and a full refund will be submitted within 5-10 business days.";
                                        
                                        return cell;
                                        
                                }
                                        break;
                                case 4:
                                case 5:
                                case 7: {
                                        
                                        ValuationPremiumButtonTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier13 forIndexPath:indexPath];
                                        
                                        if (indexPath.section == 4) {
                                                
                                                [cell.btnClick setTitle:@"Back" forState:UIControlStateNormal];
                                                [cell.btnClick addTarget:self action:@selector(backMove:) forControlEvents:UIControlEventTouchUpInside];
                                                [cell.btnClick setBackgroundColor:[UIColor colorWithRed:220/255.0 green:103/255.0 blue:51/255.0 alpha:1.0]];
                                                
                                        } else if (indexPath.section == 5) {
                                                
                                                [cell.btnClick setTitle:@"BASIC EVALUATION ($99)" forState:UIControlStateNormal];
                                                [cell.btnClick addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                                [cell.lblTitle setBackgroundColor:[UIColor colorWithRed:223/255.0 green:40/255.0 blue:53/255.0 alpha:1.0]];
                                                
                                        } else if (indexPath.section == 7) {
                                                
                                                [cell.btnClick setTitle:@"DELUXE EVALUATION ($249)" forState:UIControlStateNormal];
                                                [cell.btnClick addTarget:self action:@selector(prmiumButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                                [cell.lblTitle setBackgroundColor:[UIColor colorWithRed:223/255.0 green:40/255.0 blue:53/255.0 alpha:1.0]];
                                        }
                                        
                                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                        cell.contentView.backgroundColor=[UIColor whiteColor];
                                        cell.btnClick.backgroundColor = [UIColor clearColor];
                                        [cell.btnClick setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        cell.btnClick.tag = indexPath.row;
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
                                case 4:
                                        switch (indexPath.row) {
                                                        
                                                        NSDictionary* dic=[arrSelections objectAtIndex:indexPath.row];
                                                        
                                                        NSNumber* isSelected=[dic objectForKey:@"value"];
                                                        [dic setValue:[NSNumber numberWithBool:![isSelected boolValue]] forKey:@"value"];
                                                        
                                                        
                                                        
                                                        [Alert reloadSection:indexPath.section table:tableView];
                                                        
                                        }
                                        break;
                                        
                                default:
                                        break;
                        }
                }
                        break;
                        
                        
                        // End of section 2
                case 3:
                {
                        
                        switch (indexPath.section) {
                                        
                                case 1:
                                        switch (indexPath.row) {
                                                case 0:
//                                                case 1:
//                                                case 2:
                                                {
                                                        NSDictionary* dic=[arrSelections objectAtIndex:indexPath.row];
                                                        
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


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        
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
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.textColor=[UIColor blackColor];
        myLabel.backgroundColor=[UIColor clearColor];
        myLabel.numberOfLines = 10;
        UIButton *buttonCheckBox = [[UIButton alloc]init];
        //        [buttonCheckBox setImage:isThisYourArt? [UIImage imageNamed:@"multiselect_green.png"]:[UIImage imageNamed:@"unselected_tick.png"] forState:UIControlStateNormal];
        buttonCheckBox.backgroundColor = [UIColor clearColor];
        buttonCheckBox.tag = section +1000;
        [buttonCheckBox addTarget:self action:@selector(buttonCheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:myLabel];
        [headerView addSubview:buttonCheckBox];
        
        float height=0;
        
        switch (level) {
                case 1:
                        switch (section) {
                                case 0:
                                        height = 84;
                                        break;
                                case 1:
                                        height = 34;
                                        break;
                                default:
                                        height = 0;
                                        break;
                        }
                        break;
                case 2:
                        switch (section) {
                                case 0:
                                        height = 0;
                                        break;
                                case 1:
                                case 2:
                                        height = 34;
                                        break;
                                        
                                case 3:
                                        height = 34;
                                        break;
                                case 4:
                                        height = 34;
                                        break;
                                case 5:
                                        height = 0;
                                        break;
                                default:
                                        height = 0;
                                        break;
                        }
                        break;
                case 3:
                        switch (section) {
                                        
                                case 0:
                                        height=34;
                                        break;
                                case 1:
                                        height=24;
                                        break;
                                case 2:
                                        height=34;
                                        break;
                                case 3:
                                        height=24;
                                        break;
                                case 4:
                                        height=34;
                                        break;
                                case 5:
                                        height=34;
                                        break;
                                case 6:
                                        height=24;
                                        break;
                                case 7:
                                        height=24;
                                        break;
                                case 8:
                                        height=24;
                                        break;
                                        
                                default:
                                        break;
                        }
                        break;
                        
                default:
                        break;
        }
        
        
        switch (level) {
                        
                case 1:
                        myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, height);
                        break;
                case 2:
                        
                        switch (section) {
                                case 1:
                                case 2:
                                        myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, height);
                                        break;
                                        
                                        
                                case 3:
                                        myLabel.textAlignment=NSTextAlignmentLeft;
                                        
                                        myLabel.frame = CGRectMake(40, 0, tableView.frame.size.width-48, height);
                                        
                                        buttonCheckBox.frame = CGRectMake(8, 6, 25.0, 25.0);
                                        
                                        [buttonCheckBox setImage:isThisYourArt? [UIImage imageNamed:@"selected_tick.png"]:[UIImage imageNamed:@"unselected_tick.png"] forState:UIControlStateNormal];
                                        break;
                                        
                                case 4:
                                        myLabel.textAlignment=NSTextAlignmentLeft;
                                        
                                        myLabel.frame = CGRectMake(40, 0, tableView.frame.size.width-48, height);
                                        
                                        buttonCheckBox.frame = CGRectMake(8, 6, 25, 25.0);
                                        
                                        [buttonCheckBox setImage:isTheArtAppraisedInThePast? [UIImage imageNamed:@"selected_tick.png"]:[UIImage imageNamed:@"unselected_tick.png"] forState:UIControlStateNormal];
                                        break;
                                default:
                                        
                                        break;
                        }
                        
                        
                        break;
                case 3:
                        myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, height);
                        break;
                        
                default:
                        break;
        }
        //    myLabel.frame = CGRectMake(8, 8, tableView.frame.size.width-16, height);
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        NSInteger height=0;
        
        switch (level) {
                case 1:
                        switch (section) {
                                case 0:
                                        height = 100.0f;
                                        break;
                                case 1:
                                        height = 50.0f;
                                        break;
                                case 2:
                                        height = 30.0f;
                                        break;
                                default:
                                        break;
                        }
                        
                        break;
                case 2:
                        switch (section) {
                                case 0:
                                        height = 0.0f;
                                        break;
                                case 1:
                                case 2:
                                        
                                        height=50.0f;
                                        break;
                                case 3:
                                case 4:
                                        height = 100.0f;
                                        break;
                                case 5:
                                        //                                        height=30.0f;
                                        height=0.0f;
                                        
                                        break;
                                default:
                                        break;
                        }
                        
                        break;
                case 3:
                        
                        switch (section) {
                                case 0:
                                        height = 50.0f;
                                        break;
                                case 1:
                                        height = 40.0f;
                                        break;
                                case 2:
                                        height = 50.0f;
                                        break;
                                case 3:
                                        height = 40.0f;
                                        break;
                                case 4:
                                        height = 50.0f;
                                        break;
                                case 5:
                                        height = 50.0f;
                                        break;
                                case 6:
                                        height = 40.0f;
                                        break;
                                case 7:
                                        height = 0.0f;
                                        break;
                                case 8:
                                        height = 10.0f;
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

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//
//
//}

-(void)openDatePickerOnBeginEditing :(UITextField *)textField {
        
        [self.view endEditing:YES];
        [self setDefaultTableHeight];
        [self removeDatePicker];
        
        [self createDatePicker:YES items:nil sender:textField datePickerMode:UIDatePickerModeDate];
        
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        
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
        
        switch (level) {
                        
                case 2: {
                        
                        switch (indexPath.section) {
                                
                                case 0: {
                                
                                        switch (indexPath.row) {
                                                        
                                                case 3: {
                                                        
                                                        [self createDatePicker:NO items:nil sender:textField datePickerMode:(UIDatePickerModeDate)];
                                                        
                                                        return NO;
                                                }
                                                        break;
                                                        
                                                default:
                                                        break;
                                        }
                                
                                }
                                        break;
                                case 3: {
                                        
                                        switch (indexPath.row) {
                                                case 0:
                                                {
                                                        {
                                                                //      isDate=YES;
                                                                [self createDatePicker:NO items:nil sender:textField datePickerMode:(UIDatePickerModeDate)];
                                                                
                                                                return NO;
                                                        }
                                                }
                                                        break;
                                                        
                                                default:
                                                        break;
                                        }
                                }
                                        break;
                                        
                                case 4: {
                                        
                                        switch (indexPath.row) {
                                                case 1:
                                                {
                                                        if (!isThisYourArt && isTheArtAppraisedInThePast) {
                                                                {
                                                                        //      isDate=YES;
                                                                        [self createDatePicker:NO items:nil sender:textField datePickerMode:(UIDatePickerModeDate)];
                                                                        return NO;
                                                                }
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
        [textField resignFirstResponder];
        
        NSIndexPath *indexPathOriginal =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
        switch (level) {
                case 1:
                {
                        UpdateProfileViewCell * cell;
                        
                        switch (indexPathOriginal.row) {
                                case 0:
                                case 1:
                                case 2:
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isName=[Alert validationString:textField.text];
                                                
                                                if(!isName){
                                                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
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
                                case 3:
                                        if(!IS_EMPTY(textField.text)){
                                                BOOL isEmail=[Alert validationEmail:textField.text];
                                                
                                                if(!isEmail){
                                                        [Alert alertWithMessage:@"Invalid email ! Please enter valid email."
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
                                        if(!IS_EMPTY(textField.text)) {
                                                
                                                BOOL isMobile = [Alert validateMobileNumber:textField.text];
                                                
                                                if(!isMobile){
                                                        [Alert alertWithMessage:@"Invalid phone ! Please enter valid phone number."
                                                                     navigation:self.navigationController
                                                                       gotoBack:NO animation:YES];
                                                       // [textField becomeFirstResponder];
                                                        
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
                        if (indexPathOriginal.section == 0) {
                                
                                RegistrationViewCell * cell;
                                
                                switch (indexPathOriginal.row) {
                                        case 0:
                                        case 1:
                                                //                                case 2:
                                                //                                case 3:
                                                //                                case 4:
                                                //                                case 5:
                                                if(!IS_EMPTY(textField.text)){
                                                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:indexPathOriginal.section]];
                                                        [cell.txtName becomeFirstResponder];
                                                }
                                                break;
                                                
                                                
                                        default:
                                                break;
                                }

                        }
                        else
                        {
                         [textField resignFirstResponder];
                        }
                        
                }
                        break;
                case 3:
                {
                        RegistrationViewCell * cell;
                        
                        switch (indexPathOriginal.section) {
                                        
                                case 0:
//                                case 1:
//                                case 2:
//                                case 3:
//                                case 4:
//                                case 5:
                                        if(!IS_EMPTY(textField.text)) {
                                                
//                                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPathOriginal.section+1]];
                                                [cell.txtName resignFirstResponder];
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
        
        
        return YES;
}



-(void)textFieldDidChange:(id)sender {
        
        BOOL isValidLevel_2_0 = NO;
        BOOL isValidLevel_2_3 = NO;
        BOOL isValidLevel_2_4 = NO;
        
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
                                case 2:
                                        isValid=[Alert validationString:txt.text];
                                        break;
                                case 3:
                                        isValid=[Alert validationEmail:txt.text];
                                        break;
                                case 4:
                                        isValid=[Alert validateMobileNumber:txt.text];
                                        break;
                                        
                                default:
                                        isValid=YES;
                                        break;
                        }
                        
                        
                        txt.textColor = isValid ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic = [arrData1 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                case 2:
                {
                        
                        //        BOOL isValid=NO;
                        
                        switch (indexPath.section) {
                                        
                                case 0:
                                        switch (indexPath.row) {
                                                        
                                                case 1:
                                                        isValidLevel_2_0 = [Alert validationStringAndNumberCommaEtc:txt.text];
                                                        break;
                                                        
                                                case 0:
                                                case 2:
                                                        isValidLevel_2_0 = [Alert validationStringAndNumberCommaEtc:txt.text];
                                                        break;
                                                        
                                                default:
                                                        isValidLevel_2_0 = YES;
                                                        break;
                                                        
                                                        
                                        }
                                        
                                        break;
                                case 3:
                                {
                                        if (!isThisYourArt) {
                                                
                                                switch (indexPath.row) {
                                                                
                                                        case 1:
                                                                isValidLevel_2_3 = [Alert validationString:txt.text];
                                                                break;
                                                        case 2:
                                                                isValidLevel_2_3 = [Alert validationStringAndNumberCommaEtc:txt.text];
                                                                break;
                                                                
                                                        default:
                                                                isValidLevel_2_3=YES;
                                                                break;
                                                                
                                                }
                                        }
                                        
                                        if (isThisYourArt) {
                                                
                                                switch (indexPath.row) {
                                                                
                                                        case 1:
                                                                isValidLevel_2_3 = [Alert validationStringAndNumberCommaEtc:txt.text];
                                                                break;
                                                                
                                                        case 2:
                                                                isValidLevel_2_3 = [Alert validateNumber:txt.text];
                                                                break;
                                                                
                                                        case 3:
                                                                isValidLevel_2_3 = [Alert validationStringAndNumberCommaEtc:txt.text];
                                                                break;
                                                                
                                                        default:
                                                                isValidLevel_2_3=YES;
                                                                break;
                                                                
                                                }
                                        }
                                        
                                        
                                        
                                }
                                        break;
                                        
                                case 4:
                                {
                                        if(!isThisYourArt && isTheArtAppraisedInThePast) {
                                                
                                                
                                                switch (indexPath.row) {
                                                        case 0:
                                                                isValidLevel_2_4 = [Alert validationString:txt.text];
                                                                break;
                                                                
                                                                
                                                        default:
                                                                isValidLevel_2_4 = YES;
                                                                
                                                                break;
                                                                
                                                }
                                        }
                                        else if (isThisYourArt && isTheArtAppraisedInThePast) {
                                                
                                                switch (indexPath.row) {
                                                                
                                                        case 0:
                                                        case 1:
                                                                isValidLevel_2_4 = [Alert validationString:txt.text];
                                                                break;
                                                                
                                                                
                                                        default:
                                                                isValidLevel_2_4 = YES;
                                                                
                                                                break;
                                                                
                                                }
                                                
                                                
                                        }
                                        
                                }
                                        
                                        break;
                                default:
                                        break;
                        }
                        
                        //                        isValid=YES;
                        //
                        //                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                        //
                        //                        NSMutableDictionary* dic=[arrData2 objectAtIndex:txt.tag];
                        //
                        //                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                        
                case 3:
                {
                        BOOL isValid = NO;
                        //
                        
                        switch (indexPath.section) {
                                        
                                case 0:
                                        isValid = [Alert validationString:txt.text];
                                        break;
                                        
                                default:
                                        isValid=YES;
                                        break;
                        }
                        
                        
                        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic = [arrData3 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                        break;
                        
                        
                default:
                        break;
        }
        
        
        if (level == 2) {
                
                if (indexPath.section  == 0) {
                        
                        txt.textColor = isValidLevel_2_0 ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic = [arrData2 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                }
                if (indexPath.section  == 3) {
                        
                        txt.textColor = isValidLevel_2_3 ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic = [arrData2_2 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                        
                }
                if (indexPath.section  == 4) {
                        
                        txt.textColor = isValidLevel_2_4 ? [UIColor blackColor] : [UIColor redColor];
                        
                        NSMutableDictionary* dic = [arrData2_3 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
                        
                }
                
        }
        
}


#pragma mark - Validate Levels

-(NSArray*)matchPathWithArray:(NSArray*)list {
        
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
        NSIndexPath* index2=[NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath* index3=[NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath* index4=[NSIndexPath indexPathForRow:4 inSection:0];
        NSIndexPath* index5=[NSIndexPath indexPathForRow:0 inSection:1];
        
        if(!IS_EMPTY([[arrData1 objectAtIndex:0] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:3] objectForKey:@"value"]) ) {
                
                BOOL isFName    =[Alert validationString:[[arrData1 objectAtIndex:0] objectForKey:@"value"]];
                BOOL isMName    =[Alert validationString:[[arrData1 objectAtIndex:1] objectForKey:@"value"]];
                BOOL isMValue   =!IS_EMPTY([[arrData1 objectAtIndex:1] objectForKey:@"value"]);
                BOOL isLName    =[Alert validationString:[[arrData1 objectAtIndex:2] objectForKey:@"value"]];
                BOOL isLValue   =!IS_EMPTY([[arrData1 objectAtIndex:2] objectForKey:@"value"]);
                BOOL isEmail    =[Alert validationEmail:[[arrData1 objectAtIndex:3] objectForKey:@"value"]];
                BOOL isPhone    =[Alert validateMobileNumber:[[arrData1 objectAtIndex:4] objectForKey:@"value"]];
                BOOL isPValue   =!IS_EMPTY([[arrData1 objectAtIndex:4] objectForKey:@"value"]);
                NSArray* arrImages= [self matchPathWithArray:arrMultipleArt];
                
                if(!isFName){
                        [Alert alertWithMessage:@"Invalid First Name ! Please enter valid first name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        
                }
                else if(!isMName && isMValue){
                        [Alert alertWithMessage:@"Invalid Middle Name ! Please enter valid middle name or leave blank field."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isLName && isLValue){
                        [Alert alertWithMessage:@"Invalid Last Name ! Please enter valid last name or leave blank field."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isEmail){
                        [Alert alertWithMessage:@"Invalid Email ! Please enter valid email."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index3 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isPhone && isPValue){
                        [Alert alertWithMessage:@"Invalid Phone Number ! Please enter valid phone number."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index4 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (arrImages.count<3){
                        
//                        [Alert alertWithMessage:[NSString stringWithFormat:@"%d remaining images ! Please choose at least 3 images",1]
//                                     navigation:self.navigationController
//                                       gotoBack:NO animation:YES second:3.0];
                        [Alert alertWithMessage:@"Please choose at least 3 images."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
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
        
        NSIndexPath* index1Section0 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2Section0 = [NSIndexPath indexPathForRow:2 inSection:0];
        
        
        if(!IS_EMPTY([[arrData2 objectAtIndex:1] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData2 objectAtIndex:2] objectForKey:@"value"])) {
                
                //                NSArray* arrCer= [self matchPathWithArray:arrCertificates];
                
                //                if (arrCer.count<2){
                //                        [Alert alertWithMessage:@"Missing file ! Please choose file ."
                //                                     navigation:self.navigationController
                //                                       gotoBack:NO animation:YES second:3.0];
                //                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                //                }
                //                else
                //                {
                //               isValid=YES;
                //                }
                
                BOOL isArtWorkSize  = [Alert validationStringAndNumberCommaEtc:[[arrData2 objectAtIndex:1] objectForKey:@"value"]];
                
                BOOL isArtWorkMedium = [Alert validationStringAndNumberCommaEtc:[[arrData2 objectAtIndex:2] objectForKey:@"value"]];
                
                if (!isArtWorkSize) {
                        
                        [Alert alertWithMessage:@"Invalid Artwork Size ! Please enter valid Artwork size."
                                                              navigation:self.navigationController
                                                                gotoBack:NO animation:YES second:3.0];
                                                 [self.tableView scrollToRowAtIndexPath:index1Section0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if (!isArtWorkMedium) {
                
                        [Alert alertWithMessage:@"Invalid Artwork Medium ! Please enter valid Artwork medium."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index2Section0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                
                else {
                        
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

-(BOOL)isLevel3 {
        
        BOOL isValid=NO;
        
        NSArray* arrSel= [self matchSelectionWithArray:arrSelections];
        
        if(arrSel.count==1)
        {
                isValid=YES;
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
        
        BOOL isValid = NO;
        
        
        switch (level) {
                case 1:
                             isValid=[self isLevel1];     // By Cs Rai
                 //       isValid = true;
                        break;
                case 2:
                        isValid=[self isLevel2];      // By Cs Rai
                        //    isValid = true;
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

-(void)addMoreFile {
        
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



#pragma mark - Target Methods

-(IBAction)chooseFile:(id)sender {
        
        /*
        [self.view endEditing:YES];
        [self setDefaultTableHeight];

        UIButton* button=(UIButton*)sender;
        
        NSIndexPath *indexPath =[Alert getIndexPathWithButton:button table:self.tableView];
        
        __weak __typeof(self)weakSelf = self;
        
        [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
                
                NSMutableDictionary* dic;
                switch (level) {
                                
                        case 1: {
                                dic = [[arrMultipleArt objectAtIndex:indexPath.row] mutableCopy];
                                
                                [dic setObject:[Alert getNameForImage] forKey:@"path"];
                                [dic setObject:image forKey:@"image"];
                             

                        }
                                break;
                                
                        case 2: {
                                
                                dic = [[arrCertificates objectAtIndex:indexPath.section== 1 ? 0 : 1] mutableCopy];
                                
                                [dic setObject:[Alert getNameForImage] forKey:@"path"];
                                [dic setObject:image forKey:@"image"];
                                
                        }
                                break;
                                
                        default:
                                break;
                }
                
                [dic setObject:[Alert getNameForImage] forKey:@"path"];
                [dic setObject:image forKey:@"image"];
                NSLog(@"%@", arrCertificates);
                [Alert reloadSection:indexPath.section table:weakSelf.tableView];
                
        }];
        
        
        */
        
        
        
        
         UIButton* button=(UIButton *)sender;
        indexPathForMultipleArt = [Alert getIndexPathWithButton:button table:self.tableView];
        
        NSLog(@"The section %ld tapped", indexPathForMultipleArt.section);
        NSLog(@"The row %ld tapped", indexPathForMultipleArt.row);
        
        [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
                
                
                TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                cropController.delegate = self;
                [self presentViewController:cropController animated:YES completion:nil];
                
        }];

}

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
                                        /*
                                         case 4:
                                         {
                                         
                                         if(indexPath.row==0)
                                         [self addMoreYoutubeVideo];
                                         else
                                         [self removeYoutubeVideo:indexPath.row];
                                         }
                                         */
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

-(void)buttonCheckBoxTapped : (UIButton *)button {
        
       // [self setDefaultTableHeight];
        NSLog(@"Button Tapped with tag : %ld", button.tag);
        UIButton *btn  = (UIButton *)button;
        switch (button.tag) {
                        
                case 1003: {
                        
                        if (isThisYourArt) {
                                
                                self.strPurchaseTime = @"";
                                self.strDateStartAsAnArtist = @"";
                                [btn setImage:[UIImage imageNamed:@"multiselect_green.png"] forState:UIControlStateNormal];
                        } else {
                                
                                self.strPurchaseTime = @"";
                                self.strDateStartAsAnArtist = @"";
                                [btn setImage:[UIImage imageNamed:@"unselected_tick.png"] forState:UIControlStateNormal];
                        }
                        isThisYourArt = !isThisYourArt;
                        isTheArtAppraisedInThePast = NO;
                        // isTheArtAppraisedInThePast = !isThisYourArt ? isTheArtAppraisedInThePast = NO: isTheArtAppraisedInThePast;   // For unselecting 4th section if isThisArt unselected
                        
                        [self loadDataLevel2_2];
                        break;
                        
                }
                case 1004: {
                        if (isTheArtAppraisedInThePast) {
                                
                                [btn setImage:[UIImage imageNamed:@"multiselect_green.png"] forState:UIControlStateNormal];
                        } else {
                                self.strByDate = @"";
                                [btn setImage:[UIImage imageNamed:@"unselected_tick.png"] forState:UIControlStateNormal];
                                
                        }
                        isTheArtAppraisedInThePast = !isTheArtAppraisedInThePast;
                        
                        [self loadDataLevel2_3];
                        
                        break;
                }
                default:
                        break;
        }
        //                [self loadDataLevel2_2];
        [self.tableView reloadData];
        
        
}

-(IBAction)backMove:(id)sender{
        
        if(level<=1) return;
        level-=1;
        
        [self reSetStepIcon];
        
        [self.tableView reloadData];
}

-(IBAction)next:(id)sender {
        
        [self setDefaultTableHeight];
        
        if(![[EAGallery sharedClass]isLogin]) {
                
                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                
                LoginViewController*vc = GET_VIEW_CONTROLLER(kLoginViewController);
                vc.titleString=@"Login";
                
                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                
                return;
        }
        
        
        if(![self isValidateLevel]) return;
        
        if(level==3){
                
               // [self  valuationofArts];
                
        }
        if(level>=3) return;
        level+= 1;
        
        [self reSetStepIcon];
        [self.tableView reloadData];
        
}

// Non Premium Tapped
-(IBAction)submitButtonTapped:(id)sender {
        
        if(![self isValidateLevel])
                return;
        
//        if(level==3){
//                
//                [self  valuationofArts];
//                
//        }
        isPremium = NO;
        [self openPayPalView];
}

//  Premium Tapped

-(IBAction)prmiumButtonTapped:(id)sender {
        
        if(![self isValidateLevel]) return;
        
//        if(level==3){
//                
//                [self  valuationofArts];
//                
//        }
        isPremium = YES;
        [self openPayPalView];
}

-(void)buttonClickHereToViewTapped : (UIButton *)button {
        
        NSLog(@"Level 3's Button Tapped with tag : %ld", button.tag);
        
        switch (button.tag) {
                        
                case 1001:  // section 2 of level 3
                        
                        [self showPopup:self.strTermsOfServices];
                        break;
                        
                case 1005:  // section 2 of level 3
                        
                        [self showPopup:self.strTermsOfServicesNonPremium];
                        break;
                        
                case 1007:  // section 2 of level 3
                        
                        [self showPopup:self.strTermsOfServicesPremium];
                        break;
                        
                default:
                        
                        break;
        }
}


- (IBAction)buttonHidePopupTapped:(id)sender {
        
        self.viewPopup.hidden = YES;
        [self.viewPopup removeFromSuperview];
}

-(void)valuationofArts {
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:[[EAGallery sharedClass] memberID] forKey:@"user_id"];
        
        //Step 1 :
        [dic setObject:[[arrData1 objectAtIndex:0] objectForKey:@"value"] forKey:@"first_name"];
        [dic setObject:[[arrData1 objectAtIndex:1] objectForKey:@"value"] forKey:@"middle_name"];
        [dic setObject:[[arrData1 objectAtIndex:2] objectForKey:@"value"] forKey:@"last_name"];
        [dic setObject:[[arrData1 objectAtIndex:3] objectForKey:@"value"] forKey:@"email_id"];
        [dic setObject:[[arrData1 objectAtIndex:4] objectForKey:@"value"] forKey:@"phone_number"];
        
        
        //Step 2 :
        [dic setObject:[[arrData2 objectAtIndex:0] objectForKey:@"value"] forKey:@"artist_name"];
        [dic setObject:[[arrData2 objectAtIndex:1] objectForKey:@"value"] forKey:@"artwork_size"];
        [dic setObject:[[arrData2 objectAtIndex:2] objectForKey:@"value"] forKey:@"artwork_medium"];
        [dic setObject:[[arrData2 objectAtIndex:3] objectForKey:@"value"] forKey:@"artwork_complete"];
        
        //  Store new key value pair
        
        if (!isThisYourArt) {
                
                [dic setObject:[[arrData2_2 objectAtIndex:0] objectForKey:@"value"] forKey:@"art_purchased"];
                [dic setObject:[[arrData2_2 objectAtIndex:1] objectForKey:@"value"] forKey:@"it_purchansed"];
                [dic setObject:[[arrData2_2 objectAtIndex:2] objectForKey:@"value"] forKey:@"purchased_price"];
                
                // Set Blank string
                [dic setObject:@"" forKey:@"artist_started_date"];
                [dic setObject:@"" forKey:@"artwork_curr_price"];
                [dic setObject:@"" forKey:@"pieces_sold"];
                [dic setObject:@"" forKey:@"onine_advertise_source"];

        }
        if (isThisYourArt) {
                
                [dic setObject:[[arrData2_2 objectAtIndex:0] objectForKey:@"value"] forKey:@"artist_started_date"];
                
                [dic setObject:[[arrData2_2 objectAtIndex:1] objectForKey:@"value"] forKey:@"artwork_curr_price"];
                
                [dic setObject:[[arrData2_2 objectAtIndex:2] objectForKey:@"value"] forKey:@"pieces_sold"];
                
                [dic setObject:[[arrData2_2 objectAtIndex:3] objectForKey:@"value"] forKey:@"onine_advertise_source"];
                
                [dic setObject:@"" forKey:@"art_purchased"];
                [dic setObject:@"" forKey:@"it_purchansed"];
                [dic setObject:@"" forKey:@"purchased_price"];

                
        }
        if(!isTheArtAppraisedInThePast) {
        
                [dic setObject:@"" forKey:@"professionally_art_name"];        // By whom
                [dic setObject:@"" forKey:@"professionally_art_date"];      //By date
                
                [dic setObject:@"" forKey:@"gallery_sale"];
                [dic setObject:@"" forKey:@"gallery_exbihibited"];
        }
                
        if (!isThisYourArt && isTheArtAppraisedInThePast) {
                
                [dic setObject:[[arrData2_3 objectAtIndex:0] objectForKey:@"value"] forKey:@"professionally_art_name"];        // By whom
                [dic setObject:[[arrData2_3 objectAtIndex:1] objectForKey:@"value"] forKey:@"professionally_art_date"];      //By date
                
                [dic setObject:@"" forKey:@"gallery_sale"];
                [dic setObject:@"" forKey:@"gallery_exbihibited"];

                
        }
        if (isThisYourArt && isTheArtAppraisedInThePast) {
                
                [dic setObject:[[arrData2_3 objectAtIndex:0] objectForKey:@"value"] forKey:@"gallery_sale"];        // By whom
                [dic setObject:[[arrData2_3 objectAtIndex:1] objectForKey:@"value"] forKey:@"gallery_exbihibited"];      //By date
                
                
                [dic setObject:@"" forKey:@"professionally_art_name"];
                [dic setObject:@"" forKey:@"professionally_art_date"];
        }
        
        [dic setObject:isThisYourArt? @"1":@"0" forKey:@"is_this_your_art"];
        [dic setObject:isTheArtAppraisedInThePast?@"1":@"0" forKey:@"art_professional"];
        [dic setObject:@"1" forKey:@"currently_sell_your_work"];
        //Step 3 :
        
        [dic setObject:[[arrData3 objectAtIndex:0] objectForKey:@"value"] forKey:@"other_information"];
        
        //        NSNumber* s1=[[arrSelections objectAtIndex:0]objectForKey:@"value"];
        //        NSNumber* s2=[[arrSelections objectAtIndex:1]objectForKey:@"value"];
        //        NSNumber* s3=[[arrSelections objectAtIndex:2]objectForKey:@"value"];
        
        
        //        [dic setObject:[s1 stringValue] forKey:@"additional_agreement"];
        //        [dic setObject:[s2 stringValue] forKey:@"correct_info_agreement"];
        //        [dic setObject:[s3 stringValue] forKey:@"initial_opinion_agreement"];
        
        // Payememt Information keys
        
        [dic setObject:self.strTxnId forKey:@"txn_id"];
        [dic setObject:self.strAmount forKey:@"amount"];
  //      self.strPaymentStatus = [self.strPaymentStatus isEqualToString:@"completed"]?@"0":@"1";
   //     [dic setObject:self.strPaymentStatus forKey:@"payment_status"];
        self.strPaymentType = isPremium ? @"premium" : @"non premium";
        [dic setObject:self.strPaymentType forKey:@"type"];
        
        
        //imagename
        //imagedata
        //imagekey
        
        NSArray* arrArts= [self matchPathWithArray:arrMultipleArt];
        NSMutableArray* arrImages=[[NSMutableArray alloc]init];
        for (NSDictionary* dic in arrArts) {
                
                UIImage* image=[dic objectForKey:@"image"];
                NSString* fileName=[dic objectForKey:@"path"];
                NSData* imageData =image ? UIImageJPEGRepresentation(image, 90) : nil;
                
                if(imageData){
                        
                        NSMutableDictionary* imageDic=[NSMutableDictionary dictionary];
                        [imageDic setObject:imageData           forKey:@"imagedata"];
                        [imageDic setObject:fileName            forKey:@"imagename"];
                        [imageDic setObject:@"images[]"         forKey:@"imagekey"];
                        [arrImages addObject:imageDic];
                }
        }
        
        NSArray* arrCer= [self matchPathWithArray:arrCertificates];
        int i=1;
        for (NSDictionary* dic in arrCer) {
                
                UIImage* image=[dic objectForKey:@"image"];
                NSString* fileName=[dic objectForKey:@"path"];
                NSData* imageData =image ? UIImageJPEGRepresentation(image, 90) : nil;
                
                if(imageData){
                        
                        NSMutableDictionary* imageDic=[NSMutableDictionary dictionary];
                        [imageDic setObject:imageData                           forKey:@"imagedata"];
                        [imageDic setObject:fileName                            forKey:@"imagename"];
                        [imageDic setObject:i==1 ? @"authenticity_certificate" : @"photo_signature"         forKey:@"imagekey"];
                        [arrImages addObject:imageDic];
                }
                i++;
        }
       
        
        
        
        
        [self valuationOfArtWebService:[dic mutableCopy] images:arrImages.count? arrImages : nil];
        
        
        
}


#pragma mark PayPal Payment gateway

// Comment on 09 August
/*
-(void)updateAmountFromPayPalToServer {
        
        self.transactionDetails=nil;
        
        //    [self resetTransactionDetail];
        
        BOOL tran = [[NSUserDefaults standardUserDefaults] boolForKey:isTRANSACTION];
        
        if( tran)
        {
                self.transactionDetails=[[NSUserDefaults standardUserDefaults] objectForKey:TRANSACTION_DETAIL];
                self.transactionDetails=self.transactionDetails ? self.transactionDetails :nil;
                
                
        }
        
        if(self.transactionDetails!=nil)
        {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
  //              [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                
                [[self appDelegate] callUpdateTransactionDetailWS];
                //                });
                
        }
        else{
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedClass sharedObject] hudeHide];
                //                });
        }
}

*/

- (void)delayedDidFinish:(PayPalPayment *)completedPayment {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        //        //                {
        //        //                        client =     {
        //        //                                environment = sandbox;
        //        //                                "paypal_sdk_version" = "2.12.7";
        //        //                                platform = iOS;
        //        //                                "product_name" = "PayPal iOS SDK";
        //        //                        };
        //        //                        response =     {
        //        //                                "create_time" = "2015-12-05T10:05:56Z";
        //        //                                id = "PAY-6NJ65006RK451445LKZRLN7I";
        //        //                                intent = sale;
        //        //                                state = approved;
        //        //                        };
        //        //                        "response_type" = payment;
        //        //                }
        //
        dispatch_async(dispatch_get_main_queue(), ^{
                //                NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
                
                //PayPalItem *item1=completedPayment.items[0];
                
                NSDictionary* paymentDescription=[completedPayment.confirmation mutableCopy];
                
                NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
                [mutDictTransactionDetails setObject:[EAGallery sharedClass].memberID
                                              forKey:PAYPAL_TRANSACTION_MEMBER_ID];
                
                [mutDictTransactionDetails setObject:completedPayment.currencyCode
                                              forKey:PAYPAL_TRANSACTION_CURRENCY];
                
                [mutDictTransactionDetails setObject:[[paymentDescription objectForKey:@"response"] objectForKey:@"id"]
                                              forKey:PAYPAL_TRANSACTION_ID];
                
                [mutDictTransactionDetails setObject:@"credit"
                                              forKey:PAYPAL_TRANSACTION_TYPE];
                
                [mutDictTransactionDetails setObject:[completedPayment.amount stringValue]
                                              forKey:PAYPAL_TRANSACTION_AMOUNT];
                
                [mutDictTransactionDetails setObject:@"completed"
                                              forKey:PAYPAL_TRANSACTION_STATUS];
                
                [mutDictTransactionDetails setObject:@""        forKey:PAYPAL_TRANSACTION_CARD];
                
                [mutDictTransactionDetails setObject:[EAGallery sharedClass].name
                                              forKey:PAYPAL_TRANSACTION_BILLING_FIRST_NAME];
                
                [mutDictTransactionDetails setObject:@""        forKey:PAYPAL_TRANSACTION_BILLING_LAST_NAME];
                
                [mutDictTransactionDetails setObject:@""        forKey:PAYPAL_TRANSACTION_BILLING_ADDRESS];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_CITY];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_STATE];
                
                [mutDictTransactionDetails setObject:@""
                                              forKey:PAYPAL_TRANSACTION_BILLING_POST_CODE];
                
                [mutDictTransactionDetails setObject:[EAGallery sharedClass].country
                                              forKey:PAYPAL_TRANSACTION_BILLING_COUNTRY];
                
                [mutDictTransactionDetails setObject:[@"Credit Money" lowercaseString]
                                              forKey:PAYPAL_TRANSACTION_DESCRIPTION];
                
                [mutDictTransactionDetails setObject:[[paymentDescription objectForKey:@"response"] objectForKey:@"create_time"]
                                              forKey:PAYPAL_TRANSACTION_TIME];
                
                [mutDictTransactionDetails setObject:@"credit_card"
                                              forKey:PAYPAL_TRANSACTION_METHOD];
                
                
                //[mutDictTransactionDetails setObject:@""        forKey:@""];
                [self navigateToPaymentStatusScreen:mutDictTransactionDetails];
        });
}
//
- (void)navigateToPaymentStatusScreen: (NSMutableDictionary *)mutDictTransactionDetails {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isTRANSACTION ];//:isYES                      forKey:isTRANSACTION];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:mutDictTransactionDetails  forKey:TRANSACTION_DETAIL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        //        });
        
        self.strTxnId = [mutDictTransactionDetails objectForKey:@"transaction_id"];
        self.strPaymentStatus = [mutDictTransactionDetails objectForKey:@"transaction_status"];
        self.strAmount = [mutDictTransactionDetails objectForKey:@"transaction_amount"];
        [[SharedClass sharedObject]hudeHide];
        [self  valuationofArts];
        
}

//
//
#pragma mark -PayPal

-(void)configPayPal {
        
 //       self.title = @"PayPal";
        
        // Set up payPalConfig
        _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
        _payPalConfig.acceptCreditCards = YES;
#else
        _payPalConfig.acceptCreditCards = YES;
#endif
        _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
        
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //        self.successView.hidden = YES;
        
        // use default environment, should be Production in real life
        self.environment = kPayPalEnvironment;
        
        NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}




- (BOOL)acceptCreditCards {
        
        return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
        
        self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)setPayPalEnvironment:(NSString *)environment {
        
        self.environment = environment;
        [PayPalMobile preconnectWithEnvironment:environment];
}



#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
        
        NSLog(@"PayPal Payment Success!");
        
        //        [self performSelector:@selector(delayedDidFinish:) withObject:completedPayment afterDelay:0.0];
        
        [self delayedDidFinish:completedPayment];
        
        self.resultText = [completedPayment description];
        
        
        
        
        //        [self showSuccess];
        
        [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                //Set Transaction detail on Local server
                // Comment on 09 Aug
             //   [self updateAmountFromPayPalToServer];
                
        });
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
        
        NSLog(@"PayPal Payment Canceled");
        self.resultText = nil;
        //   self.successView.hidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
        // TODO: Send completedPayment.confirmation to server
        NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

//#pragma mark PayPalProfileSharingDelegate methods
//
//- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
//             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
//        NSLog(@"PayPal Profile Sharing Authorization Success!");
//        self.resultText = [profileSharingAuthorization description];
//        [self showSuccess];
//
//        [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
//        [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
//        NSLog(@"PayPal Profile Sharing Authorization Canceled");
//        self.successView.hidden = YES;
//        [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
//        // TODO: Send authorization to server
//        NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
//}
//
//
//#pragma mark - Helpers
//
//- (void)showSuccess {
//        self.successView.hidden = NO;
//        self.successView.alpha = 1.0f;
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationDelay:2.0];
//        self.successView.alpha = 0.0f;
//        [UIView commitAnimations];
//}
//
//


//#pragma mark- Open PayPal view
-(void)openPayPalView {
        
        // Remove our last completed payment, just for demo purposes.
        self.resultText = nil;
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        
        
        //       NSString* amountString = @"299";
        
        NSString* amountString = isPremium ? @"249" : @"99";
        
        PayPalItem *item1 = [PayPalItem itemWithName:@"Add Amount"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:amountString]
                                        withCurrency:@"USD"
                                             withSku:@"EastonArtGalleries-Sku"];
        /*
         PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
         withQuantity:1
         withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
         withCurrency:@"USD"
         withSku:@"Hip-00066"];
         PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
         withQuantity:1
         withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
         withCurrency:@"USD"
         withSku:@"Hip-00291"];
         NSArray *items = @[item1, item2, item3];
         NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
         
         // Optional: include payment details
         NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
         NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
         PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
         withShipping:shipping
         withTax:tax];
         
         NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
         */
        
        NSDecimalNumber *amount = [[NSDecimalNumber alloc] initWithString:amountString];
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = amount;
        payment.currencyCode = @"USD";
        payment.shortDescription = @"Credit Money";
        payment.items = @[item1];  // if not including multiple items, then leave payment.items as nil
        payment.paymentDetails = nil; // if not including payment details, then leave payment.paymentDetails as nil
        
        if (!payment.processable) {
                // This particular payment will always be processable. If, for
                // example, the amount was negative or the shortDescription was
                // empty, this payment wouldn't be processable, and you'd want
                // to handle that here.
        }
        
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc]
                                                              initWithPayment:payment
                                                              configuration:self.payPalConfig
                                                              delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];
        amount=nil;
        payment=nil;
        item1=nil;
        amountString=nil;
}
//
//
//- (IBAction)paypal:(id)sender {
//
//
//
//        //NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
//        //NSString* balance=[userData valueForKey:USER_DATA_CREDIT_BALANCE];
//
//        if(isUpdate ){
//
//                [self openPayPalView];
//        }
//        else{
//                [Alert alertWithMessage:@"Please enter amount first !"
//                             navigation:self.navigationController
//                               gotoBack:NO animation:YES second:3.0];
//        }
//}
//
//- (IBAction)updateTransaction:(id)sender {
//
//        //Set Transaction detail on Local server
//        [self updateAmountFromPayPalToServer];
//
//        //[self updateTransactionDetails];
//
//        /*
//         [UIView transitionWithView:self.view
//         duration:0.3
//         options:UIViewAnimationOptionTransitionCrossDissolve
//         animations:^{
//
//
//         }
//         completion:^(BOOL finish){
//         [[SharedClass sharedObject] hudeHide];
//
//         [self configure];
//         [self.tableView reloadData];
//
//         }];
//         */
//
//
//}



-(void)createDatePicker:(BOOL)isList items:(NSArray*)list sender:(id)sender datePickerMode:(UIDatePickerMode) datePickerMode {
        
        [self.view endEditing:YES];
        [self setDefaultTableHeight];
        
        cDatePicker=[[CustomDatePickerViewController alloc]initWithNibName:kCustomDatePickerViewController bundle:nil];

        cDatePicker.delegate = self;
        cDatePicker.isCustomList = isList;
        cDatePicker.arrItems =  isList ? list :nil;
        cDatePicker.sender = sender;
        cDatePicker.datePickerMode = datePickerMode;
        cDatePicker.setDate = [NSDate date];
        [cDatePicker setPickerList];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        
        fullScreen = [[UIView alloc]initWithFrame:screenRect];
        fullScreen.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        //        CGRect fr=cDatePicker.view.frame;
        //        fr.size=self.view.bounds.size;
        //        cDatePicker.view.frame=fr;
        
        [fullScreen addSubview:cDatePicker.view];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:fullScreen];
        
        //    [self.view addSubview:cDatePicker.view];
}

-(void)removeDatePicker {
        
        [fullScreen removeFromSuperview];
        [cDatePicker.view removeFromSuperview];
        fullScreen=nil;
        cDatePicker=nil;
        
        
}

#pragma mark - DatePicker Custom Delegate methods

-(void)selectDateFromDatePicker:(NSDate *)date sender:(id)sender {
        
        UITextField *txtField = (UITextField *)sender;
        
        NSIndexPath *indexPath = [Alert getIndexPathWithTextfield:txtField table:self.tableView];
        
        [self removeDatePicker];
        NSLog(@"Selected Date->%@", date);
        
        
        if(level == 2) {
                
                if(indexPath.section == 0) {
                
                        NSMutableDictionary *dic = [arrData2 objectAtIndex:3];
                        [dic setObject:[self getStringFromDate:date] forKey:@"value"];
                        
                }
                
                if (indexPath.section == 3) {
                        
                        NSMutableDictionary* dic = [arrData2_2 objectAtIndex:0];
                        
                        if (isThisYourArt) {
                                
                                self.strDateStartAsAnArtist = [self getStringFromDate:date];
                                [dic setObject:self.strDateStartAsAnArtist forKey:@"value"];
                        }else {
                                
                                self.strPurchaseTime = [self getStringFromDate:date];
                                [dic setObject:self.strPurchaseTime forKey:@"value"];
                                
                        }
                        
                }
                else if (indexPath.section == 4) {
                        
                        NSMutableDictionary* dic = [arrData2_3 objectAtIndex:1];
                        self.strByDate = [self getStringFromDate:date];
                        
                        [dic setObject:self.strByDate forKey:@"value"];
                        
                }
                
        }
        
        [self.tableView reloadData];
        [self.tableView isScrollEnabled];
}

-(NSString *)getStringFromDate : (NSDate *)date {
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        return stringFromDate;
}

-(void)cancelDateFromDatePicker:(id)sender {
        
        [self removeDatePicker];
        // [txtCountry becomeFirstResponder];
}


#pragma mark - Cropper Delegate Method -

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
        
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(0, 100.0, 40.0, 40.0) completion:^{
                        __weak __typeof(self)weakSelf = self;
     
                NSMutableDictionary* dic;
                switch (level) {
                                
                        case 1:
                                dic = [arrMultipleArt objectAtIndex:indexPathForMultipleArt.row];
                                break;
                        case 2: {
                                
                                if (indexPathForMultipleArt.section == 1) {
                                        
                                        dic = [arrCertificates objectAtIndex:0];
                                } else if (indexPathForMultipleArt.section == 2) {
                                        dic = [arrCertificates objectAtIndex:1] ;
                                }
                        }
                                break;
                                
                        default:
                                break;
                }
                
                [dic setObject:[Alert getNameForImage] forKey:@"path"];
                [dic setObject:image forKey:@"image"];
                [Alert reloadSection:indexPathForMultipleArt.section table:weakSelf.tableView];
        }];
        
}



@end