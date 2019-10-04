//
//  DataManager.m
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

#import "DataManager.h"

static DataManager* gDataMgr = nil;

@implementation DataManager

+ (DataManager*) sharedObject
{
	if (!gDataMgr)
	{
		gDataMgr = [[DataManager alloc] init];
	}
	return gDataMgr;
}

- (id) init
{
    self = [super init];
    {

    }
    return self;
}

- (void) dealloc
{
//	[super dealloc];
}

// creates a singleton object of InstagramUser Account
- (InstagramUser*) instagramUserAccountObject
{
    if (_instagramUser == nil)
		_instagramUser = [[InstagramUser alloc] init];
	return _instagramUser;
}


#pragma mark -- method to get the current Instagram user and its profile status

// call the Instagram api to fetch the info of the Instagram user that is added within Master account
- (void) getUserInstagramWithAccessToken:(NSString*)accessToken fileName:(NSString*)fileName image:(UIImage*)image
{
	if (![UIUtils checkNetworkConnection])
		return;
	
	[_gAppDelegate showLoadingView:YES];
    
    NSString* userInfoUrl = [NSString stringWithFormat:@"%@/v1/users/self?access_token=%@", kInstagramAPIBaseURL,
                             accessToken];
	
	NSURLRequest* request = [WebServiceManager requestWithUrlString:userInfoUrl];
	
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 if (responseData)
		 {
			 NSDictionary* dict = [WebServiceManager JSONData:responseData];
			 NSDictionary* userDict = [dict objectForKey:@"data"];
			 if (userDict)
			 {
                                 InstagramUser* userInfo = [[InstagramUser alloc] initWithDictionary:userDict];
                                 userInfo.accessToken = accessToken;
                                 userInfo.fileName=fileName;
                                 userInfo.shareImage=image;
//                                 _ReleaseObject(userInfo);
                                 
                                 [_gAppDelegate showPostToigViewControllerWithUserInfo:userInfo];
                         }
		 }
		 else
		 {
                         [UIUtils messageAlert:kErrorMessage title:kErrorTitle delegate:nil];
                 }
                 [_gAppDelegate showLoadingView:NO];
     }];
}

@end
