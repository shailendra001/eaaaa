//
//  MyAccountViewCell1.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "MyAccountViewCell1.h"

@implementation MyAccountViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        self.img.layer.cornerRadius=self.img.frame.size.width/2;
        self.img.layer.masksToBounds=YES;
        self.img.layer.borderWidth=2;
        self.img.layer.borderColor=[Alert colorFromHexString:@"#E4E2E2"].CGColor;
        
//        [Alert setShadowOnView:self.viContainerAddMoney];
        
        self.viContainerAddMoney.layer.cornerRadius=2;
        self.viContainerAddMoney.layer.masksToBounds=YES;
}

@end
