//
//  OrderDetailViewCell2.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "OrderDetailViewCell2.h"

@implementation OrderDetailViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)config{
        
        self.viContainerCell.layer.cornerRadius=2.0;
        self.viContainerCell.layer.masksToBounds=YES;
        
}
@end
