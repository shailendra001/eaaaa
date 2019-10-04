//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class FPViewController;
@protocol buttontitledelgate <NSObject>

-(void)buttonTittle:(NSString*)title selectedIndex:(int)index;

@end
@interface DemoTableController : UITableViewController{
    NSMutableArray *arrayMonth;
    AppDelegate *appdelegate;
}
@property(nonatomic)id <buttontitledelgate> btndelegate;
@property(nonatomic,assign) FPViewController *delegate;
@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *selectItemValueArray;

//-(void)reloadData;


@end