//
//  ApplicationAndSubmittingVC.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 20/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationAndSubmittingVC : UIViewController


@property (strong, nonatomic)  NSString *strFrom;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (strong, nonatomic) IBOutlet UIView *viewTableFooter;

@end
