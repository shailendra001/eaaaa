//
//  LeftMenuCell1.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 19/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "LeftMenuCell1.h"

@implementation LeftMenuCell1

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
        self.img.layer.borderColor=[UIColor whiteColor].CGColor;//[Alert colorFromHexString:@"#E4E2E2"].CGColor;
        
        self.btnImage.layer.cornerRadius=self.btnImage.frame.size.width/2;
        self.btnImage.layer.masksToBounds=YES;
}
@end
