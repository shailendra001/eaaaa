//
//  POPTableControllerViewController.m
//  FPPopoverPOP
//

#import "POPTableController.h"
#import "AppDelegate.h"
@interface POPTableController ()

@end

@implementation POPTableController
@synthesize delegate=_delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
    
//    arrayMonth=[self.selectedArray copy];
  
    
        self.tableView.tableFooterView=[[UIView alloc]init];
    
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    
        
        self.view.backgroundColor=[UIColor clearColor];
        self.tableView.backgroundColor=[UIColor clearColor];
    
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (id view in cell.contentView.subviews) {
                
                if([view isKindOfClass:[UILabel class]])
                        [view removeFromSuperview];
        }
    
        if(cell == nil)
        {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [self.selectedArray objectAtIndex:indexPath.row];
        cell.backgroundColor=
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor blackColor];
        
        cell.textLabel.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:13];
        
//        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(
//                                                                15,
//                                                                cell.frame.size.height-1,
//                                                                cell.frame.size.width,
//                                                                1)];
//        label.backgroundColor=[UIColor blackColor];
        //[cell.contentView addSubview:label];
    
    //cell.textLabel.text=[arrayMonth objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return 30.0f;
        
}
#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString* text=[self.selectedArray objectAtIndex:indexPath.row];
    
    [self.btndelegate buttonTittle:text selectedIndex:(int)indexPath.row];
}


-(void)loadData:(NSArray *)array
{
    self.selectedArray = [array mutableCopy];
    
    [self.tableView reloadData];
}

@end
