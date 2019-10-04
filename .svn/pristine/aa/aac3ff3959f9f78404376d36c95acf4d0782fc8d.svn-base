//
//  SelectionListViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 19/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "SelectionListViewController.h"
#import "SelectionListTableViewCell.h"

#define COLOR_CELL_BACKGROUND   @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"


@interface SelectionListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
        UIActivityIndicatorView *activityIndicator;
        
        NSUInteger min;
        NSUInteger max;
}

@end

@implementation SelectionListViewController
@synthesize arrList;

static NSString *CellIdentifier1 = @"Cell1";

#pragma mark - View controller life cicle

- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        [self navigationBarConfiguration];
        
        [self setLogoImage];
    
        [self setBackButton];
        
        [self setDoneButton];
        
        [self registerCell];
        
        [self config];
        
        [self setActivityIndicator];
        
        [self getWebService];

}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
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
        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        self.view.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
#if SHADOW_ENABLE
        //        [Alert setShadowOnViewAtTop:self.viContainerAddToCart];
        //        [Alert setShadowOnViewAtTop:self.viContainerBuyNow];
        //        [Alert setShadowOnViewAtTop:self.lblSeparatorLineVirtical];
#endif
        
        //        [MyObject sharedClass].delegate=self;
        
        
        
}

-(void)registerCell{
        
        [self.tableView registerClass:[SelectionListTableViewCell class] forCellReuseIdentifier:CellIdentifier1];
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:NSStringFromClass([SelectionListTableViewCell class]) bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
        
}

-(void)setLogoImage{
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
}

-(void)setBackButton{
        
        UIButton * back  = [UIButton buttonWithType:UIButtonTypeSystem];
        back.frame = CGRectMake(0, 0, 50, 50);
        
        [back setTitle:@"Cancel" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        //        [back setImage:[UIImage imageNamed:IMAGE_BACK] forState:UIControlStateNormal];
        
        
        UIView* backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        backView.backgroundColor=[UIColor clearColor];
        [backView addSubview:back];
        
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
        
        [self.navigationItem setLeftBarButtonItem:leftBarItem];
}

-(void)setDoneButton{
        
        UIButton * back  = [UIButton buttonWithType:UIButtonTypeSystem];
        back.frame = CGRectMake(0, 0, 50, 50);
        
        [back setTitle:@"Done" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [back addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        //        [back setImage:[UIImage imageNamed:IMAGE_BACK] forState:UIControlStateNormal];
        
        
        UIView* backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        backView.backgroundColor=[UIColor clearColor];
        [backView addSubview:back];
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
        
        [self.navigationItem setRightBarButtonItem:rightBarItem];
}

- (void)goBack{
        //        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done{
        
        [self.delegate selectionListValue:@"" tag:self.tag];
        [self dismissViewControllerAnimated:YES completion:nil];
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
        [self.view insertSubview:activityIndicator aboveSubview:self.tableView];
        
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
        [self.navigationController.navigationBar setBackgroundImage:[self setNavBarImage]
                                                      forBarMetrics:UIBarMetricsDefault];
}


#pragma mark -Call WebService

-(void)getWebService {
        
        const char* className=[NSStringFromSelector(_cmd) UTF8String];
        
        dispatch_queue_t myQueue = dispatch_queue_create(className,NULL);
        dispatch_async(myQueue, ^{
                
                
             //   NSString *urlString = @"http://eastern.psgahlout.com/services/artservices/biddingAmount";
                
                NSString *urlString = JOIN_STRING(kPrefixUrl, kURL_GET_BIDDING_AMOUNT);
                //{"pid":"1462","uid":"92"}
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:self.artID forKey:@"pid"];
                
                
                
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
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if(arrList.count)       [self removeBackgroundLabel];
                                else                    [self setBackgroundLabel];
                                [self.tableView reloadData];
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
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        if(arrList.count)       [self removeBackgroundLabel];
                                        else                    [self setBackgroundLabel];
                                        [self.tableView reloadData];
                                });
                        }
                        else
                        {
                                
                                NSLog(@"Response : %@", result);
                                NSString *success  = [result valueForKey:@"success"];
                                NSString *error  = [result valueForKey:@"error"];
                                
                                if (success.boolValue) {
                                        
                                        NSArray* arr = (NSArray*)[result valueForKey:@"AmountList"];
                                        
                                        if(arr.count){
                                                min=[[arr firstObject] integerValue];
                                                max=[[arr lastObject] integerValue];
                                                
                                                if(min!=0 && max!=0){
                                                        
                                                        arrList=[[NSMutableArray alloc]init];
                                                        
                                                        NSInteger i=min;
                                                        
                                                        while (i<=max) {
                                                                [arrList addObject:[NSString stringWithFormat:@"%li",(long)i]];
                                                                i=i+50;
                                                        }
                                                        
                                                        if(max%i!=0)
                                                                [arrList addObject:[NSString stringWithFormat:@"%li",(long)max]];
                                                }
                                        }
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                //                                                self.lblAddToCard.text=(isCard=[self getCardDetail]) ? @"GO TO CART" : @"ADD TO CART";
                                                //                                                self.btnAddToCard.enabled=self.btnWishlist.enabled=data ? YES : NO;
                                        });
                                        
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
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger rows=0;
        
        rows=arrList.count;
        
        return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        float finalHeight=44;
        
        return finalHeight;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        SelectionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString* name=[NSString stringWithFormat:@"$ %@",[arrList objectAtIndex:indexPath.row]];
        cell.lblName.text=name;
                
                
        return cell;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSString* name=[arrList objectAtIndex:indexPath.row];
        
        if([self.delegate respondsToSelector:@selector(selectionListValue:tag:)])
                [self.delegate selectionListValue:name tag:self.tag];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
}




@end
