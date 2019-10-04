//
//  WishListViewCell.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 23/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "WishListViewCell.h"

@implementation WishListViewCell

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        
        self.viContainerRemove.layer.cornerRadius=3.0;
        self.viContainerRemove.layer.masksToBounds=YES;
}

@end
