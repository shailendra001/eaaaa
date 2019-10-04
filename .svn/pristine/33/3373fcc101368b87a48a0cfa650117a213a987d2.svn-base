//
//  ApplicationAndSubmittingVC.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 20/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "ApplicationAndSubmittingVC.h"
#import "RegistrationViewCell.h"

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


@interface ApplicationAndSubmittingVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

{
        UIActivityIndicatorView *activityIndicator;
        UIView* cardCountViewGlobal;
        UIView* cardViewGlobal;
        DataBaseHandler *dataManager;
        NSMutableArray* arrData1;
        NSMutableArray* arrSelections;
        BOOL isUpdateHeight;
}

@end

@implementation ApplicationAndSubmittingVC

static NSString *CellIdentifier = @"Cell";

#pragma mark - Controller life cycle Method -

- (void)viewDidLoad {
        
        [super viewDidLoad];
        self.lblTitle.text = @"APPLICATION AND SUBMITTING";
        [self cellRegister];
        [self loadData];
        [self config];
        [self setLogoImage];
        //        [self configPayPal];
        [self rightNavBarConfiguration];
}



- (void)didReceiveMemoryWarning {
        
    [super didReceiveMemoryWarning];
}

-(void)cellRegister{
        
        [self.tableView registerClass:[RegistrationViewCell class]      forCellReuseIdentifier:CellIdentifier];
        
        UINib *contantsCellNib = [UINib nibWithNibName:NSStringFromClass([RegistrationViewCell class]) bundle:nil];
        
        [self.tableView registerNib:contantsCellNib forCellReuseIdentifier:CellIdentifier];
}

