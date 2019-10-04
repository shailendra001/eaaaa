//
//  ViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 11/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController


@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) IBOutlet UIView *viContainerImageSlider;
@property (strong, nonatomic) IBOutlet UILabel *lblSeperatorLine;
@property (strong, nonatomic) IBOutlet UIImageView *imgViSliderImage;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *viContainerBottom;
@property (strong, nonatomic) IBOutlet UIImageView *imgSubscribe;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnSubscribe;
@property (strong, nonatomic) IBOutlet UITableView *customTableView;

- (IBAction)subcribe:(id)sender;
@end

