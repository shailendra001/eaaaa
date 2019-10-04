//
//  UpdateProfileViewCell3.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 15/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "UpdateProfileViewCell3.h"

@implementation UpdateProfileViewCell3


- (void)awakeFromNib {
        [super awakeFromNib];
        [self config];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)config{
        if(!self.isRectangular){
                self.btnSelect.layer.cornerRadius=self.btnSelect.frame.size.width/2;
                self.btnSelect.layer.masksToBounds=YES;
                
                self.img.layer.cornerRadius=self.img.frame.size.width/2;
                self.img.layer.masksToBounds=YES;
        }
        else{
                self.btnSelect.layer.cornerRadius=2.0;
                self.btnSelect.layer.masksToBounds=YES;
                
                self.img.layer.cornerRadius=2.0;
                self.img.layer.masksToBounds=YES;
        }
        
        
}

-(void)setIsRectangular:(BOOL)isRectangular{
        
        _isRectangular=isRectangular;
        
        [self config];
}

@end
