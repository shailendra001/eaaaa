//
//  UpdateProfileViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "UpdateProfileViewCell.h"
#import "UpdateProfileViewCell1.h"
#import "UpdateProfileViewCell2.h"
#import "UpdateProfileViewCell3.h"
#import "UpdateProfileViewCell4.h"
#import "UpdateProfileViewCell5.h"
#import "TOCropViewController.h"

#define COLOR_CELL_BACKGROUND           @"#DEDEDD"
#define COLOR_CELL_HEADER               @"#D4D4D4"
#define COLOR_CELL_TEXT                 @"#575656"
#define COLOR_CELL_TEXT_LINK            @"#BD5B5F"
#define SELECT_OPTION                   @"* Select Country"
#define PLACEHOLDER_MESSAGE             @"Bio"
#define PLACEHOLDER_MESSAGE_YOUTUBE     @"Youtube Link"

#define KEYBOARD_HEIGHT                 216
#define BOTTOM_HEIGHT                   54



@interface UpdateProfileViewController ()<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate,UITextFieldDelegate,PickerViewDelegate,UITextViewDelegate, TOCropViewControllerDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSArray* arrIcon;
        NSMutableArray* arrData;
        BOOL isUpdate;
        BOOL isUpdateHeight;
        NSMutableArray* arrTextData;
        
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        NSString* selectedCountry;
        NSArray* arrCountryList;
        UIImage* selectedProfileImage;
        UIImage* selectedCoverImage;
        BOOL isProfilePic;
        BOOL isCoverPic;
        
        NSData* profilePicData;
        NSData* coverPicData;
        
        id countrySender;
        NSInteger indexOfLatestUploadedImage;

}


@end

@implementation UpdateProfileViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";
static NSString *CellIdentifier5 = @"Cell5";
static NSString *CellIdentifier6 = @"Cell6";

#pragma mark - View controller life cicle

- (void)viewDidLoad {
   
        [super viewDidLoad];
        
        [self cellRegister];
        
        [self countryList];
        
       
        
        [self config];
        
        
        /*[self setLogoImage];
         
         //[self rightNavBarConfiguration];
         
         if(YES)
         {
         
         //[self setActivityIndicator];
         
         //                [self getWebService];
         }
         
         
         if([self.from isEqualToString:@"back"]) [self setNav];
         else                                    [self navigationBarConfiguration];
         */

}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        if(!isUpdate){
                [self loadData];
        }
        [self.tableView reloadData];
        
        
        
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

-(void)config{
        
        
        //self.lblTitle.text=[self.titleString uppercaseString];
        // self.viContainerTitleBar.hidden=YES;
        
        
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        //        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        
        
        
        
}

