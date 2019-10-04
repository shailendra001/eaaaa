//
//  BestSellingArtistsViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 26/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestSellingArtistsViewController : UIViewController
{
        NSArray* arrBestSellingArtistsList;
}
@property (strong, nonatomic) NSString* baseURL;

@property (assign, nonatomic) BOOL isSearchArtist;
@property (strong, nonatomic) NSArray* arrBestSellingArtistsList;
@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* urlString;
@property (strong, nonatomic) NSDictionary* urlData;
@property (strong, nonatomic) NSString* dataAccesskey;

@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *viContainerFilter;
@property (strong, nonatomic) IBOutlet UIView *viContainerSort;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorVirtical;
@end