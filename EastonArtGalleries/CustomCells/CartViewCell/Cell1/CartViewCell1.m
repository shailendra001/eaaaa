//
//  CartViewCell1.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 29/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "CartViewCell1.h"

@implementation CartViewCell1

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        
        self.viContainerQuantity.layer.borderWidth=1.0;
        self.viContainerQuantity.layer.borderColor=[UIColor blackColor].CGColor;
        self.viContainerQuantity.backgroundColor=[UIColor whiteColor];
        self.viContainerQuantity.layer.masksToBounds=YES;
        
        self.viContainerRemove.layer.cornerRadius=3.0;
        self.viContainerRemove.layer.masksToBounds=YES;
}

@end