-(void)loadData{
        
        
        
        {
                arrData=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"Name :"                                        forKey:@"title"];
                [dic setObject:@"* Name"                                        forKey:@"msg"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Username :"                                    forKey:@"title"];
                [dic setObject:@"* Username"                                    forKey:@"msg"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Phone :"                                       forKey:@"title"];
                [dic setObject:@"* Phone"                                       forKey:@"msg"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Country :"                                     forKey:@"title"];
                [dic setObject:@"* Country"                                     forKey:@"msg"];
                [dic setObject:@"globe.png"                                     forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Biography :"                                   forKey:@"title"];
                [dic setObject:@""                                              forKey:@"msg"];
                [dic setObject:@"biography.png"                                 forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Choose Profile image :"                        forKey:@"title"];
                [dic setObject:@""                                              forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                [dic1 setObject:@"Choose Cover image :"                          forKey:@"title"];
                [dic1 setObject:@""                                              forKey:@"msg"];
                [dic1 setObject:@""                                              forKey:@"icon"];
                [dic1 setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic1];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Youtube Video :"                               forKey:@"title"];
                [dic setObject:@"Youtube Link"                                  forKey:@"msg"];
                [dic setObject:@""                                              forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                

                
                
                
        }
        
        {
                arrTextData=[[NSMutableArray alloc]init];
                
                for (int i=0; i<6; i++) {
                        NSString* text=@"";
                        switch (i) {
                                case 0:
                                        text=[[EAGallery sharedClass] name];
                                        break;
                                case 1:
                                        text=[[EAGallery sharedClass] userName];
                                        break;
                                case 2:
                                        text=[[EAGallery sharedClass] phone];
                                        break;
                                case 3:
                                        text=IS_EMPTY([[EAGallery sharedClass] country]) ? SELECT_OPTION : [[EAGallery sharedClass] country] ;
                                        break;
                                case 4:
                                        text=IS_EMPTY([[EAGallery sharedClass] bio]) ? PLACEHOLDER_MESSAGE : [[EAGallery sharedClass] bio] ;
                                        break;
                                case 5:
                                        text=@"";
                                        break;
                                default:
                                        text=@"";
                                        break;
                        }
                        
                        [arrTextData addObject:text];
                }
                
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

-(void)cellRegister{
        
        [self.tableView registerClass:[UpdateProfileViewCell class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[UpdateProfileViewCell1 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[UpdateProfileViewCell2 class] forCellReuseIdentifier:CellIdentifier3];
        [self.tableView registerClass:[UpdateProfileViewCell3 class] forCellReuseIdentifier:CellIdentifier4];
        [self.tableView registerClass:[UpdateProfileViewCell4 class] forCellReuseIdentifier:CellIdentifier5];
        [self.tableView registerClass:[UpdateProfileViewCell5 class] forCellReuseIdentifier:CellIdentifier6];

        UINib *contantsCellNib1 = [UINib nibWithNibName:@"UpdateProfileViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"UpdateProfileViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"UpdateProfileViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        UINib *contantsCellNib4= [UINib nibWithNibName:@"UpdateProfileViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        UINib *contantsCellNib5= [UINib nibWithNibName:@"UpdateProfileViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib5 forCellReuseIdentifier:CellIdentifier5];
        UINib *contantsCellNib6= [UINib nibWithNibName:@"UpdateProfileViewCell5" bundle:nil];
        [self.tableView registerNib:contantsCellNib6 forCellReuseIdentifier:CellIdentifier6];
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
        
        //self.tableView.backgroundView = messageLabel;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)removeBackgroundLabel{
        //self.tableView.backgroundView = nil;
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

-(void)countryList{
        //    arrCountryList=[[NSArray alloc]init];
        
        NSDictionary* country=[Alert getCountryFromServerData];
        if(country){
                
                arrCountryList=[[country allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        
        
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
        
        
        if ([[url scheme] hasPrefix:@"action"]) {
                if ([[url host] hasPrefix:@"Open"]) {
                        
                        NSLog(@"Click here ");
                        
                        /* load help screen */
                } else if ([[url host] hasPrefix:@"show-settings"]) {
                        /* load settings screen */
                }
        } else {
                /* deal with http links here */
        }
}


-(void)createDatePicker:(BOOL)isList items:(NSArray*)list sender:(id)sender{
        
        cDatePicker=[[CustomDatePickerViewController alloc]initWithNibName:kCustomDatePickerViewController bundle:nil];
        
        cDatePicker.delegate=self;
        cDatePicker.isCustomList=isList;
        cDatePicker.arrItems= isList ? list :nil;
        cDatePicker.sender=sender;
        
        [cDatePicker setPickerList];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        
        fullScreen=[[UIView alloc]initWithFrame:screenRect];
        fullScreen.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
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


#pragma mark - Remove to selectd Video

- (void) didSelectItemRemove:(id)sender{
        
        //video
        
//        {"id":"123"}   ( id = userid)
        
        NSMutableDictionary* videoDic=[NSMutableDictionary dictionary];
        [videoDic setObject:[EAGallery sharedClass].memberID    forKey:@"id"];
        
        [self removeYoutubeVideoWebService:[videoDic mutableCopy]];
        
}

#pragma mark - Play selected Youtube Video

- (void) didSelectYoutubeVideo:(id)sender{
        
        NSLog(@"%@",[EAGallery sharedClass].profileVideo);
        NSString* fileName=[[EAGallery sharedClass].profileVideo lastPathComponent];
        
        //video
        NSArray*arr=[fileName componentsSeparatedByString:@"="];
        NSString*videoID=arr.count==2 ? arr[1] : nil;
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
        //                videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
        videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        
        
        
}

#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
        MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (finishReason == MPMovieFinishReasonPlaybackError)
        {
                NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
                NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
                NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
                NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
                [alertView show];
        }
}




#pragma mark - DatePicker Custom Delegate methods

-(void)selectDateFromDatePicker:(NSDate *)date sender:(id)sender{
        
        NSLog(@"Selected Date->%@",date);
        selectedDate=date;
//        lblAge.text=[NSString stringWithFormat:@"+%d",[Alert calculateAge:date]];
        
        
//        txtDOB.text=[Alert getDateWithString:[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date]
//                                   getFormat:GET_FORMAT_TYPE
//                                   setFormat:SET_FORMAT_TYPE1];
        
        
        
        [self removeDatePicker];
        
        //[txtCountry becomeFirstResponder];
}

-(void)cancelDateFromDatePicker:(id)sender{
        
        [self removeDatePicker];
        // [txtCountry becomeFirstResponder];
}

#pragma mark - Custom List Item Picker Delegate Methods

-(void)selectItemFromList:(NSString *)item sender:(id)sender{
        
        NSLog(@"Selected item->%@",item);
        UIButton* button=(UIButton*)sender;
        selectedCountry=item;
        
        [self removeDatePicker];
        
        
        
        NSLog(@"Country Key->[%@]",[Alert getSelectedCountryKeyWithValue:selectedCountry]);
        NSLog(@"Country Value->[%@]",[Alert getSelectedCountryValueWithKey:[Alert getSelectedCountryKeyWithValue:selectedCountry]]);
        
        arrTextData[button.tag]=selectedCountry;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        countrySender=nil;
}

-(void)cancelItemFromCustomList:(id)sender{
        [self removeDatePicker];
        countrySender=nil;
}

#pragma mark -Call WebService

-(void)getWebService:(NSDictionary*)dic images:(NSArray*)images{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_UpdateProfile);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
//                if(profilePicData || coverPicData)
//                        postString=[@"data=" stringByAppendingString:postString];                
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                NSMutableURLRequest *theRequest=[Alert getRequestUploadImageWithPostString:postString
                                                                                 urlString:urlString
                                                                                    images:images];
                
                
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
                                                                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                                                                 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [self removeActivityIndicator];
                                [[SharedClass sharedObject] hudeHide];
                                
                        });
                        
                        if ([result isKindOfClass:[NSNull class]] ||result == nil)
                        {
                                //[self alerMessage];
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
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        
                                        NSDictionary*resPonsedata = (NSDictionary*)[result valueForKey:@"data"];
                                        resPonsedata = [Alert dictionaryByReplacingNullsWithString:@"" dic:resPonsedata];
                                        
                                        if(isProfilePic)
                                                [EAGallery sharedClass].profileImage=[result valueForKey:@"profileImage"];
                                        if(isCoverPic)
                                                [EAGallery sharedClass].coverImage=[result valueForKey:@"coverImage"];
                                        
                                        
                                        
                                        
                                        [EAGallery sharedClass].name    =[arrTextData objectAtIndex:0];
                                        [EAGallery sharedClass].userName=[arrTextData objectAtIndex:1];
                                        [EAGallery sharedClass].phone   =[arrTextData objectAtIndex:2];
                                        [EAGallery sharedClass].country =[arrTextData objectAtIndex:3];
                                        [EAGallery sharedClass].bio     =[[arrTextData objectAtIndex:4]isEqualToString:PLACEHOLDER_MESSAGE] ?
                                                                                @"" :[arrTextData objectAtIndex:4];
                                        
                                        [EAGallery sharedClass].profileVideo     =[dic objectForKey:LOGIN_VIDEO_LINK];
                                        
                                        [[EAGallery sharedClass] saveDataLocal];
                                        
                                        
                                        isUpdate=isProfilePic=NO;
                                        [self loadData];
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [UIView transitionWithView:self.tableView
                                                                  duration:0.3
                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                 
                                                                animations:nil
                                                                completion:nil];
                                                
                                                
                                                
                                                [self.tableView reloadData];
                                                
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        
                                }
                                
                                else{
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

-(void)getCountryListWebService{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_CountryList);
                
//                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                NSLog(@" tempURL :%@---",urlString);
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:nil
                                                                       urlString:urlString
                                                                      methodType:@"GET"
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
                        countrySender=nil;
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
                                
                                countrySender=nil;
                        }
                        else
                        {
                                
                                //NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        NSDictionary*resPonsedata = (NSDictionary*)[result valueForKey:@"data"];
                                        
                                        [[NSUserDefaults standardUserDefaults]setObject:[resPonsedata objectForKey:COUNTRY_LIST] forKey:COUNTRY_LIST];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        [self countryList];
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                if(arrCountryList.count)
                                                        [self createDatePicker:YES items:arrCountryList sender:countrySender];
                                                
                                        });
                                        
                                        
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:3.0];
                                        });
                                        countrySender=nil;
                                        
                                }
                                else{
                                        countrySender=nil;
                                }
                                
                                
                        }
                        
                }
                
        });
        
}

-(void)removeYoutubeVideoWebService:(NSDictionary*)dic{
        
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_RemoveYoutubeVideo);
                
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
                                        
                                        //Video remove
                                        
                                        [EAGallery sharedClass].profileVideo=@"";
                                        
                                        [[EAGallery sharedClass] saveDataLocal];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                [Alert reloadSection:3 table:self.tableView];
                                                
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
                CGRect rect = CGRectMake(0,0,320,44);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        
        return result;
        
}


#pragma Mark Navigation Bar Configuration Code

-(void)navigationBarConfiguration{
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setBackgroundImage:[[self setNavBarImage]
                                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch]
                                                      forBarMetrics:UIBarMetricsDefault];
        UIButton * menuButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        menuButton.frame = CGRectMake(8, 20, 24, 18);
        [menuButton setBackgroundImage:[UIImage imageNamed:MENU_IMAGE] forState:UIControlStateNormal];
        
        //    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *accountBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        self.navigationItem.leftBarButtonItem = accountBarItem;
        //[self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTranslucent:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        switch (section) {
                case 0:
                        rows=4;
                        break;
                case 1:
                        rows=1;
                        break;
                case 2:
                        rows=2;
                        break;
                case 3:
                        rows=1;
                        break;
                case 4:
                        rows=1;
                        break;
                        
                default:
                        break;
        }
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        NSInteger height=0;
        switch (indexPath.section) {
                case 0:
                        height=44.0f;
                        break;
                case 1:
                        height=131.0f;
                        break;
                        
                case 2:
                        height=64.0f;
                        break;
                        
                case 3:
                        height=77.0f;
                        break;
                case 4:
                        height=41.0f;
                        break;
                        
                default:
                        break;
        }
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if(indexPath.section==0) {
                
                switch (indexPath.row) {
                                
                        case 0:
                        case 1:
                        case 2:
                                {
                                NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                                
                                UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                cell.contentView.backgroundColor=[UIColor whiteColor];
                                
                                cell.lblTitle.text=[item objectForKey:@"title"];
                                cell.lblTitle.tintColor=[UIColor blackColor];
                                
                                cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                                        
                                cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                                cell.txtName.text=[arrTextData objectAtIndex:indexPath.row];
                                cell.txtName.delegate=self;
                                [Alert attributedString:cell.txtName
                                                    msg:[item objectForKey:@"msg"]
                                                  color:[item objectForKey:@"color"]];
                                cell.txtName.tag=indexPath.row;
                                cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                                [cell.txtName addTarget:self
                                                 action:@selector(textFieldDidChange:)
                                       forControlEvents:UIControlEventEditingChanged];
                                cell.txtName.tintColor=[UIColor blackColor];
                                
                                cell.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
                                        
                                return cell;
                                
                        }
                                break;
                        case 3:
                                {
                                        
                                NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                                UpdateProfileViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                cell.contentView.backgroundColor=[UIColor whiteColor];
                                        
                                        
                                cell.lblTitle.text=[item objectForKey:@"title"];
                                cell.lblTitle.tintColor=[UIColor blackColor];
                                
                                cell.lblName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                                
                                NSString* text=[arrTextData objectAtIndex:indexPath.row];
                                
                                cell.lblName.text=text;
                                
                                cell.lblName.textColor= [text isEqualToString:SELECT_OPTION] ? [Alert colorFromHexString:COLOR_CELL_TEXT] : [UIColor blackColor];
                                
                                cell.lblName.tag        =
                                cell.btnSelect.tag      =indexPath.row;
                                
                                
                                [cell.btnSelect addTarget:self
                                                   action:@selector(selectCountry:)
                                         forControlEvents:UIControlEventTouchUpInside];
                                
                                return cell;
                                
                        }
                                break;
                        default:
                                break;
                }
                
                
                
        }
        else if (indexPath.section==1) {
                
               //NSDictionary *item = [arrData objectAtIndex:indexPath.row+3];
                
                UpdateProfileViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor=[UIColor whiteColor];
                
//                cell.img.hidden=YES;
                
                
                NSInteger rows=[tableView numberOfRowsInSection:0];
                
                NSString* text=[arrTextData objectAtIndex:indexPath.row+rows];
                NSDictionary *item = [arrData objectAtIndex:indexPath.row+rows];
                
                cell.lblTitle.text=[item objectForKey:@"title"];
                cell.lblTitle.tintColor=[UIColor blackColor];
                cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                
                
                cell.vitxtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                cell.vitxtName.text=text;
                cell.vitxtName.textColor=[text isEqualToString:PLACEHOLDER_MESSAGE] ?  [Alert colorFromHexString:COLOR_CELL_TEXT]:[UIColor blackColor];
                cell.vitxtName.tag=indexPath.row;
                cell.vitxtName.delegate=self;
                
                
                return cell;
        }
        else if (indexPath.section==2) {
                
                UpdateProfileViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor=[UIColor whiteColor];
                
                
                NSInteger rows1=[tableView numberOfRowsInSection:0];
                NSInteger rows2=[tableView numberOfRowsInSection:1];
                
                NSDictionary *item = [arrData objectAtIndex:indexPath.row+rows1+rows2];
                
                cell.lblTitle.text=[item objectForKey:@"title"];
                cell.lblTitle.tintColor=[UIColor blackColor];
                cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                
                NSString* imgURL;
                
                if(indexPath.row==0){
                        
                        imgURL=[[EAGallery sharedClass] profileImage];
                        imgURL=isProfilePic ? @"": imgURL ;
                        cell.img.image=isProfilePic ? selectedProfileImage : nil;
                        
                }
                else if(indexPath.row==1){
                        
                        imgURL=[[EAGallery sharedClass] coverImage];
                        imgURL=isCoverPic ? @"": imgURL ;
                        cell.img.image=isCoverPic ? selectedCoverImage : nil;
                }
                
                NSURL* url=[NSURL URLWithString:IS_EMPTY(imgURL) ? nil  :  imgURL ];
                
                
                for (id view in cell.contentView.subviews) {
                        
                        if([view isKindOfClass:[UIActivityIndicatorView class]])
                                [view removeFromSuperview];
                }
                
                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator1.frame = CGRectMake(cell.viContainerImage.frame.size.width/2-15,
                                                     cell.viContainerImage.frame.size.height/2-15,
                                                     30,
                                                     30);
                [activityIndicator1 startAnimating];
                activityIndicator1.tag=indexPath.row;
                
                [activityIndicator1 removeFromSuperview];
                if(url){
                        
                        
                        [cell.viContainerImage addSubview:activityIndicator1];
                        [cell.viContainerImage insertSubview:cell.img atIndex:0];//Bottom level
                        [cell.viContainerImage insertSubview:activityIndicator1 atIndex:1];//middle level
                        [cell.viContainerImage insertSubview:cell.btnSelect atIndex:2];//Top level
                }
                
                cell.img.backgroundColor=[UIColor whiteColor];
                
                
                UIImage* imgPlaceHolder=[UIImage imageNamed:@"default_user.png"];
                
                __weak UIImageView *weakImgPic = cell.img;
                [cell.img setImageWithURL:url
                         placeholderImage:cell.img.image==nil ? imgPlaceHolder : cell.img.image
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
                
                
                if((indexPath.row==0 && isProfilePic) || (indexPath.row==1 && isCoverPic)){
                        cell.img.layer.borderWidth=2.0;
                        cell.img.layer.borderColor=[UIColor greenColor].CGColor;
                }
                else{
                        cell.img.layer.borderWidth=0.0;
                        cell.img.layer.borderColor=[UIColor whiteColor].CGColor;
                }
                
                cell.btnSelect.tag=indexPath.row;
                [cell.btnSelect addTarget:self action:@selector(choosePic:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
        }
        else if (indexPath.section==3){
                
                UpdateProfileViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor=[UIColor whiteColor];
                
                for (id view in cell.viContainerVideoPart.subviews) {
                        
                        if([view isKindOfClass:[UIActivityIndicatorView class]])
                                [view removeFromSuperview];
                }
                
                for (id view in cell.contentView.subviews) {
                        
                        if([view isKindOfClass:[UIActivityIndicatorView class]])
                                [view removeFromSuperview];
                }
                
                
                NSInteger rows1=[tableView numberOfRowsInSection:0];
                NSInteger rows2=[tableView numberOfRowsInSection:1];
                NSInteger rows3=[tableView numberOfRowsInSection:2];
                
                NSDictionary *item = [arrData objectAtIndex:indexPath.row+rows1+rows2+rows3];
                
                cell.txtField.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:10];
                cell.txtField.text=[arrTextData objectAtIndex:indexPath.row+rows1+rows2];
                cell.txtField.delegate=self;
                [Alert attributedString:cell.txtField
                                    msg:[item objectForKey:@"msg"]
                                  color:[item objectForKey:@"color"]];
                cell.txtField.tag=indexPath.row;
                cell.txtField.autocorrectionType=UITextAutocorrectionTypeNo;
                [cell.txtField addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
                cell.txtField.tintColor=[UIColor blackColor];
                
                
                //Video Part
                cell.viContainerVideoLink.hidden=IS_EMPTY([EAGallery sharedClass].profileVideo) ? YES : NO;
                
                
                if(!IS_EMPTY([EAGallery sharedClass].profileVideo)){
                        UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        activityIndicator1.frame = CGRectMake(cell.imgPhoto.frame.size.width/2-15,
                                                              cell.imgPhoto.frame.size.height/2-15,
                                                              30,
                                                              30);
                        [activityIndicator1 startAnimating];
                        activityIndicator1.tag=indexPath.row;
                        
                        [activityIndicator1 removeFromSuperview];
                        
                        [cell.viContainerVideoPart addSubview:activityIndicator1];
                        [cell.viContainerVideoPart insertSubview:activityIndicator1 aboveSubview:cell.imgPhoto];
                        
                        
                        NSString* fileName=[[EAGallery sharedClass].profileVideo lastPathComponent];
                        NSArray*arr=[fileName componentsSeparatedByString:@"="];
                        NSString*thumbnail=arr.count==2 ? arr[1] : @"";
                        NSURL* url=[NSURL URLWithString:[Alert getYoutubeVideoThumbnail:thumbnail]];
                        
                        cell.imgPhoto.contentMode=UIViewContentModeScaleAspectFit;
                        cell.imgPhoto.backgroundColor=[UIColor whiteColor];
                        
                        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
                        
                        __weak UIImageView *weakImgPic = cell.imgPhoto;
                        [cell.imgPhoto setImageWithURL:url
                                          placeholderImage:imgPlaceHolder
                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
                         {
                                 [activityIndicator1 stopAnimating];
                                 [activityIndicator1 removeFromSuperview];
                                 
                                 UIImageView *strongImgPic = weakImgPic;
                                 if (!strongImgPic) return;
                                 
                                 strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                                 
                                 [UIView transitionWithView:strongImgPic
                                                   duration:0.3
                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                  
                                                 animations:^{
                                                         strongImgPic.image=image;
                                                         
                                                 }
                                                 completion:^(BOOL finish){
                                                         
                                                 }];
                                 
                         } failure:NULL];
                        
                        [cell.btnOpenMedia addTarget:self action:@selector(didSelectYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnRemove addTarget:self action:@selector(didSelectItemRemove:) forControlEvents:UIControlEventTouchUpInside];
                        
                }
                
                cell.lblTitle.text=[item objectForKey:@"title"];
                cell.lblTitle.tintColor=[UIColor blackColor];
//                cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                
                
                return cell;
        }
        else if (indexPath.section==4){
                
                UpdateProfileViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor=[UIColor whiteColor];
                cell.btnClick.tag=indexPath.row;
                [cell.btnClick addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
        }

        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}


#pragma Mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        
        [textField resignFirstResponder];
        
        
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - KEYBOARD_HEIGHT-10);
        }
        
//        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:0];
        NSIndexPath* indexPath=[Alert getIndexPathWithTextfield:textField table:self.tableView];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        
        return YES;
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
        
        
        
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
        
        UpdateProfileViewCell * cell;
        NSIndexPath* indexPath=[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
        if(indexPath.row==0 && indexPath.section==0 && !IS_EMPTY(textField.text)){
                BOOL isName=[Alert validationString:textField.text];
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
                        [cell.txtName becomeFirstResponder];
                        
                }
        }
        if(indexPath.row==1 && indexPath.section==0 && !IS_EMPTY(textField.text)){
                BOOL isUserName=[Alert validationName:textField.text];
                
                if(!isUserName){
                        [Alert alertWithMessage:@"Invalid Username ! Please enter valid Username."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
                        [cell.txtName becomeFirstResponder];
                        
                }
        }
        if(indexPath.row==2 && indexPath.section==0 && !IS_EMPTY(textField.text)){
                BOOL isPhone=[Alert validateMobileNumber:textField.text];
                
                if(!isPhone){
                        [Alert alertWithMessage:@"Invalid Phone number ! Please enter valid phone number."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
//                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
//                        [cell.txtName becomeFirstResponder];
                        
//                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
        }
        if(indexPath.row==0 && indexPath.section==3 && !IS_EMPTY(textField.text)){
//                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
                
        }
        
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-BOTTOM_HEIGHT-10);
                
                
                //                [UIView transitionWithView:self.tableView
                //                                  duration:0.3
                //                                   options:UIViewAnimationOptionTransitionCrossDissolve
                //
                //                                animations:nil
                //                                completion:nil];
        }
        
        isUpdateHeight=NO;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender{
        isUpdate=YES;
        UITextField* txt=(UITextField*)sender;
        //        //[self.btnUpdate setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        //
        //        //[Alert viewButtonCALayer:[UIColor grayColor] viewButton:self.btnUpdate];
        //        self.btnUpdate.backgroundColor=[UIColor orangeColor];
        //
        NSIndexPath* indexPath=[Alert getIndexPathWithTextfield:txt table:self.tableView];
        NSInteger rows1=[self.tableView numberOfRowsInSection:0];
        NSInteger rows2=[self.tableView numberOfRowsInSection:1];
//        NSInteger rows3=[self.tableView numberOfRowsInSection:2];
        
        BOOL isValid=NO;
        //
        
        if(indexPath.row==0 && indexPath.section==0)
                isValid=[Alert validationString:txt.text];
        if(indexPath.row==1 && indexPath.section==0)
                isValid=[Alert validationName:txt.text];
        if(indexPath.row==2 && indexPath.section==0)
                isValid=[Alert validateMobileNumber:txt.text];
        
        if(indexPath.row==0 && indexPath.section==3)
                isValid=YES;
        
        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
        
        if(indexPath.section==0)
                arrTextData[indexPath.row]=txt.text;
        if(indexPath.section==3)
                arrTextData[indexPath.row+rows1+rows2]=txt.text;
        
        
}

#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
        textView.backgroundColor = [UIColor whiteColor];
        textView.textColor=[UIColor blackColor];
        
        
        if([textView.text isEqualToString:PLACEHOLDER_MESSAGE]){
                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = @"";
        }
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - KEYBOARD_HEIGHT-10);
        }
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textView.tag inSection:1];
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
                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
        if(isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-BOTTOM_HEIGHT-10);
                
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
        isUpdate=YES;
        //[self validateForNativeChat];
        
        if(textView.text.length == 0){
                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
        NSInteger rows=[self.tableView numberOfRowsInSection:0];
        arrTextData[textView.tag+rows]=textView.text;
}

#pragma mark - Target Methods

-(IBAction)selectCountry:(id)sender{
        
        if(arrCountryList.count)
                [self createDatePicker:YES items:arrCountryList sender:sender];
        
        else{
                countrySender=sender;
                
                [self getCountryListWebService];
        }
        
//        else    [self getCountryList];
        
}

-(IBAction)choosePic:(id)sender {
        
        UIButton* button=(UIButton*)sender;
        
        __weak __typeof(self)weakSelf = self;
        
        
        [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES isVideo:NO result:^(UIImage *image,NSURL* videoURL) {
//                 [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                
                if(button.tag == 0) {
                        
//                        isProfilePic=YES;
//                        selectedProfileImage=image;
                        indexOfLatestUploadedImage = 0;
                        isProfilePic = YES;
                        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                        cropController.delegate = self;
                        [self presentViewController:cropController animated:YES completion:nil];
                }
                else if(button.tag == 1) {
                        
//                        isCoverPic=YES;
//                        selectedCoverImage=image;
                        indexOfLatestUploadedImage = 1;

                        isCoverPic = YES;
                        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
                        cropController.delegate = self;
                        [self presentViewController:cropController animated:YES completion:nil];
                        
                }
                
                
//                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                
        }];
        
}



-(IBAction)update:(id)sender{
        
        [self updateProfile];
        
}

#pragma mark - Cropper Delegate Method -

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
        
        //        self.imageUser.image = image;
        //        self.imageUserSelected = image;
        //        self.imageUser.hidden = YES;
        //        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(self.imageUser.frame.origin.x, self.imageUser.frame.origin.y + 64, self.imageUser.frame.size.width, self.imageUser.frame.size.height) completion:^{
        //                self.imageUser.hidden = NO;
        //        }];
        
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(0, 100.0, 40.0, 40.0) completion:^{
                
                if (indexOfLatestUploadedImage == 0) {
                        
                        selectedProfileImage = image;
                        __weak __typeof(self)weakSelf = self;
                                                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                        //
                    //          [Alert reloadSection:2 table:weakSelf.tableView];
                } else if(indexOfLatestUploadedImage == 1) {
                        
                        selectedCoverImage = image;
                        __weak __typeof(self)weakSelf = self;
                                               [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                      //       [Alert reloadSection:2 table:weakSelf.tableView];
                        
                }
                
        }];
        
}

#pragma mark - Web Api method -

-(void)updateProfile {
        
        NSIndexPath* index0=[NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* index1=[NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2=[NSIndexPath indexPathForRow:2 inSection:0];
        
        if(!IS_EMPTY([arrTextData objectAtIndex:0]) &&
           !IS_EMPTY([arrTextData objectAtIndex:1]) &&
           !IS_EMPTY([arrTextData objectAtIndex:2]) &&
           ![[arrTextData objectAtIndex:3] isEqualToString:SELECT_OPTION]) {
                BOOL isName=[Alert validationString:[arrTextData objectAtIndex:0]];
                BOOL isUserName=[Alert validationName:[arrTextData objectAtIndex:1]];
                BOOL isPhone=[Alert validateMobileNumber:[arrTextData objectAtIndex:2]];
                
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                        
                }
                else if(!isUserName){
                        [Alert alertWithMessage:@"Invalid Username ! Please enter valid Username."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else if (!isPhone){
                        [Alert alertWithMessage:@"Invalid Phone number ! Please enter valid phone number."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else
                {
                        //"{""user_id"":""53"",name"":""yogesh"",""phone"":""9540064678"",""country"":""IN"",""bio"":""biography""}
                        //NOTE: send image in multipart/form-data, field name (profile_image, cover_image)"
                        
                        NSString* country=[Alert getSelectedCountryKeyWithValue:[arrTextData objectAtIndex:3]];
                        NSString* youtubeLink=IS_EMPTY([arrTextData objectAtIndex:5]) ? [EAGallery sharedClass].profileVideo : [arrTextData objectAtIndex:5];
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"];
                        [dic setObject:[arrTextData objectAtIndex:0]            forKey:@"name"];
                        [dic setObject:[arrTextData objectAtIndex:1]            forKey:@"user_name"];
                        [dic setObject:[arrTextData objectAtIndex:2]            forKey:@"phone"];
                        [dic setObject:country                                  forKey:@"country"];
                        [dic setObject:[arrTextData objectAtIndex:4]            forKey:@"bio"];
                        [dic setObject:youtubeLink                              forKey:LOGIN_VIDEO_LINK];
                        
                        profilePicData =selectedProfileImage ? UIImageJPEGRepresentation(selectedProfileImage, 90) : nil;
                        coverPicData = selectedCoverImage ?  UIImageJPEGRepresentation(selectedCoverImage, 90) : nil;
                        
                        //Images
                        NSMutableArray* arrImages=[[NSMutableArray alloc]init];
                        NSMutableDictionary* imageDic;
                        if(profilePicData){
                                imageDic=[NSMutableDictionary dictionary];
                                [imageDic setObject:profilePicData           forKey:@"imagedata"];
                                [imageDic setObject:@"profile_image.jpg"     forKey:@"imagename"];
                                [imageDic setObject:@"profile_image"         forKey:@"imagekey"];
                                [arrImages addObject:imageDic];
                        }
                        if(coverPicData){
                                imageDic=[NSMutableDictionary dictionary];
                                [imageDic setObject:coverPicData             forKey:@"imagedata"];
                                [imageDic setObject:@"cover_image.jpg"       forKey:@"imagename"];
                                [imageDic setObject:@"cover_image"           forKey:@"imagekey"];
                                [arrImages addObject:imageDic];
                        }
                        
                        
                        [self getWebService:[dic mutableCopy] images:arrImages.count ? [arrImages mutableCopy]: nil];
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
        
}




@end
