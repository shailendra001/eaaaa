//
//  ArtistDetailCell3.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtistDetailCell3.h"
#import "ArtWorksContainerCellView.h"

@interface ArtistDetailCell3 ()
@property (strong, nonatomic) ArtWorksContainerCellView *collectionView;
@property (strong, nonatomic) NSDictionary *info;
@end

@implementation ArtistDetailCell3

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _collectionView = [[NSBundle mainBundle] loadNibNamed:@"ArtWorksContainerCellView" owner:self options:nil][0];
        _collectionView.frame = self.bounds;
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCollectionInfo:(NSDictionary *)info{
        [_collectionView setCollectionInfo:info];
}

- (void)setCollectionData:(NSArray *)collectionData {
    [_collectionView setCollectionData:collectionData];
}



@end
