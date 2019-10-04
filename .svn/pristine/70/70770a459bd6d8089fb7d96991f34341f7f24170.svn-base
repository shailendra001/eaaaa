//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "DemoTableController.h"
#import "AppDelegate.h"
@interface DemoTableController ()

@end

@implementation DemoTableController
@synthesize delegate=_delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
    
    arrayMonth=[self.selectedArray copy];
        
        self.tableView.tableFooterView=[[UIView alloc]init];
    
    //self.title = @"Select Month";
    
}



//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.selectedArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:13];
    
    //cell.textLabel.text=[arrayMonth objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return 30.0f;
        
}
#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //appdelegate.buttonTitle=[arrayMonth objectAtIndex:indexPath.row];
  //  NSLog(@"hjafgahsdg:%@",appdelegate.buttonTitle);
    NSString* text=[self.selectedArray objectAtIndex:indexPath.row];
    
    [self.btndelegate buttonTittle:text selectedIndex:(int)indexPath.row];
    

    
//    if([self.delegate respondsToSelector:@selector(selectedTableRow:)])
//    {
//        [self.delegate selectedTableRow:indexPath.row];
//    }
}




@end
