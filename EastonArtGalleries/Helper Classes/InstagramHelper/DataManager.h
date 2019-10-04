//
//  DataManager.h
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

@class InstagramUser;
@interface DataManager : NSObject
{
	InstagramUser*	_instagramUser;
}

+ (DataManager*) sharedObject;
- (InstagramUser*) instagramUserAccountObject;

- (void) getUserInstagramWithAccessToken:(NSString*)accessToken fileName:(NSString*)fileName image:(UIImage*)image;

@end

#define _gAppData [DataManager sharedObject]

