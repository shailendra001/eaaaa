//
//  TermsOfUseBecomeAsellerVC.m
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 18/09/17.
//  Copyright © 2017 infoicon. All rights reserved.
//

#import "TermsOfUseBecomeAsellerVC.h"

@interface TermsOfUseBecomeAsellerVC ()<UIWebViewDelegate>

{
        UILabel *labelLoading;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation TermsOfUseBecomeAsellerVC

- (void)viewDidLoad {
        
    [super viewDidLoad];
        
        [self setLogoImage];
        if([self.from isEqualToString:@"back"]) {
                
                [self setNav];
        }
        
        self.labelTitle.text=[self.titleString uppercaseString];
        self.webView.delegate = self;
        
        labelLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- 150.0)];
        labelLoading.textAlignment = NSTextAlignmentCenter;
        labelLoading.text = @"Loading...";
        
        labelLoading.hidden = NO;
        
        [self.view addSubview:labelLoading];
        NSString *address = @"https://www.eastonartgalleries.com/artist-agreement";
        
        NSString *urlString = [NSString stringWithFormat:@"%@",address];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        
       
        
}

-(void)setLogoImage {
        
        UIImage* logoImage = [UIImage imageNamed:LOGO_IMAGE];
        UIImageView* imgLogo=[[UIImageView alloc] initWithImage:logoImage];
        imgLogo.frame=CGRectMake(0, 0, 49, 44);
        
        UIView* logoView=[[UIView alloc]initWithFrame:imgLogo.frame];
        [logoView addSubview:imgLogo];
        
        self.navigationItem.titleView =logoView;
}

-(void)setNav {
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;

}

#pragma mark - UIWebview Delegate method -


- (void)webViewDidStartLoad:(UIWebView *)webView
{
        
        labelLoading.hidden = NO;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
        labelLoading.hidden = YES;

}

#pragma mark - Memory management method -

- (void)didReceiveMemoryWarning {
        
    [super didReceiveMemoryWarning];
   
}


@end
