//
//  ArtistDetailViewCell4.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/01/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "ArtistDetailViewCell4.h"

#define COLOR_CELL_BORDER       @"#CBCACA"

@implementation ArtistDetailViewCell4

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)config{
        
        self.viContainerImage.layer.cornerRadius=5;
        self.viContainerImage.layer.masksToBounds=YES;
        
        self.viContainerImage.layer.borderWidth=1.0;
        self.viContainerImage.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_BORDER].CGColor;
        
        
}


@end
