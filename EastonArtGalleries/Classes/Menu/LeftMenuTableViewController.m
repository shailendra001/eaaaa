//
//  LeftMenuTableViewController.m
//  Talk2Good
//
//  Created by Infoicon on 13/08/15.
//  Copyright (c) 2015 InfoiconTechnologies. All rights reserved.
//

#import "LeftMenuTableViewController.h"
#import "Alert.h"
#import "LeftMenuCell1.h"
#import "LeftMenuCell2.h"
#import "ArtCollectionViewController.h"
#import "BestSellingArtistsViewController.h"
#import "ArtCategoryViewController.h"
#import "ContactUsViewController.h"
#import "BlogViewController.h"
#import "AuctionViewController.h"
#import "ArtServicesViewController.h"
#import "MediaLecturesAndPublicationVC.h"
#import "ValuationOfArtViewController.h"
#import "ArtRegistrationViewController.h"


static NSString *CellIdentifier = @"Cell1";

static NSString *CellIdentifier1 = @"Cell2";

NSMutableSet * expandsection ;


@interface LeftMenuTableViewController ()
{
        NSArray * menuItems;
    NSArray * subAboutItems;
    NSArray * subservicesItems;


        //        DataBaseHandler* dataManager;
        BOOL isLogout;
}

@end

@implementation LeftMenuTableViewController

#pragma mark -
#pragma mark  App delegate

- (AppDelegate *)appDelegate {
        return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - View controller

- (void)awakeFromNib{
        [super awakeFromNib];
        // here comes the magic - call self.view and view will load as expected
        
}

- (void)viewDidLoad {
        [super viewDidLoad];
        
        [self setNotification];
        
        [self registerCell];
        
        [self loadUserDetail];
        
        [self config];
        
        
}

-(void)viewWillAppear:(BOOL)animated {
        
        [super viewWillAppear:animated];
    
    expandsection = [[NSMutableSet alloc] init];
        [self reloadTable];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

-(void)config{
        
        self.navigationController.navigationBarHidden =YES;
        
        self.tableView.tableFooterView = [[UIView alloc]init];
        
        
}

-(void)setNotification {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"OpenMenuNotification"
                                                   object:nil];
}

-(void)registerCell{
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"LeftMenuCell1" bundle:nil];
        UINib *contantsCellNib2 = [UINib nibWithNibName:@"LeftMenuCell2" bundle:nil];
        
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier];
        [self.tableView registerNib:contantsCellNib2 forCellReuseIdentifier:CellIdentifier1];
        
        
        
}

-(void)loadUserDetail{
//        menuItems = @[
//                      @"Home page",
//                      @"New art",
//                      @"Art medium",
//                      @"Artist",
//                      @"Services",
//                      @"Auction",
//                      @"Contact",
//                      @"Media",
//                      @"Blog",
//                      @"Terms of sale",
//                      @"Privacy policy",
//                      @"Terms & conditions"];
//
//}
menuItems = @[
              @"Home page",
              @"New art",
              @"Art medium",
              @"Artist",
              @"Services",
              @"About"];
    subAboutItems = @[
                  @"Contact",
                  @"Media",
                  @"Blog"];
    subservicesItems = @[
                     @"Art Valuation",
                     @"Art Registration",
                     @"Auction"];

}

-(void)alertWithMessage:(NSString*)msg{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert  show];
        
}


#pragma mark - Call Notification

- (void)receiveNotification:(NSNotification *) notification{
        
        
        //Open Menu Notification
        if ([[notification name] isEqualToString:@"OpenMenuNotification"]){
                //callInfo=notification.userInfo;
                
                [self reloadTable];
        }
        
        
}


-(void)reloadTable{
        dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:self.tableView
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                 
                                animations:nil
                                completion:nil];
                
                
                
                [self.tableView reloadData];
        });
        
        
}

