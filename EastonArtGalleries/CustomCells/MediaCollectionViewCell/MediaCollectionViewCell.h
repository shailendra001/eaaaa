//
//  MediaCollectionViewCell.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 29/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property (strong, nonatomic) IBOutlet UIImageView *imageThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlayVideo;
@property (strong, nonatomic) IBOutlet UIImageView *imageUser;


@end
