//
//  ArtCollectionViewCell.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 25/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtCollectionViewCell.h"
#define COLOR_CELL_BORDER       @"#CBCACA"

@implementation ArtCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        [self config];
}

-(void)config{
        
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        
        self.layer.borderWidth=1.0;
        self.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_BORDER].CGColor;
        
        
}

@end
