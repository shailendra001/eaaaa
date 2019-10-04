//
//  ArtWorksContainerCellView.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//


#import "ArtWorksContainerCellView.h"
#import "CollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ArtCollectionViewCell.h"
#define COLOR_BACKGROUND        @"#DEDEDD"
#define COLOR_CELL_BACKGROUND   @"#D4D4D4"
#define COLOR_CELL_TEXT         @"#575656"
#define COLOR_CELL_BORDER       @"#CBCACA"

#define CELL_WIDTH      152
#define CELL_HEIGHT     215



@interface ArtWorksContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;
@property (strong, nonatomic) NSDictionary *info;
@end

@implementation ArtWorksContainerCellView

static NSString *CellIdentifier = @"artCell";

- (void)awakeFromNib {
        [super awakeFromNib];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [Alert colorFromHexString:COLOR_BACKGROUND];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    [self.collectionView setCollectionViewLayout:flowLayout];

    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"ArtCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];

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
        //NSString *cellData = [self.collectionData objectAtIndex:[indexPath row]];
        
        ArtCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        for (id view in cell.viContainerImage.subviews) {
                
                if([view isKindOfClass:[UIActivityIndicatorView class]])
                        [view removeFromSuperview];
        }
        
        //        MediaGallery* data=[self._arrArtCollectionList objectAtIndex:indexPath.item];
        
        NSDictionary* data=[self.collectionData objectAtIndex:[indexPath row]];
        
        cell.lblName.text=[data objectForKey:@"art_name"];
        NSString* category=[data objectForKey:@"category_name"];;
        NSString* autherName=[data objectForKey:@"name"];
        
        
        
        UIColor* color1=[Alert colorFromHexString:@"#585858"];
        UIColor* color2=[Alert colorFromHexString:@"#971700"];
        
        cell.lblAutherName.text=[NSString stringWithFormat:@"%@ by %@",category,autherName];
        NSInteger l1=category.length;
        NSInteger l2=autherName.length;
        //        NSInteger l3=cell.lblAutherName.text.length;
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.lblAutherName.text];
        [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0,l1+4)];
        [string addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(l1+4,l2)];
        
        cell.lblAutherName.attributedText = string;
        
        cell.lblSize.text=[data objectForKey:@"art_size"];
        
        cell.lblPrice.text=[NSString stringWithFormat:@"$%@",[data objectForKey:@"art_price"]];
        
        NSString* path=_info ? [[_info objectForKey:@"base_url"] stringByAppendingString:[data objectForKey:@"art_image"]] : [data objectForKey:@"art_image"];
        
        NSURL* url=[NSURL URLWithString:path];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(cell.imgView.frame.size.width/2-15,
                                             cell.imgView.frame.size.height/2-15,
                                             30,
                                             30);
        [activityIndicator startAnimating];
        activityIndicator.tag=indexPath.row;
        
        [activityIndicator removeFromSuperview];
        [cell.viContainerImage addSubview:activityIndicator];
        [cell.viContainerImage insertSubview:activityIndicator aboveSubview:cell.imgView];
        
        cell.imgView.contentMode=UIViewContentModeScaleToFill;
        cell.imgView.backgroundColor=[UIColor whiteColor];
        
        UIImage* imgPlaceHolder=[UIImage imageNamed:@"no_image.png"];
        
        __weak UIImageView *weakImgPic = cell.imgView;
        [cell.imgView setImageWithURL:url
                     placeholderImage:imgPlaceHolder
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 //                 dispatch_async(dispatch_get_main_queue(), ^{
                 [activityIndicator stopAnimating];
                 [activityIndicator removeFromSuperview];
                 
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
                 strongImgPic.backgroundColor=image ? [Alert colorFromHexString:@"#D4D4D4"] :[UIColor whiteColor];
                 
                 UIImage* temp=[Alert imageWithImage:image
                                    scaledToMaxWidth:152
                                           maxHeight:149];
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                         strongImgPic.contentMode=UIViewContentModeTop;
                                         strongImgPic.image=temp;
                                         
                                 }
                                 completion:^(BOOL finish){
                                         
                                 }];
                 
                 
         } failure:NULL];
        

       
        
        BOOL isSold= [data objectForKey:@"quantity"]!=nil && [[data objectForKey:@"quantity"] intValue]==0 ? YES : NO;
        cell.imgSold.hidden=!isSold;
        cell.backgroundColor=[UIColor clearColor];
        cell.viContainerImage.backgroundColor=[UIColor clearColor];
        
        
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromArtWorksContainerCellView" object:cellData];
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
         return UIEdgeInsetsMake(0,5,0,5);  // top, left, bottom, right
}

@end
