//
//  MHSDetailViewController.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/22/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSDetailViewController.h"

@interface MHSDetailViewController ()
- (void)configureView;
@end

@implementation MHSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
//        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    [self.spinner startAnimating];

    if (self.detailItem)
    {

        [self displayDetailRowFromRemoteJSON];
    
    }
    
    [self.spinner stopAnimating];

//    if (self.detailItem) {
//        
//        
//        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init] ;
//        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//        formatter.currencyCode = @"USD";
//        
//        NSString * formattedAmount = [formatter stringFromNumber:  [self.detailItem valueForKey:@"menuItemPrice"]   ];
//        
//        
//        
//        //        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
//        self.title = [[self.detailItem valueForKey:@"menuItemCategory"] description];
//        self.detailDescriptionLabel.text = [NSString  stringWithFormat:@"%@\n%@\n\n%@\n\n%@\n%@\n%@\n\n%@",
//                                            [[self.detailItem valueForKey:@"recordID"] description],
//                                            [[self.detailItem valueForKey:@"menuItemNumber"] description],
//                                            [[self.detailItem valueForKey:@"menuItemCategoryOrderIncludes"] description],
//                                            [[self.detailItem valueForKey:@"menuItemName"] description],
//                                            [[self.detailItem valueForKey:@"menuItemBriefDescription"] description],
//                                            [[self.detailItem valueForKey:@"menuItemDescription"] description],
//                                            formattedAmount
//                                            ];
//        
//    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //////////////////////////////////////////////
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
    _spinner.center = self.view.center;
    [_spinner setColor:[UIColor blueColor]];
    [self.view addSubview:_spinner];
    [self.view bringSubviewToFront:_spinner];
    /////////////////////////////////////////////
    
    
    [self configureView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ConverJSONorText:(UIButton *)sender {
    [self.spinner startAnimating];

//    //build an info object and convert to json
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
//                          [loan objectForKey:@"name"], @"who",
//                          [(NSDictionary*)[loan objectForKey:@"location"] objectForKey:@"country"], @"where",
//                          [NSNumber numberWithFloat: outstandingAmount], @"what",
//                          nil];
//
//    //convert object to data
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//
//    //print out the data contents
//    jsonSummary.text = [[NSString alloc] initWithData:jsonData
//                                             encoding:NSUTF8StringEncoding];
    
    NSString *title=sender.titleLabel.text;
    
    if ([title isEqualToString:@"Convert To JSON"])
    {
        //alert
        [self displayJSONNodeFromCoreDataObject];
    }
    else
    {
        [self displayDetailRowFromRemoteJSON];
    }
    
   
    [self.spinner stopAnimating];

    
}
@end
