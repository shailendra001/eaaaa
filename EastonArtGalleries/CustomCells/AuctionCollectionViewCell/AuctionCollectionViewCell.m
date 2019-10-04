//
//  AuctionCollectionViewCell.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 17/06/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "AuctionCollectionViewCell.h"
#define COLOR_CELL_BORDER       @"#CBCACA"

@implementation AuctionCollectionViewCell

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
