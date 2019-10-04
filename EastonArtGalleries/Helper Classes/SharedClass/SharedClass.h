//
//  SharedClass.h
//  LoveFroyo
//
//  Created by Infoicon Technologies on 25/03/14.
//  Copyright (c) 2014 Infoicon Technologies. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"


@protocol RotationDelegate <NSObject>

-(void) upRoPrttation;
-(void) downPrtRotation;
-(void) rightLndscpRotation;
-(void) leftLndscpRotation;

@end


@interface SharedClass : NSObject<MBProgressHUDDelegate>{
    id <RotationDelegate> rotationDelegate;
    MBProgressHUD *HUD;
}

+(SharedClass *) sharedObject;

-(void) initShareCalss;

@property (nonatomic, strong)id <RotationDelegate> rotationDelegate;

//- (void) rotation;
//
- (BOOL)validateEmail:(NSString *)inputText;
//
- (BOOL)connected;

-(void) addProgressHud:(UIView *) view;
-(void) hudeHide;
@end
