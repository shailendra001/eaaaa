//
//  SignInViewController.h
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

@interface SignInViewController : UIViewController
{
    IBOutlet UIWebView* _webView;
}
@property (strong, nonatomic) NSString* from;

@property (strong, nonatomic) UIImage* shareImage;

@property (strong, nonatomic) NSString* fileName;


@end
