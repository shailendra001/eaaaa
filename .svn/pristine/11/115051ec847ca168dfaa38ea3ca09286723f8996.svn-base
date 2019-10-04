//
//  PostToInstagramViewController.m
//  InstragramSample
//
//  Created by Neha Sinha on 29/01/14.
//  Copyright (c) 2014 Mindfire Solutions. All rights reserved.
//

#import "PostToInstagramViewController.h"

@interface PostToInstagramViewController ()
{
        BOOL didSelectOptionFromDocumentController;
}

@end

@implementation PostToInstagramViewController

#pragma mark -- View Controller life cycle

- (void)viewDidLoad{
        [super viewDidLoad];
        
        [self config];
        
        [self loadData];
        
        if([self.from isEqualToString:@"back"]) [self setNav];
        else                                    [self navigationBarConfiguration];
}

- (void) viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        self.title = @"Post Photo";
        
        if(didSelectOptionFromDocumentController){
                didSelectOptionFromDocumentController = NO;
                [UIUtils messageAlert:@"Successfully posted." title:nil delegate:nil];
        }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) dealloc{
//    _ReleaseObject(_imageView);
//    [super dealloc];
}


#pragma mark - Custom Methods

-(void)config{
        
        self.imgProfilePic.layer.cornerRadius=self.imgProfilePic.bounds.size.width/2;
        self.imgProfilePic.layer.masksToBounds=YES;
        self.imgProfilePic.layer.borderWidth=2.0;
        self.imgProfilePic.layer.borderColor=[UIColor blackColor].CGColor;
        
        self.viContainerPost.layer.cornerRadius=2.0;
        self.viContainerPost.layer.masksToBounds=YES;
        
        self.viContainerHomePage.layer.cornerRadius=2.0;
        self.viContainerHomePage.layer.masksToBounds=YES;
        
        
        didSelectOptionFromDocumentController = NO;
}

-(void)setNav{
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
}

-(UIImage*)setNavBarImage{
        
        UIImage* result;
        UIImage* image=[Alert imageFromColor:[UIColor blackColor]];
        
        
        if (IS_IPHONE_4){
                
                
                CGRect rect = CGRectMake(0,0,320,44);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        else{
                CGRect rect = CGRectMake(0,0,320,88);
                UIImage *img=[Alert imageResize:rect image:image];//[UIImage imageNamed:@"nav_mage.png"]
                result=img;
        }
        
        return result;
        
}

#pragma Mark Navigation Bar Configuration Code

-(void)navigationBarConfiguration{
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setBackgroundImage:[self setNavBarImage]
                                                      forBarMetrics:UIBarMetricsDefault];
        UIButton * menuButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        menuButton.frame = CGRectMake(8, 20, 24, 18);
        [menuButton setBackgroundImage:[UIImage imageNamed:MENU_IMAGE] forState:UIControlStateNormal];
        
        //    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *accountBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        self.navigationItem.leftBarButtonItem = accountBarItem;
        //[self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark -- action when Post To Instagram button is clicked

- (IBAction)postToInstagramClicked:(id)sender{
    [self shareImageWithInstagram];
}

-(void)loadData{
        
        self.lblUsername.text=_userInfo.userName;
        self.lblFullName.text=_userInfo.fullName;
        
        NSURL* url=[NSURL URLWithString:self.userInfo.profilePicture];
        self.imgProfilePic.contentMode=UIViewContentModeScaleAspectFit;
        self.imgProfilePic.backgroundColor=[UIColor whiteColor];
        UIImage* imgPlaceHolder=[UIImage imageNamed:@"default_user.png"];
        
        __weak UIImageView *weakImgPic = self.imgProfilePic;
        [self.imgProfilePic setImageWithURL:url
                    placeholderImage:imgPlaceHolder
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image )
         {
                 //                 dispatch_async(dispatch_get_main_queue(), ^{
                 
                 UIImageView *strongImgPic = weakImgPic;
                 if (!strongImgPic) return;
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                         strongImgPic.image=image;
                 });
                 
                 [UIView transitionWithView:strongImgPic
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                  
                                 animations:^{
                                         // strongImgPic.image=image;
                                         
                                 }
                                 completion:^(BOOL finish){
                                 }];
                 
                 
         } failure:NULL];
}

- (void) shareImageWithInstagram{
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedClass sharedObject] addProgressHud:self.navigationController.view];
                
        });
        
        NSString* path=[Alert getDocumentoryPathWithFolder:@"sharedImages"];
        NSString* fileName=[self.shareFileName stringByAppendingString:@".ig"];
//        path=[path stringByAppendingPathComponent:fileName];
        NSData* imageData = UIImagePNGRepresentation(self.shareImage);
        [Alert saveFile:fileName data:imageData path:path];
        
        if(YES){
                
                CGRect rect = CGRectMake(0 ,0 , 0, 0);

                NSString* imagePath=[path stringByAppendingPathComponent:fileName];
                
        //        NSString* imagePath = [UIUtils documentDirectoryWithSubpath:@"image.igo"];
        //        BOOL success=[imageData writeToFile:imagePath atomically:NO];
        //        NSURL* fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"file://%@",imagePath]];
                
                NSURL *fileURL = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", imagePath]];
                
                self.docFile.UTI = @"com.instagram.photo";
//                self.docFile = [self setupControllerWithURL:fileURL usingDelegate:self];
                [self setupDocumentControllerWithURL:fileURL];
//                self.docFile=[UIDocumentInteractionController interactionControllerWithURL:fileURL];
//                self.docFile.annotation = [NSDictionary dictionaryWithObject: @"This is a demo caption"
//                                                                      forKey:@"InstagramCaption"];
                
                NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
                [self.docFile presentOpenInMenuFromRect:rect inView:self.view animated:YES];
                if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
                {
                        // OPEN THE HOOK
                        [self.docFile presentOpenInMenuFromRect:rect inView:self.view animated:YES];
                }
                else
                {
                    NSLog(@"Instagram not found");
                }
                
                
                
        }
        else{
                [[SharedClass sharedObject] hudeHide];
                [UIUtils messageAlert:@"Somthing went wrong ! File not found ." title:nil delegate:nil];
        }
        
}

#pragma mark -- UIDocumentInteractionController delegate

- (void)setupDocumentControllerWithURL:(NSURL *)url {
        
        if (self.docFile == nil) {
                self.docFile = [UIDocumentInteractionController interactionControllerWithURL:url];
                self.docFile.delegate = self;
        }
        else {
                self.docFile.URL = url;
        }
}

- (UIDocumentInteractionController *) setupControllerWithURL:(NSURL*)fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller{
        
//        didSelectOptionFromDocumentController = YES;
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
        
        NSLog(@"%@",application);
        
        [[SharedClass sharedObject] hudeHide];
        
        didSelectOptionFromDocumentController = NO;
}



-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
        didSelectOptionFromDocumentController = YES;
}


-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
        [[SharedClass sharedObject] hudeHide];
        if (didSelectOptionFromDocumentController == NO) {//user cancelled.
                
        }
        else{
                didSelectOptionFromDocumentController = NO;
                
                [UIUtils messageAlert:@"Successfully posted." title:nil delegate:nil];
        }
}

- (IBAction)homePage:(id)sender {
        
        MOVE_VIEW_CONTROLLER_VIEW_DECK(GET_VIEW_CONTROLLER_STORYBOARD(kViewController));
}
@end
