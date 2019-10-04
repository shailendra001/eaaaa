//
//  ByCertificateVC.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 15/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "BuyCertificateVC.h"
#import "RegistrationViewCell.h"
#import "AppDelegate.h"


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
//#define COLOR_CELL_TEXT         @"#575656"
#define COLOR_CELL_TEXT         @"#000000"

#define CELL_CONTENT_LEFT_MARGIN        0
#define CELL_CONTENT_TOP_MARGIN         0

#define CELL_DESC_LEFT_MARGIN           41
#define CELL_DESC_RIGHT_MARGIN          8
#define CELL_DESC_HEIGHT_DEFAULT        80
#define CELL_DESC_TOP_MARGIN            7
#define CELL_CONTENT_BOTTOM_MARGIN      8

#define CELL_PICUTRE_LEFT_MARGIN        0
#define CELL_PICUTRE_HEIGHT_DEFAULT     180


@interface BuyCertificateVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TransactionDeletgate>{

        UIActivityIndicatorView *activityIndicator;
        DataBaseHandler *dataManager;
        UIView* cardCountViewGlobal;
        UIView* cardViewGlobal;
        NSMutableArray* arrData1;
        NSMutableArray* arrSelections;
        BOOL isUpdateHeight;
        NSString *strTransactionID;
}

@property (nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong) AppDelegate* appDelegate;

@end


@implementation BuyCertificateVC

static NSString *CellIdentifier = @"Cell";


#pragma mark  App delegate

