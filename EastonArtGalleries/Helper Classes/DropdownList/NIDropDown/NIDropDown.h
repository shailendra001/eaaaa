//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate

-(void) niDropDownDelegateMethod: (NIDropDown *) sender;
-(void)dropdownSelectedIndex:(int)index tableNo:(int)tableno;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
   
    UIImageView *imgView;
     NSString *animationDirection;
    NSString * animationDirection1;
    
        int tableNO;
}
@property (nonatomic, strong) id <NIDropDownDelegate> delegate;
@property (nonatomic, strong) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b tableHeight:(CGFloat *)height tableArray:(NSArray *)arr imageArray:(NSArray *)imgArr tableDir:(NSString *)direction TableNo:(int)tableno;
@end
