//
//  MyAccountViewCell4.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 20/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "MyAccountViewCell4.h"

@implementation MyAccountViewCell4

- (void)awakeFromNib {
    [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        self.viContainerStatus.layer.cornerRadius=10;
        self.viContainerStatus.layer.masksToBounds=YES;
        self.viContainerDelete.layer.cornerRadius=10;
        self.viContainerDelete.layer.masksToBounds=YES;
}
@end
