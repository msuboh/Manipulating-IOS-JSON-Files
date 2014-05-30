//
//  MHSMasterViewController.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/22/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSMasterViewController.h"

#import "MHSDetailViewController.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

typedef void(^myCompletion)(BOOL);

//////////////////////////////////////////////
//
// In  This  App  I  am  Creating  and  Using  Categories  Files  Just  Only for  the  Sake  of  Organizing  My  Code
//
//////////////////////////////////////////////


@interface MHSMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MHSMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backupCoreDataToJSONFile:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    //////////////////////////////////////////////
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
    _spinner.center = self.view.center;
    [_spinner setColor:[UIColor blueColor]];
    [self.view addSubview:_spinner];
    [self.view bringSubviewToFront:_spinner];
    /////////////////////////////////////////////
    
    /*
     
     NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:  [NSURL URLWithString:@"ENTER-URL-HERE"]];
     

     
     NSError *error;
     NSMutableDictionary *allCourses = [NSJSONSerialization
     JSONObjectWithData:allCoursesData
     options:NSJSONReadingMutableContainers
     error:&error];
     
     NSError *error;
     NSMutableDictionary *allCourses = [NSJSONSerialization
     JSONObjectWithData:allCoursesData
     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
     error:&error];
     
     NSError *error;
     NSDictionary *allCourses = [NSJSONSerialization
     JSONObjectWithData:allCoursesData
     options:kNilOptions
     error:&error];
     
     
     if( error )
     {
     NSLog(@"%@", [error localizedDescription]);
     }
     else {
     NSArray *monday = allCourses[@"Monday"];
     for ( NSDictionary *theCourse in monday )
     {
     NSLog(@"----");
     NSLog(@"Title: %@", theCourse[@"title"] );
     NSLog(@"Speaker: %@", theCourse[@"speaker"] );
     NSLog(@"Time: %@", theCourse[@"time"] );
     NSLog(@"Room: %@", theCourse[@"room"] );
     NSLog(@"Details: %@", theCourse[@"details"] );
     NSLog(@"----");
     }
     }
     
     
     Read more: http://www.intertech.com/Blog/basic-json-parsing-in-ios/#ixzz32VXcdqrq
     Follow us: @IntertechInc on Twitter | Intertech on Facebook
     
     */
    
    
    

    
    
    [self importLocalJSONFile];
    

    
    
    
    
}

//1. This function is called from the App Delegate when you Tap on the attached JSON fie from your email on the Device
- (void)handleOpenURL:(NSURL *)url
{
    // Look for the following two keys ("Document types", "Exported Type UTIs") in the project-Info.plist for accepting files frfom email system as your project default for excution.

    [self.spinner startAnimating];
    
    [self performSelectorOnMainThread:@selector(restoreFromAttachedEmail:) withObject:url waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.spinner stopAnimating];
    });
}

//2. Read the Data from the JSON Attached file and  imported/interested into Core Data
-(void)restoreFromAttachedEmail:(NSURL *)url
{
    // Here I am using my completion Custom Block to copy data from the JSON Attached Email file into Core Data
    [self myBlockMethod:url theCompleteStatus:^(BOOL finished)  {
        // myBlockMethod method just download or load the JSON file from the server to a NSString String variable and check if it is there and no error, before we Parse it into an array.
        
        
        if(finished)
        {
            //Delete all *.json file  from IOS App Document/Inbox sandbox
            [self removeAllJSONFilesFromTmpDirectory];
            NSLog(@"Success!");
        }
        else
        {
            NSLog(@"No Success!");
        }
    }];
    
}

//3.
-(void) myBlockMethod:(NSURL *)url theCompleteStatus:(myCompletion)completionBlockStatus
{
    
    
    if (url)
    {
        //Here I am calling the Copy data from the JSON Attached Email file into Core Data
        [self restoreCoreDataFromJSON:url];
    }
    
    [self.tableView reloadData];
    
    
    
    completionBlockStatus(YES);
}

//4.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//      The following code is for importing the JSON file from email
///
-(void) removeAllJSONFilesFromTmpDirectory
{
    NSFileManager  *manager = [NSFileManager defaultManager];
    
    //1. Way 1 work Good
    //    NSString *fileName = @"AppDataBackup.json";
    //    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *inboxDirectory = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    //    NSString *filePath = [inboxDirectory stringByAppendingPathComponent:fileName];
    //    NSError *error;
    //    BOOL success = [manager removeItemAtPath:filePath error:&error];
    //    if (!success) {
    //        NSLog(@"error occured during removing the file");
    //    }
    //
    
    
    // 2. Way 2 ...?!
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    if ([paths count] > 0)
    //    {
    //        NSError *error = nil;
    //        NSFileManager *fileManager = [NSFileManager defaultManager];
    //
    //        // Print out the path to verify we are in the right place
    //        NSString *directory = [paths objectAtIndex:0];
    //        NSLog(@"Directory: %@", directory);
    //
    //        // For each file in the directory, create full path and delete the file
    //        for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error])
    //        {
    //            NSString *filePath = [directory stringByAppendingPathComponent:file];
    //            NSLog(@"File : %@", filePath);
    //
    //            BOOL fileDeleted = [fileManager removeItemAtPath:filePath error:&error];
    //
    //            if (fileDeleted != YES || error != nil)
    //            {
    //                // Deal with the error...
    //            }
    //        }
    //
    //    }
    
    
    // 3. Way 3... I like this one the best
    // the preferred way to get the apps documents directory
    // NSString *match = @"-*.json";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/Inbox"];
    // grab all the files in the documents dir
    NSArray *allFiles = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    // filter the array for only sqlite files
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.json'"];
    //NSPredicate *fltr = [NSPredicate predicateWithFormat:@"SELF like %@", match];
    NSArray *jsonFiles = [allFiles filteredArrayUsingPredicate:fltr];
    
    // use fast enumeration to iterate the array and delete the files
    for (NSString *jsonFile in jsonFiles)
    {
        NSError *error = nil;
        [manager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:jsonFile] error:&error];
        NSAssert(!error, @"Assertion: SQLite file deletion shall never throw an error.");
    }
    
    
    
}


- (void) deleteAllRecords
{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    
    //    NSSortDescriptor *sortDescriptorByAge = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    //    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorByAge, nil];
    //
    //
    //    [request setSortDescriptors:sortDescriptors];
    //
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"appDefault = 1"   ];
    //    [request setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        // handle error
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Save Error!"
                                  message:[NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo] ]
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    else
    {
        for (NSManagedObject *object in objects)
        {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    
}


- (void) backupCoreDataToJSONFile:(id)sender
{
   [self backupCoreDataToJSON];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"menuItemNumber" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"menuItemCategory" cacheName:nil];
    //@"Master"
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"menuItemName"] description];
}

@end
