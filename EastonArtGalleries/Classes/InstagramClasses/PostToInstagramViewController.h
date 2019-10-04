//
//  PostToInstagramViewController.h
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostToInstagramViewController : UIViewController <UIDocumentInteractionControllerDelegate>
{
    
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblFullName;
@property (strong, nonatomic) IBOutlet UIView *viContainerPost;
@property (strong, nonatomic) IBOutlet UIButton *btnPostToInstagram;

@property (strong, nonatomic) IBOutlet UIView *viContainerHomePage;
@property (strong, nonatomic) IBOutlet UIButton *btnHomePage;

@property (strong, nonatomic) NSString* from;
@property(nonatomic,strong) InstagramUser* userInfo;

@property(nonatomic,strong) UIImage* shareImage;
@property(nonatomic,strong) NSString* shareFileName;

@property(nonatomic,retain)UIDocumentInteractionController *docFile;

- (IBAction)homePage:(id)sender;
@end
