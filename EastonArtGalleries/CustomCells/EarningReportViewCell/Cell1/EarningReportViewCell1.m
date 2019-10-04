//
//  EarningReportViewCell1.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 25/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "EarningReportViewCell1.h"

@implementation EarningReportViewCell1

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
        
        self.viContainerStartDate.layer.cornerRadius=2.0;
        self.viContainerStartDate.layer.masksToBounds=YES;
        
        self.viContainerEndDate.layer.cornerRadius=2.0;
        self.viContainerEndDate.layer.masksToBounds=YES;
        
        self.viContainerButton.layer.cornerRadius=2.0;
        self.viContainerButton.layer.masksToBounds=YES;
}
@end
