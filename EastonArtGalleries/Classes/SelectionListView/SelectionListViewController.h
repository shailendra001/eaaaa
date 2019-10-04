//
//  SelectionListViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 19/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionListDelegate <NSObject>

@optional
-(void)selectionListValue:(NSString*)name tag:(long)tag;

@end

@interface SelectionListViewController : UIViewController


@property (nonatomic) long tag;
@property (strong, nonatomic) NSMutableArray* arrList;
@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) NSString* artID;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id<SelectionListDelegate>delegate;

@end
