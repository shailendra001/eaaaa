//
//  ArtDetailViewCell2.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 27/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "ArtDetailViewCell2.h"

@implementation ArtDetailViewCell2

- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        self.btnFB.layer.cornerRadius=self.btnFB.frame.size.width/2;
        self.btnFB.layer.masksToBounds=YES;
        
        self.btnTW.layer.cornerRadius=self.btnTW.frame.size.width/2;
        self.btnTW.layer.masksToBounds=YES;
        
        self.btnGooglePlus.layer.cornerRadius=self.btnGooglePlus.frame.size.width/2;
        self.btnGooglePlus.layer.masksToBounds=YES;
        
        self.btnInstagram.layer.cornerRadius=self.btnInstagram.frame.size.width/2;
        self.btnInstagram.layer.masksToBounds=YES;
        
        self.btnEmail.layer.cornerRadius=self.btnEmail.frame.size.width/2;
        self.btnEmail.layer.masksToBounds=YES;
        
        
}

@end
