//
//  EAGallery.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "EAGallery.h"
#import "RegistrationViewController.h"
#import "LoginViewController.h"
#import "WishListViewController.h"
#import "BecomeASellerViewController.h"

@interface EAGallery ()<FPPopoverControllerDelegate,buttontitledelgate,UIPopoverPresentationControllerDelegate>
{
        BOOL isMenu;
        
        FPPopoverKeyboardResponsiveController *popover;
        DemoTableController *tableSuggesstionDictionary;
}
@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;

@property(strong, nonatomic) UIViewController* vc;
@end

@implementation EAGallery

@synthesize isLogin;

+ (EAGallery*)sharedClass {
        
        static EAGallery* obj = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                obj = [[self alloc] init];
                [obj fetchLocalData];
        });
        
        return obj;
        
}

#pragma mark - Login details

-(void)saveDataLocal{
        
        NSMutableDictionary* userData=[NSMutableDictionary dictionary];
        NSString* email         =IS_EMPTY(self.email)        ? @"" : self.email;
        NSString* country       =IS_EMPTY(self.country)      ? @"" : self.country;
        NSString* name          =IS_EMPTY(self.name)         ? @"" : self.name;
        NSString* username      =IS_EMPTY(self.userName)     ? @"" : self.userName;
        NSString* phone         =IS_EMPTY(self.phone)        ? @"" : self.phone;
        NSString* memberID      =IS_EMPTY(self.memberID)     ? @"" : self.memberID;
        NSString* registeredOn  =IS_EMPTY(self.registeredOn) ? @"" : self.registeredOn;
        NSString* pImg          =IS_EMPTY(self.profileImage) ? @"" : self.profileImage;
        NSString* cImg          =IS_EMPTY(self.coverImage)   ? @"" : self.coverImage;
        NSString* bio           =IS_EMPTY(self.bio)          ? @"" : self.bio;
        NSString* profileVideo  =IS_EMPTY(self.profileVideo) ? @"" : self.profileVideo;
        NSString* walletAmount  =IS_EMPTY(self.walletAmount) ? @"" : self.walletAmount;
        
        
        
        [userData setObject:name                forKey:LOGIN_NAME];
        [userData setObject:username            forKey:LOGIN_USER_NAME];
        [userData setObject:email               forKey:LOGIN_EMAIL];
        [userData setObject:country             forKey:LOGIN_COUNTRY];
        [userData setObject:phone               forKey:LOGIN_PHONE];
        [userData setObject:pImg                forKey:LOGIN_PROFILE_IMAGE];
        [userData setObject:cImg                forKey:LOGIN_COVER_IMAGE];
        [userData setObject:bio                 forKey:LOGIN_BIO];
        [userData setObject:profileVideo        forKey:LOGIN_VIDEO_LINK];
        [userData setObject:memberID            forKey:LOGIN_MEMBER_ID];
        [userData setObject:registeredOn        forKey:LOGIN_REGISTERED_ON];
        [userData setObject:walletAmount        forKey:LOGIN_WALLET_AMOUNT];
        [userData setObject:@(self.type)        forKey:LOGIN_TYPE];
        [userData setObject:@(self.roleType)    forKey:LOGIN_ROLE_TYPE];
        
        self.email              =email;
        self.country            =country;
        self.name               =name;
        self.userName           =username;
        self.phone              =phone;
        self.profileImage       =pImg;
        self.coverImage         =cImg;
        self.bio                =bio;
        self.profileVideo       =profileVideo;
        self.memberID           =memberID;
        self.registeredOn       =registeredOn;
        self.walletAmount       =walletAmount;
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
}

