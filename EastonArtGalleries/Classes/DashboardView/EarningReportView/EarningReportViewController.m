//
//  EarningReportViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 25/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "EarningReportViewController.h"
#import "EarningReportViewCell1.h"
#import "EarningReportViewCell2.h"
#import "EarningReportViewCell3.h"
#import "ArtDetailViewController.h"

#define COLOR_CELL_BACKGROUND   @"#EAEAEA"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"

#define ENTER_START_DATE        @"Enter start date"
#define ENTER_END_DATE          @"Enter end date"


@interface EarningReportViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PickerViewDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSMutableArray* arrData;
        NSString* baseURL;
        
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        id countrySender;
        NSMutableArray* arrDate;
        NSMutableArray* arrHeader;
        
        
}


@end

@implementation EarningReportViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";

#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
    
        [self cellRegister];
        
        [self config];
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        
        
        arrDate=[[NSMutableArray alloc]initWithObjects:ENTER_START_DATE,ENTER_END_DATE, nil];
        arrData=nil;
        
        [self removeBackgroundLabel];
        [self removeActivityIndicator];
        [self setActivityIndicator];
        [self.tableView reloadData];
        
        // {"user_id":"53","start_date":"2016-04-01","end_date":"2016-04-19"}
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"];
        [dic setObject:@""                                      forKey:@"start_date"];
        [dic setObject:@""                                      forKey:@"end_date"];
        
        [self getWebService:[dic mutableCopy]];
        
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
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        arrHeader=[[NSMutableArray alloc]init];
        
        [arrHeader addObject:@"FILTER"];
        [arrHeader addObject:@"EARNING LIST"];
        [arrHeader addObject:@"TOTAL EARNING"];
        
        
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
        
        [self.tableView registerClass:[EarningReportViewCell1 class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[EarningReportViewCell2 class] forCellReuseIdentifier:CellIdentifier2];
        [self.tableView registerClass:[EarningReportViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"EarningReportViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];

        UINib *contantsCellNib2= [UINib nibWithNibName:@"EarningReportViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"EarningReportViewCell3" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
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

#pragma mark -Call WebService

-(void)callFilterWebService{
        
        arrData=nil;
        
        [self removeBackgroundLabel];
        [self removeActivityIndicator];
        [self setActivityIndicator];
        [self.tableView reloadData];
        
        NSString* startDate=[Alert getDateWithString:arrDate[0] getFormat:SET_FORMAT_TYPE1 setFormat:GET_FORMAT_TYPE];
        NSString* endDate=[Alert getDateWithString:arrDate[1] getFormat:SET_FORMAT_TYPE1 setFormat:GET_FORMAT_TYPE];
        
        // {"user_id":"53","start_date":"2016-04-01","end_date":"2016-04-19"}
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"];
        [dic setObject:startDate                                forKey:@"start_date"];
        [dic setObject:endDate                                  forKey:@"end_date"];
        
        [self getWebService:[dic mutableCopy]];
}

-(void)getWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_EarningReport);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
                NSLog(@" tempURL :%@---%@",urlString,postString);
                
                NSMutableURLRequest *theRequest=[Alert getRequestUploadImageWithPostString:postString
                                                                                 urlString:urlString
                                                                                    images:nil];
                
                
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                        [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                //
                //                });
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
                
                if (returnData == nil)
                {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedClass sharedObject] hudeHide];
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
                                [[SharedClass sharedObject] hudeHide];
                                
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
                                        
                                        NSArray*resData = (NSArray*)[result valueForKey:@"erningList"];
//                                        NSString*resBaseURL = (NSString*)[result valueForKey:@"base_url"];
//                                        
                                        if([resData isKindOfClass:[NSArray class]]){
                                                arrData=[Alert removedNullsWithString:@"" obj:resData];
//                                                arrData=resData.count ? [resData mutableCopy] :nil;
                                        }
//
//                                        if([resBaseURL isKindOfClass:[NSString class]]){
//                                                baseURL=!IS_EMPTY(resBaseURL) ? [resBaseURL mutableCopy] :nil;
//                                                
//                                        }
                                        
                                        //                                        [self getSortedArray:arrData];
                                        //arrData=[[self getSortedList:arrData] mutableCopy];
                                        
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                if(arrData.count) [self removeBackgroundLabel];
                                                else [self setBackgroundLabel];
                                                
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

#pragma mark - DatePicker Custom Method

-(void)createDatePicker:(BOOL)isList items:(NSArray*)list isCurrentDate:(BOOL)isCurrentDate sender:(id)sender{
        
        cDatePicker=[[CustomDatePickerViewController alloc]initWithNibName:kCustomDatePickerViewController bundle:nil];
        
        cDatePicker.delegate=self;
        cDatePicker.isCustomList=isList;
        cDatePicker.isCurrentDate=isCurrentDate;
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


#pragma mark - DatePicker Custom Delegate methods

-(void)selectDateFromDatePicker:(NSDate *)date sender:(id)sender{
        
        NSLog(@"Selected Date->%@",date);
        UIButton* button=(UIButton*)sender;
        selectedDate=date;
        
        NSString* dateString=[[Alert getDateFormatWithString:SET_FORMAT_TYPE1] stringFromDate:date];
//        NSString* dateString=[Alert getDateWithString:[[Alert getDateFormatWithString:GET_FORMAT_TYPE] stringFromDate:date]
//                                           getFormat:GET_FORMAT_TYPE
//                                           setFormat:SET_FORMAT_TYPE1];
        
        arrDate[button.tag]=dateString;
        
        
        [self removeDatePicker];
        
        [Alert reloadSection:0 table:self.tableView];
        
}

-(void)cancelDateFromDatePicker:(id)sender{
        
        [self removeDatePicker];
        // [txtCountry becomeFirstResponder];
}

#pragma mark - Custom List Item Picker Delegate Methods

-(void)selectItemFromList:(NSString *)item sender:(id)sender{
        
        NSLog(@"Selected item->%@",item);
        UIButton* button=(UIButton*)sender;
        /*
        selectedCountry=item;
        
        [self removeDatePicker];
        
        
        
        NSLog(@"Country Key->[%@]",[Alert getSelectedCountryKeyWithValue:selectedCountry]);
        NSLog(@"Country Value->[%@]",[Alert getSelectedCountryValueWithKey:[Alert getSelectedCountryKeyWithValue:selectedCountry]]);
        
        arrTextData[button.tag]=selectedCountry;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        */
        countrySender=nil;
}

-(void)cancelItemFromCustomList:(id)sender{
        [self removeDatePicker];
        countrySender=nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        
        switch (section) {
                        
                case 0:
                        rows=1;
                        break;
                case 1:
                        rows=arrData.count ? arrData.count : 0;
                        break;
                case 2:
                        rows=arrData.count ? 1  : 0;
                        break;
                default:
                        break;
        }
        
        return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=0.0f;
        
        switch (indexPath.section) {
                        
                case 0:
                        finalHeight=156.0f;
                        break;
                case 1:
                        finalHeight=180.0f;
                        break;
                case 2:
                        finalHeight=55.0f;
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
                        
                        EarningReportViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.lblStartDate.text=arrDate[0];
                        cell.lblEndDate.text=arrDate[1];
                        
                        cell.btnStartDate.tag=0;
                        cell.btnEndDate.tag=1;
                        
                        [cell.btnSearch addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnStartDate addTarget:self action:@selector(startDate:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnEndDate addTarget:self action:@selector(endDate:) forControlEvents:UIControlEventTouchUpInside];
                        
                        return cell;
                        
                        
                }
                        break;
                case 1:
                {
                        
                        NSMutableDictionary* dic=[arrData objectAtIndex:indexPath.row];
                        
                        EarningReportViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        NSNumber* earned=[dic objectForKey:@"earned"];
                        
                        cell.lblOrderID.text=[@"PAY-" stringByAppendingString:[dic objectForKey:@"product_order_id"]];
                        cell.lblArtName.text=[dic objectForKey:@"art_name"];
                        cell.lblArtPrice.text=[@"$" stringByAppendingString:[dic objectForKey:@"art_price"]];
                        cell.lblCommission.text=[[dic objectForKey:@"comission"] stringByAppendingString:@"%"];
                        cell.lblEarned.text=[@"$" stringByAppendingString:[earned stringValue]];
                        
                        cell.btnPay.tag=indexPath.row;
                        [cell.btnPay addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        return cell;
                        
                        
                }
                        break;
                case 2:
                {
                        EarningReportViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        NSNumber* sum = [arrData valueForKeyPath: @"@sum.earned"];
                        
                        NSString* fc1=[Alert getFormatedNumber:[sum stringValue]];
                        cell.lblTotal.text=[@"$" stringByAppendingString:fc1];
                        
                        
                        
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        NSString *header  = arrHeader[section];
        
        return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        //Header View
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor=[UIColor clearColor];
        
        //Header Title
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(8, 0, tableView.frame.size.width-16, 30);
        myLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:14];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textAlignment=NSTextAlignmentCenter;
        myLabel.textColor=[UIColor blackColor];
        myLabel.backgroundColor=[UIColor whiteColor];
        [headerView addSubview:myLabel];
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        NSInteger height=0;
        
        switch (section) {
                        
                case 0:
                        height=30.0f;
                        break;
                case 1:
                        height=arrData.count ? 30.0f : 0;
                        break;
                case 2:
                        height=arrData.count ? 30.0f  : 0;
                        break;
                default:
                        break;
        }
        return height;
}

#pragma mark - Target Methods

-(IBAction)search:(id)sender{
        
        if(![arrDate[0] isEqualToString:ENTER_START_DATE] && ![arrDate[1] isEqualToString:ENTER_END_DATE])
                [self callFilterWebService];
        else{
                [Alert alertWithMessage:@"Please enter date first!"
                             navigation:self.navigationController
                               gotoBack:NO animation:YES second:2.0];
        }
        
}

-(IBAction)startDate:(id)sender{
        
        
//        if(arrData.count)
        [self createDatePicker:NO items:nil isCurrentDate:YES sender:sender];

        
}

-(IBAction)endDate:(id)sender{
        
//        if(arrData.count)
        [self createDatePicker:NO items:nil isCurrentDate:YES sender:sender];
        
}

-(IBAction)pay:(id)sender {
        
        UIButton* button=(UIButton*)sender;
        
        NSDictionary* data=[arrData objectAtIndex:button.tag];
        
        ArtDetailViewController* vc=GET_VIEW_CONTROLLER(kArtDetailViewController);
        vc.from=@"back";
        vc.artID=[data objectForKey:@"id"];
        [self.viewDeckController rightViewPushViewControllerOverCenterController:vc];
}

@end
