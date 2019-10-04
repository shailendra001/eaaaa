//
//  WebService.h
//  PermitApp
//
//  Created by Admin on 16/09/13.
//  Copyright (c) 2013 MohitTomar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

-(void) getdataFormWebService:(NSMutableDictionary *) webServiceDic;
-(void) getdataFormWebService:(NSMutableDictionary*) webServiceDic methodnameIs:(NSString*)methodName;
-(void) webServiceFail:(NSError *) error;

@end

@interface WebService : NSObject{
    
	NSMutableData *webData;
    NSMutableDictionary *responseDataArray;
    id <WebServiceDelegate> delegate;
    NSMutableDictionary *responseDataDic;
    NSString *postString;
}

-(void) getDataFromUrl;
-(void)getDataFromUrlWithData:(NSData *)fileData fileName:(NSString*)fileName;

@property (nonatomic, strong) NSString *methodname;
@property (nonatomic, strong) NSString *postReqURL;
@property (nonatomic, strong) NSString *postString;
@property (nonatomic, strong) NSMutableDictionary *postReqDataArray;
@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) id <WebServiceDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *responseDataDic;
-(id)initWithObject : (id )obj_currentView ;



@end
