//
//  ChangePasswordViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 22/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "RegistrationViewCell.h"
#import "UpdateProfileViewCell4.h"

#define COLOR_CELL_BACKGROUND   @"#DEDEDD"
#define COLOR_CELL_HEADER       @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"

@interface ChangePasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
        UIActivityIndicatorView *activityIndicator;
        NSMutableArray* arrData;
        NSMutableArray* arrTextData;
        BOOL isUpdateHeight;
}

@end

@implementation ChangePasswordViewController

static NSString *CellIdentifier1 = @"Cell1";
static NSString *CellIdentifier2 = @"Cell2";


#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
    
        [self cellRegister];
        
        [self loadData];
        
        [self config];
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

#pragma mark - THSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
        return self.viewTitle ? self.viewTitle : self.title;
}


#pragma mark - Custom Methods

-(void)config{
        
        
//        self.lblTitle.text=[self.titleString uppercaseString];
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
                
                [dic setObject:@"* Old Password"                                forKey:@"msg"];
                [dic setObject:@"key_icon.png"                                  forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"* New Password"                                forKey:@"msg"];
                [dic setObject:@"key_icon.png"                                  forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"* Confirm Password"                            forKey:@"msg"];
                [dic setObject:@"key_icon.png"                                  forKey:@"icon"];
                [dic setObject:[Alert colorFromHexString:COLOR_CELL_TEXT]       forKey:@"color"];
                [arrData addObject:dic];
                
                
                
                
        }
        
        {
                arrTextData=[[NSMutableArray alloc]init];
                
                for (int i=0; i<3; i++) {
                        NSString* text=@"";
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
        
        [self.tableView registerClass:[RegistrationViewCell class] forCellReuseIdentifier:CellIdentifier1];
        [self.tableView registerClass:[UpdateProfileViewCell4 class] forCellReuseIdentifier:CellIdentifier2];
        //        //        [self.tableView registerClass:[ArtDetailViewCell3 class] forCellReuseIdentifier:CellIdentifier3];
        //
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"RegistrationViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        //
        UINib *contantsCellNib2= [UINib nibWithNibName:@"UpdateProfileViewCell4" bundle:nil];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier2];
        //
        //        UINib *contantsCellNib3 = [UINib nibWithNibName:@"ArtDetailViewCell3" bundle:nil];
        //        [self.tableView registerNib:contantsCellNib3 forCellReuseIdentifier:CellIdentifier3];
        
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

-(void)removeActivityIndicator {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
}

-(void)setBackgroundLabel {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data found";
        messageLabel.textColor = [Alert colorFromHexString:COLOR_CELL_TEXT];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:18];
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

#pragma mark -Call WebService

-(void)getWebService:(NSDictionary*)dic images:(NSArray*)images{
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ChangePassword);
                
                NSString *postString =[Alert jsonStringWithDictionary:[dic mutableCopy]];
                
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
                                                       gotoBack:NO animation:YES second:3.0];
                                });
                                
                                if (success.boolValue) {
                                        
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
                                        
                                }
                                else{
                                }
                                
                        }
                        
                }
                
        });
        
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        switch (section) {
                case 0:
                        rows=3;
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
        switch (indexPath.section) {
                case 0:
                        height=44.0f;
                        break;
                case 1:
                        height=41.0f;
                        break;
                        
                default:
                        break;
        }
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if(indexPath.section==0) {
                
                NSDictionary *item = [arrData objectAtIndex:indexPath.row];
                
                RegistrationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.txtName.font=[UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:13];
                cell.txtName.text=[arrTextData objectAtIndex:indexPath.row];
                
                cell.txtName.delegate=self;
                
                cell.img.image=[UIImage imageNamed:[item objectForKey:@"icon"]];
                //cell.txtName.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
                
                if(IS_EMPTY([arrTextData objectAtIndex:indexPath.row]))
                        [Alert attributedString:cell.txtName
                                            msg:[item objectForKey:@"msg"]
                                          color:[item objectForKey:@"color"]];
                
                cell.txtName.tag=indexPath.row;
                cell.txtName.autocorrectionType=UITextAutocorrectionTypeNo;
                
                cell.txtName.secureTextEntry=YES;
                
                cell.txtName.keyboardType = UIKeyboardTypeDefault;
                
                [cell.txtName addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
                
                
                //Tint color
                cell.txtName.tintColor=[UIColor blackColor];
                
                cell.contentView.backgroundColor=[UIColor clearColor];
//                cell.viContainerText.backgroundColor=[UIColor whiteColor];
                return cell;
                
        }
        else if (indexPath.section==1) {
                
                UpdateProfileViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor=[UIColor whiteColor];
                cell.btnClick.tag=indexPath.row;
                [cell.btnClick addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
        }
        
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}

#pragma Mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        
        [textField resignFirstResponder];
        
        
        if(!isUpdateHeight){
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.tableView.frame.size.height - 180);
        }
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:textField.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isUpdateHeight=YES;
        
        return YES;
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
        
        
        
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
        [textField resignFirstResponder];
        
        RegistrationViewCell * cell;
        
        if(textField.tag==0 && !IS_EMPTY(textField.text)) {
                
                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                [cell.txtName becomeFirstResponder];
        }
        else if(textField.tag==1 && !IS_EMPTY(textField.text)) {
                
                cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
                [cell.txtName becomeFirstResponder];
        }
        else if(textField.tag==2 && !IS_EMPTY(textField.text)) {
                
                if(![arrTextData[1] isEqualToString:arrTextData[2]]){
                        [Alert alertWithMessage:@"Confirm password do not match !"
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [textField becomeFirstResponder];

                }
                else{
                
                        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
        }
        
        if(isUpdateHeight) {
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x,
                                                 self.tableView.frame.origin.y,
                                                 self.tableView.frame.size.width,
                                                 self.view.frame.size.height-50);
                
                
        }
        
        isUpdateHeight=NO;
        
        return YES;
}

-(void)textFieldDidChange:(id)sender {
        
        //        isUpdate=YES;
        //        //[self.btnUpdate setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        //
        //        //[Alert viewButtonCALayer:[UIColor grayColor] viewButton:self.btnUpdate];
        //        self.btnUpdate.backgroundColor=[UIColor orangeColor];
        //
        BOOL isValid=NO;
        //
        UITextField* txt=(UITextField*)sender;
        //        if(txt.tag==0)
        //                isValid=[Alert validationEmail:txt.text];
        
        
//        if(txt.tag==0 || txt.tag==1) isValid=YES;
        isValid=YES;
        
        txt.textColor=isValid ? [UIColor blackColor] : [UIColor redColor];
        
        arrTextData[txt.tag]=txt.text;
        
}


-(void)updatePassword {
        
        NSIndexPath* index2=[NSIndexPath indexPathForRow:2 inSection:0];
        
        if(!IS_EMPTY([arrTextData objectAtIndex:0]) &&
           !IS_EMPTY([arrTextData objectAtIndex:1]) &&
           !IS_EMPTY([arrTextData objectAtIndex:2])){
                BOOL isSame=[[arrTextData objectAtIndex:1] isEqualToString:[arrTextData objectAtIndex:2]];
                if(!isSame) {
                        
                        [Alert alertWithMessage:@"Confirm password do not match !"
                                     navigation:self.navigationController
                                       gotoBack:NO animation:YES second:3.0];
                        [self.tableView scrollToRowAtIndexPath:index2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        return;
                        
                }
                else
                {
                        //{"user_id":"81","old_password":"123","new_password":"1234"}
                        
                        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                        
                        [dic setObject:[[EAGallery sharedClass] memberID]       forKey:@"user_id"];
                        [dic setObject:[arrTextData objectAtIndex:0]            forKey:@"old_password"];
                        [dic setObject:[arrTextData objectAtIndex:1]            forKey:@"new_password"];
                        
                        [self getWebService:[dic mutableCopy] images:nil];
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

#pragma mark - Target Methods

-(IBAction)update:(id)sender {
        
        [self updatePassword];
        
}

@end