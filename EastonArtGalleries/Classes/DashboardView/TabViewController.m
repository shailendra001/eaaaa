//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"
//#import "ChildViewController.h"

@interface TabViewController ()
{
        NSMutableArray* arrWithArtist;
        NSMutableArray* arrWithoutArtist;
        BOOL isLoad;
        
}

@end

@implementation TabViewController

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
            
        [self config];
            
        _style = [TabControllerStyle styleWithName:@"Default"
                                          tabStyle:MSSTabStyleText
                                       sizingStyle:MSSTabSizingStyleSizeToFit
                                      numberOfTabs:[[EAGallery sharedClass] roleType]==BecomeAnArtist ?
                                                        arrWithArtist.count : arrWithoutArtist.count];
            
            
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    if (self.navigationController.viewControllers.firstObject == self) { // only show styles option if initial screen
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Styles"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showStylesScreen:)];
    }
      */
        
}

- (void)viewWillAppear:(BOOL)animated {
        
//        if(!isLoad){
//                isLoad=YES;
        [super viewWillAppear:animated];
//        }

                [self.tabBarView setTransitionStyle:self.style.transitionStyle];
                self.tabBarView.tabStyle = self.style.tabStyle;
                self.tabBarView.sizingStyle = self.style.sizingStyle;

                self.tabBarView.tabAttributes =
                @{
                  NSFontAttributeName                   : [UIFont fontWithName:FONT_MONTSERRAT_SEMIBOLD size:14.0f],
                  NSForegroundColorAttributeName        : [UIColor whiteColor],
                  MSSTabTitleAlpha                      : @(0.8f)
                  };
                self.tabBarView.selectedTabAttributes =
                @{
                  NSFontAttributeName                 : [UIFont fontWithName:FONT_MONTSERRAT_SEMIBOLD size:14.0f],
                  NSForegroundColorAttributeName      : [UIColor whiteColor],
                  NSBackgroundColorAttributeName      : [UIColor colorWithWhite:0.2 alpha:0.2]
                  };

                [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        

//        }
}

#pragma mark - Custom methods

-(void)config{
        
        arrWithArtist=[[NSMutableArray alloc]init];//Artist
        arrWithoutArtist=[[NSMutableArray alloc]init];//Not Artist
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        //Not Artist
        {
                [dic setObject:@"My Account" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"0" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Update Profile" forKey:@"title"];
                [dic setObject:kUpdateProfileViewController forKey:@"vc"];
                [dic setObject:@"1" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Change Your Password" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"2" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Become a seller" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"3" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
                
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"My Order" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"4" forKey:@"sort"];
                [arrWithoutArtist addObject:dic];
        }
        
        //Artist
        {
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"My Account" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"0" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Add Art" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"1" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Manage Art" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"2" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Earning Report" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"3" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Receive Order" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"4" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Wishlist" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"5" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Update Profile" forKey:@"title"];
                [dic setObject:kUpdateProfileViewController forKey:@"vc"];
                [dic setObject:@"6" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"Change Your Password" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"7" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                dic=[NSMutableDictionary dictionary];
                [dic setObject:@"My Order" forKey:@"title"];
                [dic setObject:kMyAccountViewController forKey:@"vc"];
                [dic setObject:@"8" forKey:@"sort"];
                [arrWithArtist addObject:dic];
                
                
        }
        
        
}



#pragma mark - Interaction

- (void)showStylesScreen:(id)sender {
    [self performSegueWithIdentifier:@"showStylesSegue" sender:self];
}

#pragma mark - MSSPageViewControllerDataSource

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    
    NSMutableArray *viewControllers = [NSMutableArray new];
        
        NSArray* arr=[Alert getSortedList:[[EAGallery sharedClass] roleType]==BecomeAnArtist ? arrWithArtist : arrWithoutArtist key:@"sort" ascending:YES];
        
    for (NSInteger i = 0; i < self.style.numberOfTabs; i++) {
        
            NSDictionary* dic=arr[i];
            
            [viewControllers addObject:GET_VIEW_CONTROLLER([dic objectForKey:@"vc"])];

    }
    return viewControllers;
}

#pragma mark - MSSTabBarViewDataSource

- (void)tabBarView:(MSSTabBarView *)tabBarView populateTab:(MSSTabBarCollectionViewCell *)tab atIndex:(NSInteger)index {
    NSString *imageName = [NSString stringWithFormat:@"tab%i.png", (int)(index + 1)];
    //NSString *pageName = [NSString stringWithFormat:@"Page %i", (int)(index + 1)];
        
         NSArray* arr=[Alert getSortedList:[[EAGallery sharedClass] roleType]==BecomeAnArtist ? arrWithArtist : arrWithoutArtist key:@"sort" ascending:YES];
        
        NSDictionary* dic=arr[index];
    
    tab.image = [UIImage imageNamed:imageName];
    tab.title = [dic objectForKey:@"title"];
}

@end
