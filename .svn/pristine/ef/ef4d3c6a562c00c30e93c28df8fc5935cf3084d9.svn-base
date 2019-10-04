//
//  WebService.m
//  PermitApp
//
//  Created by Admin on 16/09/13.
//  Copyright (c) 2013 MohitTomar. All rights reserved.
//

#import "WebService.h"


@implementation WebService

@synthesize  postReqURL,postReqDataArray,webData,delegate,responseDataDic,postString,methodname;



-(id)initWithObject : (id )obj_currentView {
    self = [super init];
    if (self) {
		self.postReqDataArray = [NSMutableDictionary dictionary];
		self.webData = [[NSMutableData alloc] init];
            
            return self;
	
    }
        return nil;
}



-(NSString *)genPostData{
	NSString *genPostData = [[NSString alloc] init];
	
	for(NSString *aKey in self.postReqDataArray){
		if([genPostData length] > 0)
			genPostData = [genPostData stringByAppendingString:@"&"];
		
		genPostData = [genPostData stringByAppendingString:[NSString stringWithFormat:@"%@=%@", aKey, [self.postReqDataArray valueForKey:aKey]]];
		
	}
	return genPostData;
}

-(void) getDataFromUrl{
	//NSString *postString = [self genPostData];
	
	NSURL *postURL = [NSURL URLWithString:postReqURL];
	NSMutableURLRequest *postReq = [NSMutableURLRequest requestWithURL:postURL];
        
//        NSMutableURLRequest *postReq=[[NSMutableURLRequest alloc] initWithURL:postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//        [postReq setHTTPShouldHandleCookies:YES];
        
	NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	[postReq setValue:@"application/x-www-from-urlencoded" forHTTPHeaderField:@"Current-Type"];
//        [postReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[postReq setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[postReq setHTTPMethod:@"POST"];
	[postReq setHTTPBody:postData];
        [postReq setTimeoutInterval:30.0f];
        
	NSURLConnection *webConnection = [[NSURLConnection alloc] initWithRequest:postReq delegate:self];
	
	if (webConnection) {
		
	}
	
}

-(void)getDataFromUrlWithData:(NSData *)fileData fileName:(NSString*)fileName{
    //NSString *postString = [self genPostData];
    
    NSURL *postURL = [NSURL URLWithString:postReqURL];
    NSMutableURLRequest *postReq = [NSMutableURLRequest requestWithURL:postURL];
    
    [postReq setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [postReq addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *imageName=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_image\"; filename=\"%@\"\r\n",fileName];
    
    [body appendData:[imageName dataUsingEncoding:NSUTF8StringEncoding]];
    
    // [body appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"%@.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //  parameter username
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [postReq setHTTPBody:body];
    

    NSURLConnection *webConnection = [[NSURLConnection alloc] initWithRequest:postReq delegate:self];
    
    if (webConnection) {
        
    }
    
}


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[webData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[webData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@" get error, %@",error);
    [delegate webServiceFail:error];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"DONE. Received Bytes:%d", [webData length]);
	
    
//	NSMutableString *returnData = [[NSMutableString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSError *error;
    
   //NSLog(@" get data : %@", returnData);
    responseDataDic = [NSJSONSerialization JSONObjectWithData:webData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&error];
    
    
    [delegate getdataFormWebService:responseDataDic];
    [delegate getdataFormWebService:responseDataDic methodnameIs:methodname];
   // NSLog(@" get data : %@", responseDataDic);
}


@end

