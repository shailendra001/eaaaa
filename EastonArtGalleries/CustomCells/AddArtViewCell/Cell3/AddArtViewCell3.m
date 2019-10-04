//
//  AddArtViewCell3.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 18/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "AddArtViewCell3.h"

@implementation AddArtViewCell3

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        self.viContainerChooseFile.layer.cornerRadius=2.0;
        self.viContainerChooseFile.layer.borderWidth=0.5;
        self.viContainerChooseFile.layer.borderColor=[UIColor grayColor].CGColor;
        self.viContainerChooseFile.layer.masksToBounds=YES;
        
        
        self.viContainerAddMore.layer.cornerRadius=2.0;
        self.viContainerAddMore.layer.masksToBounds=YES;
}

@end
