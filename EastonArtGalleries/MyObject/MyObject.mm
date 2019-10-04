//
//  MyObject.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 03/08/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import "MyObject.h"
#import "AppDelegate.h"

#if IS_UNITY_USE
        #import "AssemblyU2DCSharp_UnityExeternCalls1551984523MethodDeclarations.h"
        #import "AssemblyU2DCSharp_ViewManager2493563176MethodDeclarations.h"
        #import "AssemblyU2DCSharp_ViewManager2493563176.h"
#endif


@implementation MyObject

#pragma mark - Call Function from unity

void MyObjectHideUnity (){
        [MyObject hideUnity];
}



void MyObjectSendArtDetail(){
        
        // System.Void FillCanvas::LogData()
        //Called on Click for detail button
//        FillCanvas_LogData_m1649253772 (FillCanvas_t941999323 * __this, const MethodInfo* method)
        
        //Decode artdetail
//        NSString* decodedDetail=[NSString stringWithUTF8String:il2cpp_codegen_marshal_string(__artDetail)];
        
        
        //Hide unity window
        [MyObject hideUnity];
        
        //fetch art detail to objetive -c
        [[MyObject sharedClass]clickForDetails];
}

void MyObjectReloadGallery(){
        
        [MyObject reloadGallery];
        
}

#pragma mark - Call methods from Objective c


+ (MyObject*)sharedClass{
        static MyObject* obj = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                obj = [[self alloc] init];
                
        });
        
        return obj;
        
}

#if IS_UNITY_USE

+(void)reloadGallery{
        
        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        
        ViewManager_ReloadGallery_m3754742170(viewManager, /*hidden argument*/NULL);
}

+(void)resetArtistList{
        
        NSDictionary* artistList=[Alert getFromLocal:@"artistlist"];
        [MyObject setArtistList:[Alert jsonStringWithDictionary:artistList]];
        
}

+(void)changeToPortrait{
        
        UnityExeternCalls_ChangeToPortraitMode_m2204594317(NULL,NULL);
}

+(void)changeToLandscapeRight{
        
        UnityExeternCalls_ChangeToLandscapeMode_m3939313425(NULL,NULL);
}

+(void)mute{
        

        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        MethodInfo *method;
        
        ViewManager_Mute_m278651258 (viewManager/*ViewManager_t2493563176 * __this*/,
                                     method/*const MethodInfo* method*/);
}

+(void)unMute{
        
        
        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        MethodInfo *method;
        
        ViewManager_UnMute_m3831438707 (viewManager/*ViewManager_t2493563176 * __this*/,
                                        method/*const MethodInfo* method*/);
        
        ViewManager_RestartSound_m4013600225(viewManager, method);
        
}

+(void)setArtistName:(NSString*)name{
        
        
        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        MethodInfo* method;
        
        
        //Particular Artist load
        String_t *nameResponse=il2cpp_codegen_string_new_wrapper([name UTF8String]);
        
        ViewManager_UnityExternFetchPaintings_m2879753111(
        
                                                          viewManager/*ViewManager_t2493563176 *__this*/,
                                                          nameResponse/*String_t *___name*/,
                                                          method/* const MethodInfo *method*/);
        
        [MyObject sharedClass].isArtistListSet=YES;
        
}

+(void)setArtistList:(NSString*)string{
        
        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        MethodInfo* method;
        
        //All Artist list
        //        Il2CppCodeGenString* cpplistResponse;
        String_t *listResponse=il2cpp_codegen_string_new_wrapper([string UTF8String]);
        
        
        ViewManager_UnityExternSetArtistList_m1932916655(
                                                         viewManager/*ViewManager_t2493563176 *__this*/,
                                                         listResponse/* String_t *___response*/,
                                                         method/* const MethodInfo *method*/);

        [MyObject sharedClass].isArtistListSet=YES;
}

+(void)navigationButtonTapped{
        
        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        MethodInfo* method;
        
        ViewManager_NavigationButtonTapped_m3153518003(viewManager, method);
}

-(void)clickForDetails{

        // Or alternate , fetch artdetail
        ViewManager_t2493563176  *viewManager=getViewManager_t2493563176();
        String_t *encodedDetail=viewManager->get_logData_30();
        NSString* decodedDetail=[NSString stringWithUTF8String:il2cpp_codegen_marshal_string(encodedDetail)];
        //
        
//        NSLog(@"Click for detail->%@",decodedDetail);
        
        if([self.delegate respondsToSelector:@selector(getClickedDetail:)])
                [self.delegate getClickedDetail:decodedDetail];
        
        
}

#endif

+(void)hideUnity{
        
        NSLog(@"[ViewController] Hide Unity");
        
        
        //        if(![AppDelegate appDelegate].isAppEastonArt)
        //                [[AppDelegate appDelegate] closeUnityApp];
        
        
        //        [self navigationButtonTapped];
        [self mute];
        [self changeToPortrait];
        
        
        //        ViewManager_NavigationButtonTapped_m3153518003(NULL, NULL);
        
        //[self changeToPortraitLocaly];
        
        //#if IS_UNITY_USE
        [UIView animateWithDuration:0.3 animations:^{
                
                [[AppDelegate appDelegate] hideUnityWindow];
                
                //                [[AppDelegate appDelegate] closeUnityApp];
        }];
        //#endif
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"name" object:nil userInfo:nil];
        
        
}

+(void)changeToPortraitForDevice{
        
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger:  UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
}

+(void)changeToLandscapeRightForDevice{
        
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger:  UIInterfaceOrientationLandscapeRight]
                                    forKey:@"orientation"];
        
}


//get ViewManager
//define to funtion Declaration in "AssemblyU2DCSharp_ViewManager2493563176MethodDeclarations.h"
/*
extern "C"  ViewManager_t2493563176 * getViewManager_t2493563176 ();
 */

//get ViewManager
// define to Definition in where ViewManager's all methods defined
/*
extern TypeInfo* ViewManager_t2493563176_il2cpp_TypeInfo_var;
extern "C"  ViewManager_t2493563176 * getViewManager_t2493563176 (){
        
        IL2CPP_RUNTIME_CLASS_INIT(ViewManager_t2493563176_il2cpp_TypeInfo_var);
        ViewManager_t2493563176 * L_1 = ((ViewManager_t2493563176_StaticFields*)ViewManager_t2493563176_il2cpp_TypeInfo_var->static_fields)->get_instance_2();
        NullCheck(L_1);
        return L_1;
        
}
 */


@end
