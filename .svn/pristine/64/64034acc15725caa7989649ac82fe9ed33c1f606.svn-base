//
//  PopFilterViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 11/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopFilter <NSObject>

@optional

-(void)filterOption:(id)object title:(NSString*)title finish:(BOOL)finish;
-(void)cancelOption;

@end

@interface PopFilterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
        
        
}

@property (strong, nonatomic) NSDictionary* data;
@property (strong, nonatomic) NSArray* headerTitle;
@property (strong, nonatomic) NSString* titleString;

@property (strong, nonatomic) id<PopFilter>delegate;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSeparator;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *viContainerSave;
@property (strong, nonatomic) IBOutlet UILabel *lblSave;

@property (strong, nonatomic) IBOutlet ZFRippleButton *btnSave;


@property (strong, nonatomic) IBOutlet UIView *viContainerCancel;
@property (strong, nonatomic) IBOutlet UILabel *lblCancel;

@property (strong, nonatomic) IBOutlet ZFRippleButton *btnCancel;

@end
