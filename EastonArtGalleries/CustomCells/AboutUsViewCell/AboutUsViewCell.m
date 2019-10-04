//
//  AboutUsViewCell.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 31/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "AboutUsViewCell.h"

@implementation AboutUsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        self.btnFb.layer.cornerRadius=self.btnFb.frame.size.width/2;
        self.btnFb.layer.masksToBounds=YES;
        
        self.btnTw.layer.cornerRadius=self.btnTw.frame.size.width/2;
        self.btnTw.layer.masksToBounds=YES;
        
        self.btnInstagram.layer.cornerRadius=self.btnInstagram.frame.size.width/2;
        self.btnInstagram.layer.masksToBounds=YES;
        
        self.btnPInterest.layer.cornerRadius=self.btnPInterest.frame.size.width/2;
        self.btnPInterest.layer.masksToBounds=YES;
        
        self.btnYoutube.layer.cornerRadius=self.btnYoutube.frame.size.width/2;
        self.btnYoutube.layer.masksToBounds=YES;
        
        self.btnEmail.layer.cornerRadius=self.btnEmail.frame.size.width/2;
        self.btnEmail.layer.masksToBounds=YES;
}

@end