//
//  AddAddressViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 01/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "AddAddressViewController.h"
#import "UpdateProfileViewCell.h"
#import "UpdateProfileViewCell1.h"
#import "UpdateProfileViewCell2.h"

#define COLOR_CELL_BACKGROUND           @"#DEDEDD"
#define COLOR_CELL_TEXT                 @"#575656"
#define COLOR_CELL_CONTENT_BORRDER      @"#CBC9C9"
#define COLOR_CELL_TEXT_PLACEHOLDER     @"#8E8E8E"

#define SELECT_OPTION           @"* Select Country"
#define PLACEHOLDER_MESSAGE     @"* Address"

#define ADDRESS_FISRT_NAME      @"firstname"
#define ADDRESS_LAST_NAME       @"lastname"
#define ADDRESS_EMAIL           @"email"
#define ADDRESS_PHONE           @"phonenumber"
#define ADDRESS_CITY            @"city"
#define ADDRESS_STATE           @"county_or_State"
#define ADDRESS_COUNTRY         @"country"
#define ADDRESS_LINE1           @"address1"
#define ADDRESS_LINE2           @"address2"
#define ADDRESS_PIN_CODE        @"postcode"
#define ADDRESS_PRODUCTS_ID     @"pid"
#define ADDRESS_PRODUCTS_QUANTITY       @"quantity"
#define ADDRESS_PRODUCTS_ORDER_ID       @"orderid"


@interface AddAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,PickerViewDelegate>
{
        NSMutableArray *data;
        NSMutableArray* arrData;
        NSMutableArray* arrTextData;
        BOOL isUpdate;
        BOOL isUpdateHeight;
        CustomDatePickerViewController* cDatePicker;
        UIView* fullScreen;
        NSDate* selectedDate;
        NSString* selectedCountry;
        NSArray* arrCountryList;
        id countrySender;
}

@end

@implementation AddAddressViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifier4 = @"Cell4";


#pragma mark - View controller life cycle

- (void)viewDidLoad {
   
        [super viewDidLoad];
    
        [self cellRegister];
        
        [self setLogoImage];
        
        [self loadData];
        
        [self countryList];
        
        [self config];
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        [self.viewDeckController setLeftLedge:65];
        

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
        
        
        self.lblTitle.text=[self.titleString uppercaseString];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.tableView.backgroundColor=[UIColor whiteColor];
        self.view.backgroundColor=[UIColor whiteColor];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        [Alert setShadowOnViewAtBottom:self.viContainerTitleBar];
        [Alert setShadowOnViewAtTop:self.viContainerCancel];
        [Alert setShadowOnViewAtTop:self.viContainerSave];
        [Alert setShadowOnViewAtTop:self.lblSeparatorLineVirtical];
#endif
        
}

