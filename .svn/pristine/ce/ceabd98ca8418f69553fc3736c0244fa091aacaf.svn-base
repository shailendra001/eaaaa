//
//  ArtDetailCell4.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtDetailCell4.h"
#import "ContainerCellView.h"

@interface ArtDetailCell4 ()
@property (strong, nonatomic) ContainerCellView *collectionView;
@end

@implementation ArtDetailCell4

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _collectionView = [[NSBundle mainBundle] loadNibNamed:@"ContainerCellView" owner:self options:nil][0];
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
