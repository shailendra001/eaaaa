//
//  ContentAboutViewController.m
//  Hotel Stay
//
//  Created by Ambreesh kumar on 04/02/16.
//  Copyright © 2016 Ambreesh kumar. All rights reserved.
//

#import "ContentAboutViewController.h"

#define COLOR_CELL_TEXT         @"#777575"
#define COLOR_CELL_TITLE        @"#840F16"


@interface ContentAboutViewController ()
{
    
    AppDelegate *appDelegate;
    
}

@end

@implementation ContentAboutViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [self config];

}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        
        self.navigationController.navigationBarHidden=YES;
        
        [self.viewDeckController setLeftLedge:65];
}

-(void)viewDidAppear:(BOOL)animated{
        
        [super viewDidAppear:animated];
        
        [self.viewDeckController closeLeftViewAnimated:NO];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void) config{
    
        _titleLbl.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12.0];
        _descView.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:12.0];
        _titleLbl.text = self.titleString;
        _descView.text = self.descString;
    
//        _descView.font = [UIFont systemFontOfSize:15.0];
        
        self.btnClose.layer.cornerRadius=self.btnClose.frame.size.width/2;
        
        
        //NSString* stringPreFix=@"#";
        
        //Title
        //Theme
//        NSString*titleColorString=[stringPreFix stringByAppendingString:[HotelStay sharedInstance].theme.ThemeColor1];
        _titleLbl.textColor=[Alert colorFromHexString:COLOR_CELL_TITLE];
//
//        //Desc
//        //Theme
//        NSString*descColorString=[stringPreFix stringByAppendingString:[HotelStay sharedInstance].theme.ThemeColor2];
        _descView.textColor=[Alert colorFromHexString:COLOR_CELL_TEXT];
    
}

#pragma mark - Action Methods

- (IBAction)closeReadMoreButtonAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
