//
//  ClusterAnnotationView.m
//  CCHMapClusterController Example iOS
//
//  Created by Hoefele, Claus(choefele) on 09.01.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

// Based on https://github.com/thoughtbot/TBAnnotationClustering/blob/master/TBAnnotationClustering/TBClusterAnnotationView.m by Theodore Calmes

#import "ClusterAnnotationView.h"

@interface ClusterAnnotationView ()

@property (nonatomic) UILabel *countLabel;

@end

@implementation ClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpLabel];
        [self setCount:1];
    }
    return self;
}

- (void)setUpLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.minimumScaleFactor = 2;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    self.countLabel.text = [@(count) stringValue];
        
        
    [self setNeedsLayout];
}


-(void)setImageName:(NSString *)imageName{
        
        _imageName=imageName;
        
        [self setNeedsLayout];
}


- (void)setBlue:(BOOL)blue
{
    _blue = blue;
    [self setNeedsLayout];
}



- (void)setUniqueLocation:(BOOL)uniqueLocation
{
    _uniqueLocation = uniqueLocation;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    // Images are faster than using drawRect:
    UIImage *image;
    CGPoint centerOffset;
    CGRect countLabelFrame;
    if (self.isUniqueLocation) {
            
        NSString *imageName = self.isBlue ? @"SquareBlue" : _imageName;
        image = [UIImage imageNamed:imageName];
        
        CGRect frame = self.bounds;
        frame.origin.y -= 2;
        countLabelFrame = frame;
            CGRect imgFrame;
            
            if([self.imageName isEqualToString:[HotelStay sharedInstance].icon.PinHotel])
                    imgFrame=CGRectMake(0, 0, 34, 40);
            else if([self.imageName isEqualToString:[HotelStay sharedInstance].icon.Pin_Selected])
                    imgFrame=CGRectMake(0, 0, 37, 60);
            else if([self.imageName isEqualToString:[HotelStay sharedInstance].icon.PinBookmark_Selected])
                    imgFrame=CGRectMake(0, 0, 37, 60);
            else
                    imgFrame=CGRectMake(0, 0, 31, 50);
                    
            
            image=[self imageResize:imgFrame image:image];
            
            centerOffset = CGPointMake(0, -imgFrame.size.height/2 );
            self.countLabel.hidden=YES;
    }
    else {
        self.countLabel.hidden=NO;
            
        NSString *imageName = self.isBlue ? @"CircleBlue" : _imageName;
        image = [UIImage imageNamed:imageName];
        image=[self imageResize:CGRectMake(0, 0, 50, 50) image:image];

        centerOffset = CGPointMake(0, -image.size.height/2 );;
        countLabelFrame = self.bounds;
    }
    
    self.countLabel.frame = countLabelFrame;
    self.image = image;
    self.centerOffset = centerOffset;
}

-(UIImage*)imageResize:(CGRect)size image:(UIImage*)image{
        
        CGRect rect = size;
        UIGraphicsBeginImageContext( rect.size );
        [image drawInRect:rect];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(picture1);
        UIImage *img=[UIImage imageWithData:imageData];
        return img;
}


@end
