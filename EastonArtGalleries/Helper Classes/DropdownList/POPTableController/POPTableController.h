//
//  POPTableControllerViewController.h
//  FPPopoverPOP
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class FPViewController;
@protocol buttontitledelgate <NSObject>

-(void)buttonTittle:(NSString*)title selectedIndex:(int)index;

@end
@interface POPTableController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayMonth;
    AppDelegate *appdelegate;
}
@property(nonatomic)id <buttontitledelgate> btndelegate;
@property(nonatomic,assign) FPViewController *delegate;
@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *selectItemValueArray;

@property (nonatomic, strong) IBOutlet UITableView * tableView;

-(void)reloadData;
-(void)loadData:(NSArray *)array;

@end
