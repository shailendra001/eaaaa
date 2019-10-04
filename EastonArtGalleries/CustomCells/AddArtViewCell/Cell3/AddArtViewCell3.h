//
//  AddArtViewCell3.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 18/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddArtViewCell3 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerChooseFile;
@property (strong, nonatomic) IBOutlet UILabel *lblChooseFile;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseFile;

@property (strong, nonatomic) IBOutlet UILabel *lblFileName;

@property (strong, nonatomic) IBOutlet UIView *viContainerAddMore;
@property (strong, nonatomic) IBOutlet UILabel *lblAddMore;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMore;

@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;
@end
