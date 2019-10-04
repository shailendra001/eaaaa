//
//  EAGallery.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 06/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EAGallery : NSObject
{
        BOOL isLogin;
}
+ (EAGallery*)sharedClass;

-(void)saveDataLocal;

-(void)removeUserDetail;

-(int)getRoleType:(NSInteger)type;

-(void)popover:(id)sender vc:(UIViewController*)vc;

-(void)didSelectedMenuItem:(NSString*)name items:(NSArray*)items nav:(UINavigationController*)nav;

-(NSArray*)matchNameWithArray:(NSArray*)list Name:(NSString*)name;

-(void)flipView:(UIView*)view;

@property(assign ,nonatomic)BOOL isLogin;
@property(strong ,nonatomic)NSString* name;
@property(strong ,nonatomic)NSString* userName;
@property(strong ,nonatomic)NSString* email;
@property(strong ,nonatomic)NSString* country;
@property(strong ,nonatomic)NSString* phone;
@property(strong ,nonatomic)NSString* memberID;
@property(assign ,nonatomic)int type;
@property(assign ,nonatomic)UserRoleType roleType ;
@property(strong ,nonatomic)NSString* registeredOn;
@property(strong ,nonatomic)NSString* profileImage;
@property(strong ,nonatomic)NSString* coverImage;
@property(strong ,nonatomic)NSString* bio;
@property(strong ,nonatomic)NSString* profileVideo;
@property(strong ,nonatomic)NSString* walletAmount;


@end
