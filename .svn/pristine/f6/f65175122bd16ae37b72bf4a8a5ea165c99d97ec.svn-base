//
//  ContainerCellView.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//


#import "ContainerCellView.h"
#import "CollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define COLOR_CELL_BACKGROUND   @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"


@interface ContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;
@property (strong, nonatomic) NSDictionary *info;
@end

@implementation ContainerCellView

static NSString *CellIdentifier = @"CollectionViewCell";

- (void)awakeFromNib {

        
    self.collectionView.backgroundColor = [Alert colorFromHexString:COLOR_CELL_BACKGROUND];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(70.0, 70.0);
    [self.collectionView setCollectionViewLayout:flowLayout];

    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];

}

-(void)update{
        
        if(_info &&  [[_info objectForKey:@"edit"] boolValue]==YES){
                self.collectionView.backgroundColor=[UIColor clearColor];
                
        }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark - Getter/Setter overrides
- (void)setCollectionInfo:(NSDictionary *)info {
        _info = info;
        [self update];
}


#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        for (id view in cell.imgPhoto.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
        
        NSString *cellData = [self.collectionData objectAtIndex:[indexPath row]];
        NSURL* url;
        
        NSString* fileName=[cellData lastPathComponent];
//        NSArray*arr=[fileName componentsSeparatedByString:@"."];
        if(_info && [[_info objectForKey:@"type"]isEqualToString:@"2"]){
                
                //video
                
                if(_info &&  [[_info objectForKey:@"edit"] boolValue]==YES){
                        
                        cell.viContainerRemove.hidden=NO;
                        cell.viContainerRemove.backgroundColor=[UIColor clearColor];
                        
                }
                else{
                        cell.viContainerRemove.hidden=YES;
                        
                }
                        
                        
//                NSArray*arr=[fileName componentsSeparatedByString:@"="];
//                NSString*thumbnail=arr.count==2 ? arr[1] : @"";
                url=[NSURL URLWithString:[Alert getYoutubeVideoThumbnail:fileName]];
                cell.imgVideo.hidden=NO;
        }
        else{
                //Image
                NSString *encodedString;
                if(_info &&  [[_info objectForKey:@"edit"] boolValue]==YES){
                        NSString* url=[_info objectForKey:@"base_url"];
                        NSString* file=cellData;
                        NSString* fullPath=[url stringByAppendingPathComponent:file];
                        encodedString = [fullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        cell.viContainerRemove.hidden=NO;
                        cell.viContainerRemove.backgroundColor=[UIColor clearColor];
                }
                else{
                
                        encodedString = [cellData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        cell.viContainerRemove.hidden=YES;
                }
                
                url=[NSURL URLWithString:encodedString];
                cell.imgVideo.hidden=YES;
                
                
                
        }
        
        if(_info &&  [[_info objectForKey:@"edit"] boolValue]==YES){
                cell.viContainerCell.backgroundColor=[UIColor clearColor];
                cell.btnRemove.tag=indexPath.item;
                [cell.btnRemove addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
                
        }
        
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityIndicator.frame = CGRectMake(cell.imgPhoto.frame.size.width/2-15,
//                                             cell.imgPhoto.frame.size.height/2-15,
//                                             30,
//                                             30);
        activityIndicator.center=cell.imgPhoto.center;
        [activityIndicator startAnimating];
        activityIndicator.tag=indexPath.row;
        
//        [activityIndicator removeFromSuperview];
        [cell.imgPhoto addSubview:activityIndicator];
//        [cell.viContainerCell insertSubview:activityIndicator aboveSubview:cell.imgPhoto];
        
        cell.imgPhoto.contentMode=UIViewContentModeScaleAspectFit;
        cell.imgPhoto.backgroundColor=[UIColor whiteColor];
        
        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
        
        __weak UIImageView *weakImgPic = cell.imgPhoto;
        [cell.imgPhoto setImageWithURL:url
                    placeholderImage:imgPlaceHolder
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 [activityIndicator stopAnimating];
                 [activityIndicator removeFromSuperview];
                 
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
                 strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                 
                 if(_info &&  [[_info objectForKey:@"edit"] boolValue]==YES){
                         strongImgPic.backgroundColor=[UIColor clearColor];
                         
                 }
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                          strongImgPic.image=image;
                                         
                                 }
                                 completion:^(BOOL finish){
                                 }];
                 
                 
         } failure:NULL];
        
        cell.btnOpenMedia.hidden=YES;

        
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
        return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 5.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsetsMake(0,10,0,0);  // top, left, bottom, right
}

-(IBAction)remove:(id)sender{

        UIButton*button=(UIButton*)sender;
        NSIndexPath *indexPath =[Alert getIndexPathWithButton:button collection:self.collectionView];
        
        NSString *cellData = [self.collectionData objectAtIndex:[indexPath row]];
        
        NSMutableDictionary* dic=[_info mutableCopy];
        [dic setObject:cellData forKey:@"cell"];
        [dic setObject:indexPath forKey:@"indexpath"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemRemoveFromCollectionView" object:dic];

        
        
}

@end
