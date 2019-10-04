//
//  MyObject.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyObjective-C-Interface.h"

// An Objective-C class that needs to be accessed from C++

@protocol MyObjectDelegate <NSObject>

-(void)getClickedDetail:(NSString*)string;

@end

@interface MyObject : NSObject

@property (nonatomic, strong) id<MyObjectDelegate>delegate;

@property BOOL isArtistListSet;

// The Objective-C member function you want to call from C++

+ (MyObject*)sharedClass;

+(void)hideUnity;

+(void)changeToPortrait;

+(void)changeToLandscapeRight;


+(void)changeToPortraitForDevice;
+(void)changeToLandscapeRightForDevice;

+(void)mute;
+(void)unMute;


+(void)setArtistList:(NSString*)string;
+(void)setArtistName:(NSString*)name;

+(void)navigationButtonTapped;

+(void)reloadGallery;

+(void)resetArtistList;

//+(void)setArtistList:(NSString*)string name:(NSString*)name;

@end
