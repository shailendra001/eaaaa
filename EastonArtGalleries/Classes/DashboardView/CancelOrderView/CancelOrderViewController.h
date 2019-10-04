//
//  CancelOrderViewController.h
//  
//
//  Created by Sandeep Kumar on 23/08/16.
//
//

#import <UIKit/UIKit.h>

@interface CancelOrderViewController : UIViewController<THSegmentedPageViewControllerDelegate>

@property(nonatomic,strong)NSString *viewTitle;

@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