-(void)loadData {
        
        arrData1=[[NSMutableArray alloc]init];
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Name of artist *"                       forKey:@"title"];
        [dic setObject:@"Name of artist *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Name of auction house *"                       forKey:@"title"];
        [dic setObject:@"Name of auction house *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Medium *"                       forKey:@"title"];
        [dic setObject:@"Medium *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Title of art *"                       forKey:@"title"];
        [dic setObject:@"Title of art *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Year *"                       forKey:@"title"];
        [dic setObject:@"Year *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Size *"                       forKey:@"title"];
        [dic setObject:@"Size *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Sale date *"                       forKey:@"title"];
        [dic setObject:@"Sale date *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Sale Llocatio *"                                       forKey:@"title"];
        [dic setObject:@"Sale Llocatio *"                                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Auction sales price range *"                                      forKey:@"title"];
        [dic setObject:@"Auction sales price range * *"                                      forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
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
        [dic setObject:@"Auction estimate price range *"                                      forKey:@"title"];
        [dic setObject:@"Auction estimate price range *"                                      forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Auction house sale lot *"                             forKey:@"title"];
        [dic setObject:@"Auction house sale lot *"                            forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Auction house title *"                          forKey:@"title"];
        [dic setObject:@"Auction house title *"                          forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Auction house sale *"                       forKey:@"title"];
        [dic setObject:@"Auction house sale *"                       forKey:@"msg"];
        [dic setObject:@""                                              forKey:@"value"];
        [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
        [arrData1 addObject:dic];
        
        
}

-(void)config {
        
        //        level=1;
//        dataManager = [[DataBaseHandler alloc] initWithDB:DATABASE_NAME];
        //        self.lblTitle.text= [self.titleString uppercaseString];// @"ART COLLECTION";
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.tableFooterView = _viewTableFooter;
        [self.tableView reloadData];
        
        
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
        
        
        //#if SHADOW_ENABLE
        //        [Alert setShadowOnView:cardCountView];
        //
        //#endif
        
}

-(void)removeCardCount {
        
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

-(IBAction)user:(id)sender {
        
        if([[EAGallery sharedClass]isLogin]) {
                
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
        vc.titleString = @"Your Cart";
        vc.from=@"back";
        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
        
}

-(IBAction)dot:(id)sender {
        
        [[EAGallery sharedClass]popover:sender vc:self];
        
}


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
                        isValid = [Alert validationName:txt.text];
                        break;
                case 1:
                        isValid = [Alert validationName:txt.text];
                        break;
                case 2:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 3:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 4:
                        isValid = [Alert validateNumber:txt.text];
                        break;
                case 5:
                        isValid = [Alert validationString:txt.text];
                        break;
                
                case 6:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 7:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 8:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 9:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 10:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 11:
                        isValid = [Alert validationString:txt.text];
                        break;
                case 12:
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
        
        return 13;
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
                case 6:
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 12:
                {
                        
                        NSDictionary *item = [arrData1 objectAtIndex:indexPath.row];
                        
                        RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                        
//                        if (indexPath.row == 1) {
//                                cell.txtName.keyboardType = UIKeyboardTypeEmailAddress;
//                        }
//                        else if (indexPath.row == 2 || indexPath.row == 4) {
//                                
//                                cell.txtName.keyboardType = UIKeyboardTypeNumberPad;
//                        }
//                        else {
//                                
//                                cell.txtName.keyboardType = UIKeyboardTypeDefault;
//                        }
                        
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


-(BOOL)isValidate {
        
        BOOL isValid=NO;
        
        NSIndexPath* index0 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* index1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath* index2 = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath* index3 = [NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath* index4 = [NSIndexPath indexPathForRow:4 inSection:0];
        NSIndexPath* index5 = [NSIndexPath indexPathForRow:5 inSection:0];
        NSIndexPath* index6 = [NSIndexPath indexPathForRow:6 inSection:0];
        NSIndexPath* index7 = [NSIndexPath indexPathForRow:7 inSection:0];
        NSIndexPath* index8 = [NSIndexPath indexPathForRow:8 inSection:0];
        NSIndexPath* index9 = [NSIndexPath indexPathForRow:9 inSection:0];
        NSIndexPath* index10 = [NSIndexPath indexPathForRow:10 inSection:0];
        NSIndexPath* index11 = [NSIndexPath indexPathForRow:11 inSection:0];
        NSIndexPath* index12 = [NSIndexPath indexPathForRow:12 inSection:0];

        if(!IS_EMPTY([[arrData1 objectAtIndex:0] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:1] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:2] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:3] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:4] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:5] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:6] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:7] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:8] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:9] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:10] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:11] objectForKey:@"value"]) &&
           !IS_EMPTY([[arrData1 objectAtIndex:12] objectForKey:@"value"])
           ) {
                BOOL isArtistName    =[Alert validationName:[[arrData1 objectAtIndex:0] objectForKey:@"value"]];
                BOOL isAuctionHouseName   = [Alert validationName:[[arrData1 objectAtIndex:1] objectForKey:@"value"]];
                BOOL isMedium   =[Alert validationString:[[arrData1 objectAtIndex:2] objectForKey:@"value"]];
                BOOL isTitleOfArt   =[Alert validationString:[[arrData1 objectAtIndex:3] objectForKey:@"value"]];
                BOOL isYear   =[Alert validateNumber:[[arrData1 objectAtIndex:4] objectForKey:@"value"]];
                BOOL isSize   =[Alert validationString:[[arrData1 objectAtIndex:5] objectForKey:@"value"]];
                
                
                BOOL isSaleDate   =[Alert validationString:[[arrData1 objectAtIndex:6] objectForKey:@"value"]];
                BOOL isSaleLlocatio   =[Alert validationString:[[arrData1 objectAtIndex:7] objectForKey:@"value"]];

                BOOL isAuctionSalePriceRange   =[Alert validationString:[[arrData1 objectAtIndex:8] objectForKey:@"value"]];

                BOOL isAuctionEstimatePriceRange   =[Alert validationString:[[arrData1 objectAtIndex:9] objectForKey:@"value"]];

                BOOL isAuctionHouseSaleLot   =[Alert validationString:[[arrData1 objectAtIndex:10] objectForKey:@"value"]];

                BOOL isAuctionHouseTitle   =[Alert validationString:[[arrData1 objectAtIndex:11] objectForKey:@"value"]];

                BOOL isAuctionHouseSale   =[Alert validationString:[[arrData1 objectAtIndex:12] objectForKey:@"value"]];

            
                
                if(!isArtistName){
                        [Alert alertWithMessage:@"Invalid artist name ! Please enter valid artist Name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        
                }
                else if(!isAuctionHouseName){
                        [Alert alertWithMessage:@"Invalid auction house name ! Please enter valid auction house name."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                
                else if(!isMedium){
                        
                        [Alert alertWithMessage:@"Invalid medium ! Please enter valid medium."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if(!isTitleOfArt){
                        [Alert alertWithMessage:@"Invalid title of art ! Please enter valid title of art."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index3 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if(!isYear){
                        [Alert alertWithMessage:@"Invalid year ! Please enter valid year."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index4 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else if(!isSize){
                        [Alert alertWithMessage:@"Invalid size ! Please enter valid size."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index5 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else if(!isSaleDate){
                        [Alert alertWithMessage:@"Invalid sale date ! Please enter valid sale date."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index6 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else if(!isSaleLlocatio){
                        [Alert alertWithMessage:@"Invalid sale Llocatio ! Please enter valid sale Llocatio."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index7 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else if(!isAuctionSalePriceRange){
                        [Alert alertWithMessage:@"Invalid auction sale price range ! Please enter valid auction sale price range."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index8 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else if(!isAuctionEstimatePriceRange){
                        [Alert alertWithMessage:@"Invalid auction estimate price range ! Please enter valid auction sale price range."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index9 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else if(!isAuctionHouseSaleLot){
                        [Alert alertWithMessage:@"Invalid auction house sale lot ! Please enter valid auction house sale lot."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index10 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else if(!isAuctionHouseTitle){
                        [Alert alertWithMessage:@"Invalid auction house sale title ! Please enter valid auction house title."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index11 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else if(!isAuctionHouseSale){
                        [Alert alertWithMessage:@"Invalid auction house sale  ! Please enter valid auction house sale."
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index12 atScrollPosition:UITableViewScrollPositionTop animated:YES];
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


- (IBAction)buttonSubmitTapped:(id)sender {
        
       [self isValidate];
}

@end
