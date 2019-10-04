//
//  BlogViewCell.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 09/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "BlogViewCell.h"

@implementation BlogViewCell

- (void)awakeFromNib {
        [super awakeFromNib];
         [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        self.viContainerDetail.layer.cornerRadius=5;
        self.viContainerDetail.layer.masksToBounds=YES;
}
@end