/*
 -(void)webServiceCalled{
 
 NSString *urlString = @"http://104.131.112.76/leservice/services/providers/getMyServices";
 NSString *postString = [NSString stringWithFormat:@"{\"provider_id\":\"%@\"}",[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
 NSString *tempURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSLog(@" tempURL :%@  --postStr--- %@",tempURL,postString);
 if ([[SharedClass sharedObject] connected]) {
 NSLog(@"connected");
 WebService *webService = [[WebService alloc] initWithObject:self];
 webService.postString = postString;
 webService.methodname=@"getMyServices";
 webService.delegate = self;
 [webService setPostReqURL:tempURL];
 [webService getDataFromUrl];
 [[SharedClass sharedObject] addProgressHud:self.view];
 
 }else{
 
 }
 }
 
 -(void) webServiceFail:(NSError *) error{
 [[SharedClass sharedObject] hudeHide];
 [self alertWithMessage:@"Network connection lost"];
 
 }
 
 -(void) getdataFormWebService:(NSMutableDictionary *) webServiceDic methodnameIs:(NSString *)methodName{
 [[SharedClass sharedObject]hudeHide];
 if([methodName isEqualToString:@"deleteService"]) {
 [[SharedClass sharedObject] hudeHide];
 
 }
 
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    BOOL isexpand = [expandsection containsObject:[NSString stringWithFormat:@"%ld",(long)section]];
    if( isexpand){
        if (section == 4){
            return  subservicesItems.count;
        }else if (section == 5){
            return subAboutItems.count;
    }else{
        return  0;
    }
    }else{
         return  0;
    }
        NSInteger rows= menuItems.count;
//        switch (section) {
//                case 0:
//                       // rows=1; // did change
//                 rows=0;
//                        break;
//                case 1:
//                        rows=menuItems.count;
//                        break;
//
//                default:
//                        break;
//        }
        return rows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * headerview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, 60)];
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, headerview.frame.size.width-100, 50)];
  //  lbl.backgroundColor = UIColor.greenColor;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerview.frame.size.height-2, headerview.frame.size.width, 1)];
    line.backgroundColor = UIColor.lightGrayColor;
    lbl.text = menuItems[section];
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width, 15, 30, 30)];
  //  btnAdd.backgroundColor = UIColor.redColor;
    if ([expandsection containsObject:[NSString stringWithFormat:@"%ld",(long)section]]){
        [btnAdd setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    }else{
         [btnAdd setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    }
    btnAdd.tag = section;
   
  //  [btnAdd addTarget:self action:@selector(collapsebutton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionheaderTouched:)];
    [gesture setNumberOfTapsRequired:1];
    headerview.tag = section;
    [gesture setDelegate:self];
    [headerview addGestureRecognizer:gesture];
  
  //  btnAdd.backgroundColor = [UIColor redColor];
    if (section == 4 || section == 5){
        [headerview addSubview:btnAdd];
    }
    [headerview addSubview:lbl];
    [headerview addSubview:line];

    return headerview;
}

-(void)sectionheaderTouched:(UITapGestureRecognizer*)sender{
    
    UIView *headerView = (UIView *)sender.view;
    NSInteger section = headerView.tag;
    if (section == 4 || section == 5){
        BOOL  iscolapse = [expandsection containsObject:[NSString stringWithFormat:@"%ld",(long)section]];
        if (iscolapse == true){
            [expandsection removeObject:[NSString stringWithFormat:@"%ld",(long)section]];
        }else{
            [expandsection addObject:[NSString stringWithFormat:@"%ld",(long)section]];
        }
        [self reloadTable];

    }else{
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathWithIndex:section]];
       // [self.ta]
    }
  
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  50;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        float height=50;
//        switch (indexPath.section) {
//                case 0:
//                      //  height=87.0f;  // did change
//                   height=40.0;
//                        break;
//
//                case 1:
//                        height=44.0f;
//                        break;
//
//                default:
//                        break;
//        }
        return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftMenuCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 4){
        NSString *menuItem = [subservicesItems objectAtIndex:indexPath.row];
          cell.lblName.text=menuItem;
    }else if (indexPath.section == 5){
        NSString *menuItem = [subAboutItems objectAtIndex:indexPath.row];
          cell.lblName.text=menuItem;
    }
  //  NSString *menuItem = [menuItems objectAtIndex:indexPath.row];
         // did change
      //  if(indexPath.section==0){
//                LeftMenuCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
              //  cell.lblName.text=[[EAGallery sharedClass]isLogin] ? [[EAGallery sharedClass]name] : @"Guest";
//
//                NSURL* url=[NSURL URLWithString:IS_EMPTY([[EAGallery sharedClass] profileImage]) ? nil :[[EAGallery sharedClass] profileImage]];
//
//
//
//
//                for (id view in cell.contentView.subviews) {
//
//                        if([view isKindOfClass:[UIActivityIndicatorView class]])
//                                [view removeFromSuperview];
//                }
//
//
//                UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                activityIndicator1.frame = CGRectMake(cell.viContainerImage.frame.size.width/2-15,
//                                                      cell.viContainerImage.frame.size.height/2-15,
//                                                      30,
//                                                      30);
//                [activityIndicator1 startAnimating];
//                activityIndicator1.tag=indexPath.row;
//
//                [activityIndicator1 removeFromSuperview];
//                if(url){
//                        [cell.viContainerImage addSubview:activityIndicator1];
//                        [cell.viContainerImage insertSubview:activityIndicator1 aboveSubview:cell.img];
//                }
//
//
//                //                cell.img.backgroundColor=[UIColor whiteColor];
//                UIImage* imgPlaceHolder=[UIImage imageNamed:@"default_user2.png"];
//
//                __weak UIImageView *weakImgPic = cell.img;
//                [cell.img setImageWithURL:url
//                         placeholderImage:imgPlaceHolder
//                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
//                 {
//                         [activityIndicator1 stopAnimating];
//                         [activityIndicator1 removeFromSuperview];
//
//                         UIImageView *strongImgPic = weakImgPic;
//                         if (!strongImgPic) return;
//
//                         [UIView transitionWithView:strongImgPic
//                                           duration:0.3
//                                            options:UIViewAnimationOptionTransitionCrossDissolve
//
//                                         animations:^{
//                                                 strongImgPic.image=image;
//
//                                         }
//                                         completion:^(BOOL finish){
//                                         }];
//                 } failure:NULL];
//
//                [cell.btnImage addTarget:self action:@selector(openProfile:) forControlEvents:UIControlEventTouchUpInside];
//
//                return cell;
     //   }
    //    else if(indexPath.section==1){
    
          //  cell.btnplus.tag = indexPath.row;
         //   [cell.btnplus addTarget:self action:@selector(collapsebutton) forControlEvents:UIControlEventTouchUpInside];
                return cell;
       // }
      //  return nil;
        
}
-(void)collapsebutton:(UIButton*)sender{
    
       // let isCollapsed = !expandsection.contains(sectiontagged)
    BOOL  iscolapse = [expandsection containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    if (iscolapse == true){
        [expandsection removeObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }else{
        [expandsection addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
    [self reloadTable];

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
       // [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        switch (indexPath.section) {
                case 0:
                        
                {
                    
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(GET_VIEW_CONTROLLER(kViewController));
//                        if([[EAGallery sharedClass]isLogin]){
//                                if([self.navigationController.visibleViewController isKindOfClass:[DashboardViewController class]]) return;
//
//                                DashboardViewController*vc=GET_VIEW_CONTROLLER(kDashboardViewController);
//                                vc.titleString=@"Dashboard";
//
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//                        }
//                        else{
//                                if([self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]) return;
//
//                                LoginViewController*vc=GET_VIEW_CONTROLLER(kLoginViewController);
//                                vc.titleString=@"Login";
//
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//                        }
                    
                        
                        
                }
                        break;
            case 1:
            {
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_NewArt);
                                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                                                [data setObject:@"15" forKey:@"limit"];
                
                
                                                ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
                
                                                vc.titleString=[menuItems objectAtIndex:indexPath.section];
                                                vc.urlString=urlString;
                                                vc.urlData=[data mutableCopy];
                                                vc.dataAccesskey=@"getLatestArt";
                                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
            }
                break;
                
            case 2:{
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ArtCategory);
                                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                                                [data setObject:@"category" forKey:@"page"];
                
                                                ArtCategoryViewController* vc=GET_VIEW_CONTROLLER(kArtCategoryViewController);
                
                                                vc.titleString=[menuItems objectAtIndex:indexPath.section];
                                                vc.urlString=urlString;
                                                vc.urlData=[data mutableCopy];
                                                vc.dataAccesskey=@"categoryList";
                                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
            }
                break;
                
            case 3:{
                                                                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
                                                                                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
                                                                                                [data setObject:@"artist" forKey:@"page"];
                
                                                BestSellingArtistsViewController* vc=GET_VIEW_CONTROLLER(kBestSellingArtistsViewController);
                
                                                                                                vc.titleString=[menuItems objectAtIndex:indexPath.section];
                                                                                                vc.urlString=urlString;
                                                                                                vc.urlData=[data mutableCopy];
                                                                                                vc.dataAccesskey=@"Artist";
                                                vc.titleString=@"All Artists";
                                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
            }
                break;
                
            case 4:{
            //    NSIndexPath *indxpath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                switch (indexPath.row){
                        
                    case 0:{
                        ValuationOfArtViewController* vc=GET_VIEW_CONTROLLER(kValuationOfArtViewController);
                      //  vc.from=@"back";
                        vc.titleString=[subservicesItems objectAtIndex:indexPath.row];
                             MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                    }
                        break;
                    case 1:{
                        
                        ArtRegistrationViewController* vc=GET_VIEW_CONTROLLER(kArtRegistrationViewController);
                      //  vc.from=@"back";
                        vc.dataAccesskey=@"categoryList";
                        vc.titleString = @"REGISTRATION OF YOUR ART WORK";//[arrItems objectAtIndex:indexPath.row];
                      //  MOVE_VIEW_CONTROLLER(vc, YES);
                             MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                    }
                        break;
                        
                    case 2:{
                      
                        NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AUCTION_ART_LIST);
                        AuctionViewController* vc=GET_VIEW_CONTROLLER(kAuctionViewController);
                        vc.urlString=urlString;
                        vc.urlData=nil;
                        vc.dataAccesskey=@"AuctionList";
                        vc.titleString=@"Auction";
                      //  vc.from=@"back";
                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);

                    }
                        break;
                }
            }
                break;
            case 5:{
                
                switch (indexPath.row){
                        
                    case 0:{
                        ContactUsViewController* vc=GET_VIEW_CONTROLLER(kContactUsViewController);
                                                        vc.titleString=[subAboutItems objectAtIndex:indexPath.row];
                                                        //                        vc.from=@"back";
                                                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                    }
                        break;
                    case 1:{
                        MediaLecturesAndPublicationVC* vc=GET_VIEW_CONTROLLER(kMediaLecturesAndPublicationVC);
                                                      //  vc.from=[subAboutItems objectAtIndex:indexPath.row];
                                      vc.lblTitle = [subAboutItems objectAtIndex:indexPath.row];
                                                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                    }
                        break;
                        
                    case 2:{
                        BlogViewController* vc=GET_VIEW_CONTROLLER(kBlogViewController);
                                                        vc.titleString=[subAboutItems objectAtIndex:indexPath.row];
                        
                                                        //                        vc.from=@"back";
                                                        MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
                    }
                        break;
                }
            }
              //  case 1:
                     //   switch (indexPath.row)
//                {
//
//                        case 0:
//                        {
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(GET_VIEW_CONTROLLER(kViewController));
//
//
//                        }
//                                break;
//                        case 1:
//                        {
//                                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_NewArt);
//                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
//                                [data setObject:@"15" forKey:@"limit"];
//
//
//                                ArtCollectionViewController* vc=GET_VIEW_CONTROLLER(kArtCollectionViewController);
//
//                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
//                                vc.urlString=urlString;
//                                vc.urlData=[data mutableCopy];
//                                vc.dataAccesskey=@"getLatestArt";
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//                        }
//                                break;
//                        case 2:
//                        {
//                                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_ArtCategory);
//                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
//                                [data setObject:@"category" forKey:@"page"];
//
//                                ArtCategoryViewController* vc=GET_VIEW_CONTROLLER(kArtCategoryViewController);
//
//                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
//                                vc.urlString=urlString;
//                                vc.urlData=[data mutableCopy];
//                                vc.dataAccesskey=@"categoryList";
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//                        }
//                                break;
//
//                        case 3:
//                        {
//
//                                //                                                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_Artist);
//                                //                                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
//                                //                                                [data setObject:@"artist" forKey:@"page"];
//
//                                BestSellingArtistsViewController* vc=GET_VIEW_CONTROLLER(kBestSellingArtistsViewController);
//
//                                //                                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
//                                //                                                vc.urlString=urlString;
//                                //                                                vc.urlData=[data mutableCopy];
//                                //                                                vc.dataAccesskey=@"Artist";
//                                vc.titleString=@"All Artists";
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//
//                        }
//                                break;
//
//                        case 4:
//                        {
//                                ArtServicesViewController* vc=GET_VIEW_CONTROLLER(kArtServicesViewController);
//                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//                        }
//                                break;
//
//                        case 5:
//                        {

//                                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_AUCTION_ART_LIST);
//                                NSMutableDictionary* data=[NSMutableDictionary dictionary];
//                                [data setObject:@"category"                     forKey:@"page"];
//                                [data setObject:@"4"       forKey:@"cat_id"];
//
//                                AuctionViewController* vc=GET_VIEW_CONTROLLER(kAuctionViewController);
//                                vc.urlString=urlString;
//                                vc.urlData=nil;//[data mutableCopy];
//                                vc.dataAccesskey=@"AuctionList";//@"categoryList";
//                                vc.titleString=@"Auction";
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//
//                        }
//                                break;
//                        case 6:
//                        {
//
//                                ContactUsViewController* vc=GET_VIEW_CONTROLLER(kContactUsViewController);
//                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
//                                //                        vc.from=@"back";
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//                        }
//                                break;
//                        case 7:
//                        {
//                                MediaLecturesAndPublicationVC* vc=GET_VIEW_CONTROLLER(kMediaLecturesAndPublicationVC);
//                                vc.from=[menuItems objectAtIndex:indexPath.row];
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//                        }
//                                break;
//                        case 8:
//                        {
//
//                                BlogViewController* vc=GET_VIEW_CONTROLLER(kBlogViewController);
//                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
//                                //                        vc.from=@"back";
//                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
//
//                        }
//                                break;
////                        case 9:
////                        {
////
////                                CustomWebViewController* vc=GET_VIEW_CONTROLLER(kWebViewController);
////                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
////                                //                                                vc.from=@"back";
////                                vc.isWebService=YES;
////                                vc.urlString=JOIN_STRING(kPrefixUrl, kURL_AboutUs);
////
////                                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
////                                [dic setObject:@"terms-of-sale" forKey:@"page_url"];
////                                vc.webServiceData=[dic mutableCopy];
////                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
////                        }
////                                break;
//
////                        case 10:
////                        {
////
////                                CustomWebViewController* vc=GET_VIEW_CONTROLLER(kWebViewController);
////                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
////                                //                                                vc.from=@"back";
////                                vc.isWebService=YES;
////                                vc.urlString=JOIN_STRING(kPrefixUrl, kURL_AboutUs);
////
////                                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
////                                [dic setObject:@"privacy-policy" forKey:@"page_url"];
////                                vc.webServiceData=[dic mutableCopy];
////                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
////                        }
////                                break;
//
////                        case 11:
////                        {
////                                CustomWebViewController* vc=GET_VIEW_CONTROLLER(kWebViewController);
////                                vc.titleString=[menuItems objectAtIndex:indexPath.row];
////                                //                                                vc.from=@"back";
////                                vc.isWebService=YES;
////                                vc.urlString=JOIN_STRING(kPrefixUrl, kURL_AboutUs);
////
////                                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
////                                [dic setObject:@"terms-conditions" forKey:@"page_url"];
////                                vc.webServiceData=[dic mutableCopy];
////                                MOVE_VIEW_CONTROLLER_VIEW_DECK(vc);
////                        }
////                                break;
//
//                        default:
//                                break;
//
//
//                }
                
                        break;
                        
                default:
                        break;
        }
        
        
        
}


-(IBAction)openProfile:(id)sender{
        
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
@end
