//
//  PopFilterViewController.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 11/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "PopFilterViewController.h"
#import "PopFilterViewCell.h"


#define CATEGORY                @"category"
#define CATEGORY_STYLE_NAME     @"stylename"
#define CATEGORY_COLOR_NAME     @"colorname"
#define CATEGORY_PRICE          @"price"
#define CATEGORY_SORT           @"sort"



@interface PopFilterViewController ()
{
        
        NSMutableArray* arrCategory;
        NSMutableArray* arrStyle;
        NSMutableArray* arrColor;
        
        NSMutableArray* arrSortOrder;
        
        NSString* price;
        NSString* sort;
        
}

@end

@implementation PopFilterViewController

static NSString *CellIdentifier1 = @"Cell1";

#pragma mark - View life cycle

- (void)viewDidLoad {
    
        [super viewDidLoad];
        
        [self cellRegister];
    
        [self config];
        
        [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

-(void)config{
        
        self.lblTitle.text=self.titleString;
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
        self.tableView.tableFooterView=[[UIView alloc]init];
        //        self.tableView.backgroundColor=[Alert colorFromHexString:COLOR_CELL_BACKGROUND];
        
        [self.tableView reloadData];
        
        [self.btnSave addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        self.viContainerSave.layer.cornerRadius=2.0;
        self.viContainerCancel.layer.cornerRadius=2.0;
        
        self.viContainerSave.layer.masksToBounds=YES;
        self.viContainerCancel.layer.masksToBounds=YES;
        
        

}

-(void)cellRegister{
        
        [self.tableView registerClass:[PopFilterViewCell class] forCellReuseIdentifier:CellIdentifier1];
        
        
        UINib *contantsCellNib1 = [UINib nibWithNibName:@"PopFilterViewCell" bundle:nil];
        [self.tableView registerNib:contantsCellNib1 forCellReuseIdentifier:CellIdentifier1];
        
}

-(void)loadData{
        
        
        NSMutableDictionary* dic=[Alert getFromLocal:@"filter"];
        
        
        arrCategory=dic ? [[dic objectForKey:@"category"] mutableCopy] : nil;
        arrStyle=dic ? [[dic objectForKey:@"style"] mutableCopy] : nil;
        arrColor=dic ? [[dic objectForKey:@"color"] mutableCopy] : nil;
        price=dic ? [[dic objectForKey:@"price"] objectAtIndex:0] : nil;
        sort=dic ? [dic objectForKey:@"sort"] : nil;
        
        if(!arrSortOrder) arrSortOrder=[[NSMutableArray alloc]init];
        
        if(self.data.allKeys.count==1)
                [arrSortOrder addObject:CATEGORY_SORT];
        else if(self.data.allKeys.count==4)
        {
                
                [arrSortOrder addObject:CATEGORY];
                [arrSortOrder addObject:CATEGORY_STYLE_NAME];
                [arrSortOrder addObject:CATEGORY_PRICE];
                [arrSortOrder addObject:CATEGORY_COLOR_NAME];
                
        }
        
        
        
        [self.tableView reloadData];
}

#pragma mark -Delegate 

-(void)filterOption:(id)object{
        
        
        
}
-(void)cancelOption{
        
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return arrSortOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
        NSArray* arr=[self.data objectForKey:[arrSortOrder objectAtIndex:section]];
        
        return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        NSInteger height=30.0f;
        
       
        return height;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        PopFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
        
        NSString* title=[arrSortOrder objectAtIndex:indexPath.section];
        
        NSMutableDictionary* dic=[[self.data objectForKey:title] objectAtIndex:indexPath.row];
        
        
        NSString* icon;
        
        if([title isEqualToString:CATEGORY]){
                
                icon=[arrCategory containsObject:[dic objectForKey:@"id"]] ? SELECT_TICK : UNSELECT_TICK;
                
        }
        else if([title isEqualToString:CATEGORY_STYLE_NAME]){
                
                icon=[arrStyle containsObject:[dic objectForKey:@"id"]] ? SELECT_TICK : UNSELECT_TICK;
                
        }
        else if([title isEqualToString:CATEGORY_COLOR_NAME]){
                
                icon=[arrColor containsObject:[dic objectForKey:@"id"]] ? SELECT_TICK : UNSELECT_TICK;
                
        }
        else if([title isEqualToString:CATEGORY_PRICE]){
                
                if(!price && indexPath.row==0)
                        icon=SELECT_RADIO;
                else
                        icon=[price isEqualToString:[dic objectForKey:@"id"]] ? SELECT_RADIO : UNSELECT_RADIO;
                
        }
        else if([title isEqualToString:CATEGORY_SORT]){
                
                if(!sort && indexPath.row==1)
                        icon=SELECT_RADIO;
                else
                        icon=[sort isEqualToString:[dic objectForKey:@"id"]] ? SELECT_RADIO : UNSELECT_RADIO;
                
        }
        cell.img.image=[UIImage imageNamed:icon];
        
        
        
        NSString* name;
        
        if([title isEqualToString:CATEGORY])                    name=@"category_name";
        else if([title isEqualToString:CATEGORY_STYLE_NAME])    name=@"style_name";
        else if([title isEqualToString:CATEGORY_COLOR_NAME])    name=@"color_name";
        else                                                    name=@"value";
        
        cell.lblName.text=[dic objectForKey:name];
        
        
        
        
        return cell;
       
        
       
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
         NSDictionary* dic=[[self.data objectForKey:[arrSortOrder objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
         NSString* title=[arrSortOrder objectAtIndex:indexPath.section];
        
        if([title isEqualToString:CATEGORY]){
                if(!arrCategory) arrCategory=[[NSMutableArray alloc]init];
                
                if([arrCategory containsObject:[dic objectForKey:@"id"]])
                        [arrCategory removeObject:[dic objectForKey:@"id"]];
                else
                        [arrCategory addObject:[dic objectForKey:@"id"]];
                
                [self.delegate filterOption:arrCategory title:title finish:NO];
        }
        else if([title isEqualToString:CATEGORY_STYLE_NAME]){
                if(!arrStyle) arrStyle=[[NSMutableArray alloc]init];
                
                if([arrStyle containsObject:[dic objectForKey:@"id"]])
                        [arrStyle removeObject:[dic objectForKey:@"id"]];
                else
                        [arrStyle addObject:[dic objectForKey:@"id"]];
                
                [self.delegate filterOption:arrStyle title:title finish:NO];
        }        
        else if([title isEqualToString:CATEGORY_COLOR_NAME]){
                if(!arrColor) arrColor=[[NSMutableArray alloc]init];
                
                if([arrColor containsObject:[dic objectForKey:@"id"]])
                        [arrColor removeObject:[dic objectForKey:@"id"]];
                else
                        [arrColor addObject:[dic objectForKey:@"id"]];
                
                [self.delegate filterOption:arrColor title:title finish:NO];
        }
        else if([title isEqualToString:CATEGORY_PRICE]){
                price=[dic objectForKey:@"id"];
                
                [self.delegate filterOption:dic title:title finish:NO];
        }
        else if([title isEqualToString:CATEGORY_SORT]){
                sort=[dic objectForKey:@"id"];
                
                [self.delegate filterOption:dic title:title finish:NO];
        }

        [self.tableView reloadData];
        
        
        
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        //        NSDictionary *sectionData = [arrHeaderTitle objectAtIndex:section];
        
        NSString* header=[arrSortOrder objectAtIndex:section];
        

        if([header isEqualToString:CATEGORY])
                header=@"Categories";
        if([header isEqualToString:CATEGORY_STYLE_NAME])
                header=@"Subject";
        if([header isEqualToString:CATEGORY_COLOR_NAME])
                header=@"Color";
        if([header isEqualToString:CATEGORY_PRICE])
                header=@"Price";
        
        
        
        
        return [header capitalizedString];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        //Header View
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor=[UIColor blackColor];
        //        headerView.backgroundColor=[UIColor clearColor];
        
        //Header Title
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(8, 5, tableView.frame.size.width-16, 20);
        myLabel.font=[UIFont fontWithName:FONT_DOSIS_REGULAR size:15];
        myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        myLabel.textAlignment=NSTextAlignmentLeft;
        myLabel.textColor=[UIColor whiteColor];
        myLabel.backgroundColor=[UIColor clearColor];
        [headerView addSubview:myLabel];
        
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        NSInteger height=0;
        if(![[arrSortOrder objectAtIndex:section] isEqualToString:CATEGORY_SORT])
                height=30.0f;
                
        
        return height;
}


#pragma mark - Target Methods

-(IBAction)save:(id)sender{
        
        [self.delegate filterOption:nil title:nil finish:YES];
        
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(id)sender{
        
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.delegate cancelOption];
        
}
@end
