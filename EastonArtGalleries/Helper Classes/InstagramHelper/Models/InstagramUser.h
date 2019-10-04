//
//  InstagramUser.h
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUser : NSObject
{
    
}

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* profilePicture;
@property (nonatomic, strong) NSString* fullName;
@property (nonatomic, strong) NSString* bio;
@property (nonatomic, strong) NSString* accessToken;

@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int followedBy;


@property (nonatomic, strong) UIImage* shareImage;
@property (nonatomic, strong) NSString* fileName;

- (id) initWithDictionary:(NSDictionary*)dict;

@end