-(void)fetchLocalData{
        
        NSMutableDictionary* userData=[[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
        BOOL isLoginUser=userData && ![userData isEqual:@""];
        
        if(isLoginUser){
                self.name            =[userData      objectForKey:LOGIN_NAME];
                self.userName        =[userData      objectForKey:LOGIN_USER_NAME];
                self.email           =[userData      objectForKey:LOGIN_EMAIL];
                self.country         =[userData      objectForKey:LOGIN_COUNTRY];
                self.phone           =[userData      objectForKey:LOGIN_PHONE];
                self.profileImage    =[userData      objectForKey:LOGIN_PROFILE_IMAGE];
                self.coverImage      =[userData      objectForKey:LOGIN_COVER_IMAGE];
                self.bio             =[userData      objectForKey:LOGIN_BIO];
                self.profileVideo    =[userData      objectForKey:LOGIN_VIDEO_LINK];
                self.memberID        =[userData      objectForKey:LOGIN_MEMBER_ID];
                self.walletAmount    =[userData      objectForKey:LOGIN_WALLET_AMOUNT];
                self.type            =[self getLoginType:
                                                        [[userData     objectForKey:LOGIN_TYPE] intValue]];
                self.roleType        =[self getRoleType:
                                                        [[userData     objectForKey:LOGIN_ROLE_TYPE] intValue]];
                self.registeredOn    =[userData      objectForKey:LOGIN_REGISTERED_ON] ;
                self.isLogin=YES;
                
                
        }
        
}

-(void)removeUserDetail{
        //Remove detail
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"info"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        //Assign nil
        self.name            =@"";
        self.userName        =@"";
        self.email           =@"";
        self.country         =@"";
        self.phone           =@"";
        self.profileImage    =@"";
        self.coverImage      =@"";
        self.bio             =@"";
        self.profileVideo    =@"";
        self.memberID        =@"";
        self.type            =Default;
        self.roleType        =NormalUser;
        self.registeredOn    =@"";
        self.isLogin=NO;
        
        //Facebook logout
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        //Google Plus logout
        [[GPPSignIn sharedInstance] signOut];
        
        
}

-(int)getLoginType:(NSInteger)type{
        
        int result=Default;
        switch (type) {
                case Facebook:
                        result=Facebook;
                        break;
                case Twitter:
                        result=Twitter;
                        break;
                case GooglePlus:
                        result=GooglePlus;
                        break;

                case EmailId:
                        result=EmailId;
                        break;
                        
                default:
                        result=Default;
                        break;
        }
        return result;
        
}

-(int)getRoleType:(NSInteger)type{
        
        int result=NormalUser;
        switch (type) {
                case NormalUser:
                                result=NormalUser;
                        break;
                case BecomeAnArtist:
                                result=BecomeAnArtist;
                        break;
                case BecomeAnArtistPending:
                                result=BecomeAnArtistPending;
                        break;
                        
                default:
                        result=NormalUser;
                        break;
        }
        return result;
        
}

#pragma mark - Animation

-(void)flipView:(UIView*)view{
        
        CATransition* transition = [CATransition animation];
        transition.startProgress = 0;
        transition.endProgress = 1.0;
        transition.type = @"flip";
        transition.subtype = @"fromRight";
        transition.duration = 0.7;
        transition.repeatCount = 2;
        [view.layer addAnimation:transition forKey:@"transition"];
        
}

#pragma mark - Top nav Bar items 

-(NSArray*)loadMenuOptionsForBeforeLogin{
        
        NSMutableArray* arr=[[NSMutableArray alloc]init];
        
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
	
	dic=[NSMutableDictionary dictionary];
	[dic setObject:@"Merchandise" forKey:@"title"];
	[dic setObject:@"Merchandise" forKey:@"vc"];
	[arr addObject:dic];

	dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Register as an artist" forKey:@"title"];
        [dic setObject:kBecomeASellerViewController forKey:@"vc"];
        [arr addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Register as a buyer" forKey:@"title"];
        [dic setObject:kRegistrationViewController forKey:@"vc"];
        [arr addObject:dic];

        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Login" forKey:@"title"];
        [dic setObject:kLoginViewController forKey:@"vc"];
        [arr addObject:dic];
        
        return arr.count ? arr : nil;
}

-(NSArray*)loadMenuOptionsForAfterLogin{
        
        NSMutableArray* arr=[[NSMutableArray alloc]init];
        
        
        NSMutableDictionary* dic;
	
	dic=[NSMutableDictionary dictionary];
	[dic setObject:@"Merchandise" forKey:@"title"];
	[dic setObject:@"Merchandise" forKey:@"vc"];
	[arr addObject:dic];

        if([[EAGallery sharedClass] roleType]==BecomeAnArtist){
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Manage Art" forKey:@"title"];
                [dic setObject:kBecomeASellerViewController forKey:@"vc"];
                [arr addObject:dic];
        }
        else{
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Become a seller" forKey:@"title"];
                [dic setObject:kBecomeASellerViewController forKey:@"vc"];
                [arr addObject:dic];
        }
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Wishlist" forKey:@"title"];
        [dic setObject:kWishListViewController forKey:@"vc"];
        [arr addObject:dic];
        
        dic=[NSMutableDictionary dictionary];
        [dic setObject:@"Logout" forKey:@"title"];
        [dic setObject:@"Logout" forKey:@"vc"];
        [arr addObject:dic];

        
        return arr;
}

#pragma mark - 

-(IBAction)popover:(id)sender vc:(UIViewController*)vc{
        self.vc=vc;
        vc.view.backgroundColor=[UIColor clearColor];
        
        UIButton* button=(UIButton*)sender;
        NSArray *arrData = [self isLogin] ?
        [[self loadMenuOptionsForAfterLogin] valueForKeyPath:@"title"]:
        [[self loadMenuOptionsForBeforeLogin]valueForKeyPath:@"title"];
        
        POPTableController *yourViewController =GET_VIEW_CONTROLLER_STORYBOARD(kPOPTableController);
        [yourViewController loadData:[arrData mutableCopy]];
//        yourViewController.tableView.backgroundColor=[UIColor clearColor];
//        yourViewController.view.backgroundColor=[UIColor clearColor];
        yourViewController.btndelegate = self;
        
        UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:yourViewController];/*Here dateVC is controller you want to show in popover*/
        yourViewController.preferredContentSize = CGSizeMake(150,80);
        destNav.modalPresentationStyle = UIModalPresentationPopover;
        _dateTimePopover8 = destNav.popoverPresentationController;
        _dateTimePopover8.delegate = self;
        _dateTimePopover8.sourceView = vc.view;
        _dateTimePopover8.backgroundColor=[UIColor whiteColor];

        
        
//        UIBarButtonItem *item = self.addButton ;
        
//        UIView *view1 = [item valueForKey:@"view"];
        CGRect frame=button.superview.superview.frame;
        frame.origin.x+=35;
        frame.origin.y=-40;
        
        _dateTimePopover8.sourceRect = frame;
        
        // _dateTimePopover8.sourceRect = [sender frame];
        
        // _dateTimePopover8.sourceRect = sender.frame; //CGRectMake(50, 50, 300, 200);
        destNav.navigationBarHidden = YES;
        [self.vc presentViewController:destNav animated:YES completion:nil];
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
        return UIModalPresentationNone;
}


#pragma mark - =====: Popover View :=====
/*
-(void)popover:(id)sender vc:(UIViewController*)vc{
        
        self.vc=vc;
        
        NSArray *taxiTypeNameArray = [self isLogin] ?
        [[self loadMenuOptionsForAfterLogin] valueForKeyPath:@"title"]:
        [[self loadMenuOptionsForBeforeLogin]valueForKeyPath:@"title"];
        
        UIButton* button=(UIButton*)sender;
        button.backgroundColor=[UIColor whiteColor];
        
        if(popover)
        {
                SAFE_ARC_RELEASE(popover);
                popover = nil;
                tableSuggesstionDictionary = nil;
        }
        tableSuggesstionDictionary = [[DemoTableController alloc] initWithStyle:UITableViewStylePlain];
        tableSuggesstionDictionary.selectedArray = [taxiTypeNameArray copy];
        //tableSuggesstionDictionary.selectItemValueArray = [@[@"Login",@"Sign up"] copy];
        tableSuggesstionDictionary.tableView.backgroundColor = [UIColor whiteColor];
        tableSuggesstionDictionary.btndelegate=self;
        
        popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:tableSuggesstionDictionary];
        popover.delegate = self;
        popover.contentSize = CGSizeMake(150, 150);
        popover.tint = FPPopoverWhiteTint;
        popover.arrowDirection = FPPopoverArrowDirectionAny;
        popover.border=NO;
        [popover presentPopoverFromView:sender];
        
        button.backgroundColor=[UIColor clearColor];
        
}
*/
#pragma mark - =====: Popover Delegate ::=====
-(void)buttonTittle:(NSString *)title selectedIndex:(int)index{
        //taxiNameArray
        
        NSLog(@"%@->%d",title,index);
        
        //self.vc.view.backgroundColor=[UIColor whiteColor];
        [self.vc dismissViewControllerAnimated:YES completion:^{
        
        
        /*
        
        [popover dismissPopoverAnimated:NO];
        SAFE_ARC_RELEASE(popover);
        popover = nil;
        tableSuggesstionDictionary = nil;
        */
        [self didSelectedMenuItem:title
                            items:   [self isLogin] ?
                                [self loadMenuOptionsForAfterLogin]:
                                [self loadMenuOptionsForBeforeLogin]

                              nav:self.vc.navigationController];
        //self.vc=nil;
        }];
        
}


-(void)didSelectedMenuItem:(NSString*)name items:(NSArray*)items nav:(UINavigationController*)nav{

        NSDictionary* dic=[self matchNameWithArray:items Name:name].count ?
        [[self matchNameWithArray:items Name:name] objectAtIndex:0] :nil ;
        
        
        if(dic){
		NSString* item=[dic objectForKey:@"vc"];
		
		if([item isEqualToString:@"Merchandise"]){
			CustomWebViewController* vc=GET_VIEW_CONTROLLER_STORYBOARD(kWebViewController);
			vc.titleString=@"Merchandise";
			vc.urlString=@"https://shopeastonartgalleries.com/";
			vc.from=@"back";
			[nav.viewDeckController rightViewPushViewControllerOverCenterController:vc];
		}
		
                if([self isLogin]){
                        
			
                        if([item isEqualToString:@"Logout"]){
                                
                                [self removeUserDetail];
                        }
                        
                        
                        
                        
                        if([item isEqualToString:kBecomeASellerViewController]){
                                
                                if([[Alert getClassNameFromObject:nav.visibleViewController] isEqualToString:kBecomeASellerViewController]) return;
                                
                                DashboardViewController*vc=GET_VIEW_CONTROLLER_STORYBOARD(kDashboardViewController);
                                vc.titleString=@"Dashboard";
                                vc.selectedIndex=3;
                                
                                [nav.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        }
                        if([item isEqualToString:kWishListViewController]){
                                
                                if([[Alert getClassNameFromObject:nav.visibleViewController] isEqualToString:kWishListViewController]) return;
                                
                                WishListViewController* vc=GET_VIEW_CONTROLLER_STORYBOARD(kWishListViewController);
                                vc.from=@"back";
                                vc.titleString=@"WishList";
                                [nav.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        }
                        
                        
                }
                else{
//                        NSString* item=[dic objectForKey:@"vc"];
			
                        if([item isEqualToString:kBecomeASellerViewController]){
                                
                                if([nav.visibleViewController isKindOfClass:[BecomeASellerViewController class]]) return;
                                
                                BecomeASellerViewController*vc=GET_VIEW_CONTROLLER_STORYBOARD(kBecomeASellerViewController);
                                vc.titleString=name;
                                vc.from=@"popup";
                                
                                [nav.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        }

                        if([item isEqualToString:kRegistrationViewController]){
                                
                                
                                if([nav.visibleViewController isKindOfClass:[RegistrationViewController class]]) return;
                                
                                RegistrationViewController*vc=GET_VIEW_CONTROLLER_STORYBOARD(item);
                                vc.titleString=name;
                                //vc.from=@"back";
                                
                                [nav.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        }
                        
                        if([item isEqualToString:kLoginViewController]){
                                
                                
                                if([nav.visibleViewController isKindOfClass:[LoginViewController class]]) return;
                                
                                LoginViewController*vc=GET_VIEW_CONTROLLER_STORYBOARD(item);
                                vc.titleString=name;
                                //vc.from=@"back";
                                
                                [nav.viewDeckController rightViewPushViewControllerOverCenterController:vc];
                        }
                        
                       
                }
        }
        
}

-(NSArray*)matchNameWithArray:(NSArray*)list Name:(NSString*)name{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", name];
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





@end
