//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import <QuartzCore/QuartzCore.h>
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) NSArray *imageList;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

- (id)showDropDown:(UIButton *)b tableHeight:(CGFloat *)height tableArray:(NSArray *)arr imageArray:(NSArray *)imgArr tableDir:(NSString *)direction TableNo:(int)tableno
{
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor blackColor];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
        }
        else
        {
            [table setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
        tableNO = tableno;
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        
        
    }

    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    //cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    /*
    if (indexPath.row ==0)
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
    if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"s1.png"];
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"b1.png"];
    }
     */
    
//    UIView * v = [[UIView alloc] init];
//    v.backgroundColor = [UIColor grayColor];
//    cell.selectedBackgroundView = v;
    cell.textLabel.textColor = [UIColor blackColor];
    
   // cell.textLabel.textColor =[UIColor colorWithRed:9/255.0 green:10/255.0 blue:37/255.0 alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate dropdownSelectedIndex:(int)indexPath.row tableNo:tableNO];
    [self hideDropDown:btnSender];
    
//    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
//    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
//    
////    for (UIView *subview in btnSender.subviews) {
////        if ([subview isKindOfClass:[UIImageView class]]) {
////            [subview removeFromSuperview];
////        }
////    }
////    imgView.image = c.imageView.image;
////    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
////    imgView.frame = CGRectMake(5, 5, 25, 25);
////    [btnSender addSubview:imgView];
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}


@end
