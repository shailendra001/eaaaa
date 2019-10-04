//
//  UpdateProfileViewCell2.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "UpdateProfileViewCell2.h"

@implementation UpdateProfileViewCell2

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        
        self.viContainerText.layer.borderWidth=1;
        self.viContainerText.layer.borderColor=[UIColor blackColor].CGColor;
        self.viContainerText.layer.masksToBounds=YES;
}

@end
