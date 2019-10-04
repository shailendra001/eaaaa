//
//  InstagramUser.m
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

#import "InstagramUser.h"

@implementation InstagramUser

- (id) initWithDictionary:(NSDictionary*)dict
{
	if (self = [super init])
	{
		self.userName = [UIUtils checkNull:[dict objectForKey:@"username"]];
        self.profilePicture = [UIUtils checkNull:[dict objectForKey:@"profile_picture"]];
		self.fullName = [UIUtils checkNull:[dict objectForKey:@"full_name"]];
        self.bio = [UIUtils checkNull:[dict objectForKey:@"bio"]];
        
		self.userId = [[UIUtils checkNull:[dict objectForKey:@"id"]] intValue];
        
        NSDictionary* countList = [UIUtils checkNull:[dict objectForKey:@"counts"]];
		self.followedBy = [[UIUtils checkNull:[countList objectForKey:@"followed_by"]] intValue];
	}
	return self;
}


@end