- (AppDelegate *)appDelegate {
        
        return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Controller life cycle method -

- (void)viewDidLoad {
        
    [super viewDidLoad];
        self.lblTitle.text = @"BUY CERTIFICATE";
        [self.buttonSubmit setTitle:@"PROCEED TO PAYMENT" forState:UIControlStateNormal];
        [self cellRegister];
        [self loadData];
        [self config];
        [self setLogoImage];
        [self configPayPal];
        [self rightNavBarConfiguration];
}

- (void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
        [self loadCardCount];
        
}

- (void)didReceiveMemoryWarning {
        
    [super didReceiveMemoryWarning];
}


-(void)config{
        
        //        level=1;
        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
//        self.lblTitle.text= [self.titleString uppercaseString];// @"ART COLLECTION";
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView = _viewTableFooter;
    //    self.tableView.tableFooterView=[[UIView alloc]init];
        
        [self.tableView reloadData];
        
        
}

-(void)cellRegister {
        
        [self.tableView registerClass:[RegistrationViewCell class]      forCellReuseIdentifier:CellIdentifier];

        UINib *contantsCellNib = [UINib nibWithNibName:NSStringFromClass([RegistrationViewCell class]) bundle:nil];
        
         [self.tableView registerNib:contantsCellNib forCellReuseIdentifier:CellIdentifier];
}

-(void)loadData {

        arrData1=[[NSMutableArray alloc]init];
        
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        [dic setObject:@"Name *"                                       forKey:@"title"];
        [dic setObject:@"Name *"                                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Email *"                                      forKey:@"title"];
        [dic setObject:@"Email *"                                      forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        /*
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Category *"                                    forKey:@"title"];
        [dic setObject:@"Choose Category"                               forKey:@"title1"];
        [dic setObject:@"Sub Category"                                  forKey:@"title2"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        */
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Phone *"                                      forKey:@"title"];
        [dic setObject:@"Phone *"                                      forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"user_icon_black.png"                           forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Country *"                             forKey:@"title"];
        [dic setObject:@"Country *"                             forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"email_icon.png"                                forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Zip *"                          forKey:@"title"];
        [dic setObject:@"Zip *"                          forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Address *"                       forKey:@"title"];
        [dic setObject:@"Address *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:@"phone_icon.png"                                forKey:@"icon"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];

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

-(void)setLogoImage {
        
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
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


#pragma mark - UITextField Delegate Method -


//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//
//        [textField becomeFirstResponder];
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
        [textField resignFirstResponder];
        
        NSIndexPath *indexPathOriginal =[Alert getIndexPathWithTextfield:textField table:self.tableView];
        
//        switch (level) {
//                case 1:
//                {
//                        
//                }
//                        break;
//                case 2:
//                {
//                        
//                }
//                        break;
//                case 3:
//                {
                        RegistrationViewCell * cell;
                        
                        switch (indexPathOriginal.row) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                        if(!IS_EMPTY(textField.text)) {
                                                
                                                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPathOriginal.section+1]];
                                                
                                                [cell.txtName becomeFirstResponder];
                                        }
                                        break;
                                        
                                        
                                default:
                                        break;
                      //  }
                        
                        
//                }
//                        break;                default:
//                        break;
        }
        
        if(isUpdateHeight){
                
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height+216);
                
        }
        
        isUpdateHeight=NO;
        
        
        return YES;
}

-(void)textFieldDidChange:(id)sender{
        //        isUpdate=YES;
        UITextField* txt=(UITextField*)sender;
        
        NSIndexPath *indexPath = [Alert getIndexPathWithTextfield:txt table:self.tableView];

                        BOOL isValid = NO;
        
        switch (indexPath.row) {
                        
                case 0:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 1:
                        isValid = [Alert validationEmail:txt.text];
                        break;
                case 2:
                        isValid = [Alert validateNumber:txt.text];
                        break;
                case 3:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 4:
                        isValid = [Alert validatePinCode:txt.text];
                        break;
                case 5:
                        isValid = [Alert validationString:txt.text];
                        break;
                        
                default:
                        isValid=YES;
                        break;
        }
        
        
                        txt.textColor = isValid ? [UIColor blackColor] : [UIColor redColor];
        
                        NSMutableDictionary* dic = [arrData1 objectAtIndex:txt.tag];
                        
                        [dic setObject:txt.text forKey:@"value"];
        
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
        
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
        return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        switch (indexPath.row) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                {
                        
                        NSDictionary *item = [arrData1 objectAtIndex:indexPath.row];
                        
                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                        
                        if (indexPath.row == 1) {
                                cell.txtName.keyboardType = UIKeyboardTypeEmailAddress;
                        }
                        else if (indexPath.row == 2 || indexPath.row == 4) {
                                
                         cell.txtName.keyboardType = UIKeyboardTypeNumberPad;
                        }
                        else {
                                
                        cell.txtName.keyboardType = UIKeyboardTypeDefault;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.txtName.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:11];
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

        
                default:
                        
                        return nil;
                        break;
        }
}


#pragma mark PayPal Payment gateway

-(void)updateAmountFromPayPalToServer {
        
        self.transactionDetails = nil;
        
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
                
                [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                
                [[self appDelegate] callUpdateTransactionDetailWS];
                
                //                });
                
        }
        else{
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedClass sharedObject] hudeHide];
                //                });
        }
}


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

- (void)navigateToPaymentStatusScreen: (NSMutableDictionary *)mutDictTransactionDetails {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isTRANSACTION ];//:isYES                      forKey:isTRANSACTION];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:mutDictTransactionDetails  forKey:TRANSACTION_DETAIL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        //        });
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
     //           [self updateAmountFromPayPalToServer];
             
                
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
        
        NSDictionary *dicPaymentResponse = [completedPayment.confirmation objectForKey:@"response"];
        strTransactionID = [dicPaymentResponse objectForKey:@"id"];
        NSLog(@"%@", strTransactionID);
        [self gatherDicParameters:strTransactionID];
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
        
        NSString* amountString = @"10";
        
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


#pragma mark - Button Action 

- (IBAction)buttonSubmitTapped:(id)sender {
        
        
        if([self isValidate]) {
        
                         [self openPayPalView];

        }
        
}

-(BOOL)isValidate {

        BOOL isValid=NO;
        
        NSIndexPath* index0 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* index1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2 = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath* index3 = [NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath* index4 = [NSIndexPath indexPathForRow:4 inSection:0];
        NSIndexPath* index5 = [NSIndexPath indexPathForRow:5 inSection:0];
        
        if(!IS_EMPTY([[arrData1 objectAtIndex:0] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:1] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:2] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:3] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:4] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:5] objectForKey:@"value"])
           ) {
                BOOL isName    =[Alert validationString:[[arrData1 objectAtIndex:0] objectForKey:@"value"]];
                BOOL isEmail   = [Alert validationEmail:[[arrData1 objectAtIndex:1] objectForKey:@"value"]];
                                BOOL isPhone   =[Alert validateNumber:[[arrData1 objectAtIndex:2] objectForKey:@"value"]];
                BOOL isCountry   =[Alert validationString:[[arrData1 objectAtIndex:3] objectForKey:@"value"]];
                BOOL isZip   =[Alert validatePinCode:[[arrData1 objectAtIndex:4] objectForKey:@"value"]];
                BOOL isAddress   =[Alert validationString:[[arrData1 objectAtIndex:5] objectForKey:@"value"]];
                
                if(!isName){
                        [Alert alertWithMessage:@"Invalid name ! Please enter valid Name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        
                }
                else if(!isEmail){
                        [Alert alertWithMessage:@"Invalid email ! Please enter valid email."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                
                else if(!isPhone){
                        [Alert alertWithMessage:@"Invalid phone ! Please enter valid phone no."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if(!isCountry){
                        [Alert alertWithMessage:@"Invalid country name ! Please enter valid country name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index3 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if(!isZip){
                        [Alert alertWithMessage:@"Invalid zip ! Please enter valid zip."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index4 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if(!isAddress){
                        [Alert alertWithMessage:@"Invalid address ! Please enter valid address."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index5 atScrollPosition:UITableViewScrollPositionTop animated:YES];
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



-(void)gatherDicParameters : (NSString *)strTxnID{

        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        
        [dicParam setObject:[[arrData1 objectAtIndex:0] objectForKey:@"value"] forKey:@"name"];
        [dicParam setObject:[[arrData1 objectAtIndex:1] objectForKey:@"value"] forKey:@"email"];
        [dicParam setObject:[[arrData1 objectAtIndex:2] objectForKey:@"value"] forKey:@"phone"];
        [dicParam setObject:[[arrData1 objectAtIndex:3] objectForKey:@"value"] forKey:@"country"];
        [dicParam setObject:[[arrData1 objectAtIndex:4] objectForKey:@"value"] forKey:@"zip"];
        [dicParam setObject:[[arrData1 objectAtIndex:5] objectForKey:@"value"] forKey:@"address"];
        
        [dicParam setObject:strTxnID forKey:@"txn_id"];
        [dicParam setObject:self.strRegId forKey:@"reg_id"];
        [dicParam setObject:@"10" forKey:@"amount"];
        
        [self buyCertificate:dicParam];
}



#pragma mark -Call WebService

-(void)setActivityIndicator {
        
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

-(void)removeActivityIndicator {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

-(void)buyCertificate:(NSDictionary*)dic {
        
        NSLog(@"%@", dic);
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_BUY_CERTIFICATE);
                
                
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
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:YES second:2.0];
                                        });
                                        
                                }
                                else if (error.boolValue) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [Alert alertWithMessage:[result valueForKey:@"msg"]
                                                             navigation:self.navigationController
                                                               gotoBack:NO animation:NO second:2.0];
                                        });
                                        
                                }
                                
                                else{
                                }
                                
                                
                                
                                
                        }
                        
                }
                
        });
        
}


@end
