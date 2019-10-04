//
//  CustomDatePickerViewController.h
//  Talk2Good
//
//  Created by Sandeep Kumar on 08/09/15.
//  Copyright (c) 2015 InfoiconTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

@optional
//For Date Picker
-(void)selectDateFromDatePicker:(NSDate*)date sender:(id)sender;
-(void)cancelDateFromDatePicker:(id)sender;

//For custom List
-(void)selectItemFromList:(NSString*)item sender:(id)sender;
-(void)cancelItemFromCustomList:(id)sender;

@end


@interface CustomDatePickerViewController : UIViewController
{
    UIView *pickerView;
    BOOL isCustomList;
        BOOL isCurrentDate;
    UIDatePickerMode datePickerMode;
        BOOL isDate;
}
@property BOOL isCustomList;
@property BOOL isCurrentDate;
@property BOOL isDate;
@property (strong, nonatomic) NSDate* setDate;


@property (nonatomic) UIDatePickerMode datePickerMode;
@property (strong, nonatomic) id<PickerViewDelegate>delegate;

@property (strong, nonatomic) id sender;
@property (strong, nonatomic) NSArray* arrItems;

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *viContainerButtons;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

-(void)setPickerList;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
