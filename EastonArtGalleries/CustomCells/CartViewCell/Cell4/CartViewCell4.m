//
//  CartViewCell4.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 01/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "CartViewCell4.h"

@implementation CartViewCell4

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        
        self.btnEdit.layer.cornerRadius=2.0;
}

@end