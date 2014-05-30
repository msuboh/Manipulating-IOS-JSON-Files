//
//  MHSMasterViewController.h
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/22/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "MHSMasterViewController+ImportLocalJSONFileToCoreData.h"
#import "MHSMasterViewController+RestoreCoreDataFromJSONFile.h"
#import "MHSMasterViewController+BackupCoreDataToJSONFile.h"

@interface MHSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)  UIActivityIndicatorView *spinner;


// The following code is for importing the csv file from email
- (void)handleOpenURL:(NSURL *)url;

////////////// Shared between some of the Categories files:
//
- (void) deleteAllRecords;
@end
