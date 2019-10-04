//
//  UpdateProfileViewCell5.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/01/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "UpdateProfileViewCell5.h"

#define COLOR_CELL_BORDER       @"#CBCACA"

@implementation UpdateProfileViewCell5

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)config{
        
        self.viContainerRemove.layer.cornerRadius=self.viContainerRemove.bounds.size.width/2;
        self.viContainerRemove.layer.masksToBounds=YES;
        
        self.viContainerVideoPart.layer.cornerRadius=5;
        self.viContainerVideoPart.layer.masksToBounds=YES;
        
        self.viContainerVideoPart.layer.borderWidth=1.0;
        self.viContainerVideoPart.layer.borderColor=[Alert colorFromHexString:COLOR_CELL_BORDER].CGColor;
        
//        self.txtField.layer.borderWidth=1;
//        self.txtField.layer.borderColor=[UIColor blackColor].CGColor;
//        self.txtField.layer.masksToBounds=YES;
}
@end
