//
//  MHSMasterViewController+ImportLocalJSONFileToCoreData.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/25/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSMasterViewController+ImportLocalJSONFileToCoreData.h"
#import "KababishMenuObject.h"

@implementation MHSMasterViewController (ImportLocalJSONFileToCoreData)



- (void) importLocalJSONFile
{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"KababishMenu" ofType:@"json"];
    NSArray* kababishMenuJSONFile = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]    options:kNilOptions    error:&err];
    
    //    NSLog(@"%@",kababishMenuJSONFile);
    //
    //    NSLog(@"========================================================================");
    //    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.1.100/Kababish/KababishMenu.json"]];
    //    NSArray* kababishMenuJSONFile = [NSJSONSerialization JSONObjectWithData:responseData   options:kNilOptions    error:&err];
    
    
    //    dispatch_async(kBgQueue, ^{
    //        NSData* data = [NSData dataWithContentsOfURL: kLatestKivaLoansURL];
    //        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    //    });
    //
    
    //    NSLog(@"Imported Banks: %@", kababishMenuJSONFile);
    
    
    [self deleteAllRecords];
    
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    //    __block NSInteger i = 0;
    
    [kababishMenuJSONFile enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        KababishMenuObject *kababishMenu = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"Event"
                                            inManagedObjectContext:context];
        
        kababishMenu.timeStamp = [NSDate date];
        kababishMenu.menuItemNumber = [obj objectForKey:@"No"];
        kababishMenu.menuItemCategory = [obj objectForKey:@"MenuCategory"];
        kababishMenu.menuItemName = [obj objectForKey:@"MenuItem"];
        kababishMenu.menuItemBriefDescription = [obj objectForKey:@"ItemName"];
        kababishMenu.menuItemDescription = [obj objectForKey:@"ItemDescription"];
        kababishMenu.menuItemPrice = [obj objectForKey:@"ItemPrice"];
        kababishMenu.menuItemCategoryOrderIncludes = [obj objectForKey:@"OrderIncludes"];
        kababishMenu.menuItemSideOrder = [obj objectForKey:@"SideOrder"];
        kababishMenu.recordID =  [NSNumber numberWithInteger:[[obj objectForKey:@"RecordID"] integerValue] ]   ;
        //        kababishMenu.recordID =  [NSNumber numberWithInteger:i++ ]   ;
        
        
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }];
    

    
    
}


@end