-(void)loadData{
        
       
        
        {
                arrData=[[NSMutableArray alloc]init];
                
                
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                
                [dic setObject:@"First Name :"                                        forKey:@"title"];
                [dic setObject:@"* First Name"                                  forKey:@"msg"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Last Name :"                                        forKey:@"title"];
                [dic setObject:@"* Last Name"                                   forKey:@"msg"];
                [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Email :"                                       forKey:@"title"];
                [dic setObject:@"* Email"                                       forKey:@"msg"];
                [dic setObject:@"email_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Phone :"                                       forKey:@"title"];
                [dic setObject:@"* Phone"                                       forKey:@"msg"];
                [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"City :"                                        forKey:@"title"];
                [dic setObject:@"* City"                                        forKey:@"msg"];
                [dic setObject:@"globe.png"                                     forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"State :"                                       forKey:@"title"];
                [dic setObject:@"* State"                                       forKey:@"msg"];
                [dic setObject:@"globe.png"                                     forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Pin Code :"                                    forKey:@"title"];
                [dic setObject:@"* Pin Code"                                    forKey:@"msg"];
                [dic setObject:@"key_icon.png"                                  forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Country :"                                     forKey:@"title"];
                [dic setObject:@"* Country"                                     forKey:@"msg"];
                [dic setObject:@"globe.png"                                     forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];


                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Address :"                                     forKey:@"title"];
                [dic setObject:@"* Address"                                     forKey:@"msg"];
                [dic setObject:@"biography.png"                                 forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];

                
        }
        
        {
                arrTextData=[[NSMutableArray alloc]init];
                
                NSDictionary* dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"address"];

                
                for (int i=0; i<9; i++) {
                        NSString* text=@"";
                        
                        switch (i) {
                                case 0:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_FISRT_NAME] : @"";
                                        break;
                                        
                                case 1:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_LAST_NAME] : @"";
                                        break;
                                case 2:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_EMAIL] : @"";
                                        break;
                                case 3:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_PHONE] : @"";
                                        break;
                                case 4:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_CITY] : @"";
                                        break;
                                case 5:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_STATE] : @"";
                                        break;
                                case 6:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_PIN_CODE] : @"";
                                        break;
                                case 7:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_COUNTRY] : SELECT_OPTION;
                                        break;
                                case 8:
                                        text=(dic!=nil) ? [dic objectForKey:ADDRESS_LINE1] : PLACEHOLDER_MESSAGE;
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
//        [self.tableView registerClass:[CartViewCell4 class] forCellReuseIdentifier:CellIdentifier4];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"UpdateProfileViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"UpdateProfileViewCell1" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        
        UINib *contantsCellNib3 = [UINib nibWithNibName:@"UpdateProfileViewCell2" bundle:nil];
        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
        UINib *contantsCellNib4 = [UINib nibWithNibName:@"CartViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib4 forCellReuseIdentifier:CellIdentifier4];
        
}

