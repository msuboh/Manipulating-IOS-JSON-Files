//
//  MHSDetailViewController.h
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/22/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSDetailViewController+ImportRemoteJSONFileAndDisplayDetail.h"
#import "MHSDetailViewController+CreateJSONNodeFromCodeDataRecord.h"


@interface MHSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionLabel;

- (IBAction)ConverJSONorText:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *convertJSON;

@property (strong, nonatomic)  UIActivityIndicatorView *spinner;


@end
