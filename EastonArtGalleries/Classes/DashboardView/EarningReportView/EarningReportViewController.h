//
//  EarningReportViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 25/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarningReportViewController : UIViewController<THSegmentedPageViewControllerDelegate>

@property(nonatomic,strong)NSString *viewTitle;

@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