-(void)countryList{
        //    arrCountryList=[[NSArray alloc]init];
        
        NSDictionary* country=[Alert getCountryFromServerData];
        if(country){
                
                arrCountryList=[[country allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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

#pragma mark -Call WebService

-(void)checkoutOrderWebService:(NSDictionary*)dic{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Checkout);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                NSLog(@" tempURL :%@---",urlString);
                NSMutableURLRequest *theRequest=[Alert getRequesteWithPostString:postString
                                                                       urlString:urlString
                                                                      methodType:@"POST"
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
                                NSString *orderID  = [result valueForKey:ADDRESS_PRODUCTS_ORDER_ID];
                                
                                if (success.boolValue) {
                                        
                                        NSMutableDictionary* dicAdd=[dic mutableCopy];
                                        [dicAdd setObject:orderID forKey:ADDRESS_PRODUCTS_ORDER_ID];
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:dicAdd forKey:@"address"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                
                                                [self.navigationController popViewControllerAnimated:YES];
                                                
                                                
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        switch (section) {
                case 0:
                        rows=9;
                        break;
                case 1:
                        rows=1;
                        break;
                        
                default:
                        break;
        }
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        NSInteger height=0;
        switch (indexPath.row) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7: height=44.0f;
                        break;
                case 8:
                        height=131.0f;
                        break;
                        
                default:
                        break;
        }
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if(indexPath.section==0){
                if(indexPath.row==7){
                        NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                        UpdateProfileViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.contentView.backgroundColor=[UIColor whiteColor];
                        
                        
                        cell.lblTitle.text=[item objectForKey:@"title"];
                        cell.lblTitle.tintColor=[UIColor blackColor];
                        
                        cell.lblName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
                        
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
                else if (indexPath.row==8){
                        NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                        NSString* text=[arrTextData objectAtIndex:indexPath.row];
                        
                        UpdateProfileViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.contentView.backgroundColor=[UIColor whiteColor];
                        
                        //                cell.img.hidden=YES;
                        
                        cell.lblTitle.text=[item objectForKey:@"title"];
                        cell.lblTitle.tintColor=[UIColor blackColor];
                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                        
                        
                        cell.vitxtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
                        cell.vitxtName.text=text;
                        cell.vitxtName.textColor=[text isEqualToString:PLACEHOLDER_MESSAGE] ?  [Alert colorFromHexString:COLOR_CELL_TEXT]:[UIColor blackColor];
                        cell.vitxtName.tag=indexPath.row;
                        cell.vitxtName.delegate=self;
                        
                        
                        return cell;
                }
                else{
                        
                        
                        NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                        
                        UpdateProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.contentView.backgroundColor=[UIColor whiteColor];
                        
                        cell.lblTitle.text=[item objectForKey:@"title"];
                        cell.lblTitle.tintColor=[UIColor blackColor];
                        
                        cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                        
                        cell.txtName.autocapitalizationType =(indexPath.row==0 || indexPath.row==1 || indexPath.row==4 || indexPath.row==5  ) ? UITextAutocapitalizationTypeWords : UITextAutocapitalizationTypeNone;
                        
                        cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
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
                                                 self.tableView.frame.size.height - 216+40);
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
        
        UpdateProfileViewCell * cell;
        
        if((textField.tag==0 && !IS_EMPTY(textField.text)) ||
           (textField.tag==1 && !IS_EMPTY(textField.text))){
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
        else if(textField.tag==2 && !IS_EMPTY(textField.text)){
                BOOL isEmail=[Alert validationEmail:textField.text];
                
                if(!isEmail){
                        [Alert alertWithMessage:@"Invalid email ! Please enter email."
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
                BOOL isPhone=[Alert validateMobileNumber:textField.text];
                
                if(!isPhone){
                        [Alert alertWithMessage:@"Invalid Phone number ! Please enter valid phone number."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                        [cell.txtName becomeFirstResponder];
                }
        }
        else if(textField.tag==4 && !IS_EMPTY(textField.text)){
                BOOL isCity=[Alert validationString:textField.text];
                
                if(!isCity){
                        [Alert alertWithMessage:@"Invalid city ! Please enter valid city."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                        [cell.txtName becomeFirstResponder];
                        
                }
        }
        else if(textField.tag==5 && !IS_EMPTY(textField.text)){
                BOOL isState=[Alert validationString:textField.text];
                
                if(!isState){
                        [Alert alertWithMessage:@"Invalid state ! Please enter valid state."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                        [cell.txtName becomeFirstResponder];
                        
                }
        
        }
        else if(textField.tag==6 && !IS_EMPTY(textField.text)){
                BOOL isPinCode=[Alert validatePinCode:textField.text];
                
                if(!isPinCode){
                        [Alert alertWithMessage:@"Invalid pin code ! Please enter valid pin code."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [textField becomeFirstResponder];
                        
                }
                else{
                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        
                        
                }
                
        }
//        else if(textField.tag==6 && !IS_EMPTY(textField.text)){
////                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
////                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
////                
//                
//                
//        }
        
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-50-40);
                
                
        }
        
        isUpdateHeight=NO;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender{
        isUpdate=YES;
        
        BOOL isValid=NO;
        //
        UITextField* txt=(UITextField*)sender;
        if(txt.tag==0 ||txt.tag==1||txt.tag==4||txt.tag==5)
                isValid=[Alert validationString:txt.text];
        if(txt.tag==2)
                isValid=[Alert validationEmail:txt.text];
        if(txt.tag==3)
                isValid=[Alert validateMobileNumber:txt.text];
        if(txt.tag==6)
                isValid=[Alert validatePinCode:txt.text];
        
        
        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
        
        arrTextData[txt.tag]=txt.text;
        
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
                                                 self.tableView.frame.size.height - 216+40);
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
                textView.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
                textView.text = PLACEHOLDER_MESSAGE;
                [textView resignFirstResponder];
        }
        if(isUpdateHeight){
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-50-40);
                
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
        
        arrTextData[textView.tag]=textView.text;
}

#pragma mark - Target Methods

-(IBAction)selectCountry:(id)sender{
        
        {
                UpdateProfileViewCell * cell;
                
                for (int i=0; i<7; i++) {
                        
                        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        [cell.txtName resignFirstResponder];
                }
        }
        {
                UpdateProfileViewCell2 * cell;
                
                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
                [cell.vitxtName resignFirstResponder];
        }
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-50-40);
                
                
        }
        
        isUpdateHeight=NO;
        
        if(arrCountryList.count)
                [self createDatePicker:YES items:arrCountryList sender:sender];
        else{
                countrySender=sender;
                
                [self getCountryListWebService];
        }
        
        
}

- (IBAction)cancel:(id)sender {
        
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
        
        [self saveAddress];
        
}

-(void)saveAddress{
        
        
        
        if(!IS_EMPTY([arrTextData objectAtIndex:0]) &&
           !IS_EMPTY([arrTextData objectAtIndex:1]) &&
           !IS_EMPTY([arrTextData objectAtIndex:2]) &&
           ![[arrTextData objectAtIndex:7] isEqualToString:SELECT_OPTION]&&
           ![[arrTextData objectAtIndex:8] isEqualToString:PLACEHOLDER_MESSAGE]) {
                BOOL isFName=[Alert validationString:[arrTextData objectAtIndex:0]];
                BOOL isLName=[Alert validationString:[arrTextData objectAtIndex:1]];
                BOOL isEmail=[Alert validationEmail:[arrTextData objectAtIndex:2]];
                BOOL isPhone=[Alert validateMobileNumber:[arrTextData objectAtIndex:3]];
                BOOL isCity=[Alert validationString:[arrTextData objectAtIndex:4]];
                BOOL isState=[Alert validationString:[arrTextData objectAtIndex:5]];
                BOOL isPincode=[Alert validatePinCode:[arrTextData objectAtIndex:6]];
                
                
                if(!isFName){
                        [Alert alertWithMessage:@"Invalid first name ! Please enter valid first name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                        
                }
                else if(!isLName){
                        [Alert alertWithMessage:@"Invalid last name ! Please enter valid last name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                        
                }
                else if(!isEmail){
                        [Alert alertWithMessage:@"Invalid email ! Please enter valid email."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else if (!isPhone){
                        [Alert alertWithMessage:@"Invalid Phone number ! Please enter valid phone number."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else if (!isCity){
                        [Alert alertWithMessage:@"Invalid City ! Please enter valid city."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else if (!isState){
                        [Alert alertWithMessage:@"Invalid State ! Please enter valid state."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else if (!isPincode){
                        [Alert alertWithMessage:@"Invalid Pin code ! Please enter pin code."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                }
                else
                {
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
//                        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"memberid"];
                        [dic setObject:[arrTextData objectAtIndex:0]            forKey:ADDRESS_FISRT_NAME];
                        [dic setObject:[arrTextData objectAtIndex:1]            forKey:ADDRESS_LAST_NAME];
                        [dic setObject:[arrTextData objectAtIndex:2]            forKey:ADDRESS_EMAIL];
                        [dic setObject:[arrTextData objectAtIndex:3]            forKey:ADDRESS_PHONE];
                        [dic setObject:[arrTextData objectAtIndex:4]            forKey:ADDRESS_CITY];
                        [dic setObject:[arrTextData objectAtIndex:5]            forKey:ADDRESS_STATE];
                        [dic setObject:[arrTextData objectAtIndex:6]            forKey:ADDRESS_PIN_CODE];
                        [dic setObject:[arrTextData objectAtIndex:7]            forKey:ADDRESS_COUNTRY];
                        [dic setObject:[arrTextData objectAtIndex:8]            forKey:ADDRESS_LINE1];
                        [dic setObject:@""                                      forKey:ADDRESS_LINE2];
//                        [dic setObject:[[self arrProducts] mutableCopy]         forKey:ADDRESS_PRODUCTS_ID];
//                        [dic setObject:[[self arrQuantity] mutableCopy]         forKey:ADDRESS_PRODUCTS_QUANTITY];
                       /*
                        {
                        "memberid": "102",
                        "firstname": "firstname",
                        "lastname": "lastname",
                        "phonenumber": "phonenumber",
                        "email": "email",
                        "address1": "address1",
                        "address2": "address2",
                        "city": "city",
                        "country": "country",
                        "county_or_State": "county_or_State",
                        "postcode": "postcode",
                        "pid": [344, 345]
                        }
                        */
                        
                        //[self checkoutOrderWebService:[dic mutableCopy]];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"address"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
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