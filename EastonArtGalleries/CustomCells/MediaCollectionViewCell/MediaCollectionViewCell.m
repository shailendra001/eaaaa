//
//  MediaCollectionViewCell.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 29/07/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "MediaCollectionViewCell.h"

@implementation MediaCollectionViewCell

- (void)awakeFromNib {
        
        [super awakeFromNib];
        
        self.imageUser.layer.cornerRadius  = 30.0;
        self.imageUser.layer.borderWidth = 2.0f;
        self.imageUser.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageUser.layer.masksToBounds = YES;
        
//        _viewBG.layer.cornerRadius = 5.0f;
//        _viewBG.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
//        _viewBG.layer.masksToBounds = YES;
}

@end
