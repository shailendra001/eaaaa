//
//  BlogDetailsViewController.h
//  EastonArtGalleries
//
//  Created by Infoicon on 26/10/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viContainerDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextView *textViewDesc;


@property (strong, nonatomic) NSString* baseURL;

@property (strong, nonatomic) NSDictionary* dict;
@end
