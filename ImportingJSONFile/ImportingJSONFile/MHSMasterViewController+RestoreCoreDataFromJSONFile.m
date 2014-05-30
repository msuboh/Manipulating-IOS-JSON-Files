//
//  MHSMasterViewController+RestoreCoreDataFromJSONFile.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/27/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSMasterViewController+RestoreCoreDataFromJSONFile.h"
#import "KababishMenuObject.h"
typedef void(^myCompletionII)(BOOL);

@implementation MHSMasterViewController (RestoreCoreDataFromJSONFile)



-(void) mySecondBlockMethod:(myCompletionII)completionBlockStatus
{
    
    [self deleteAllRecords];
    [self.tableView reloadData];
    
    completionBlockStatus(YES);
}

- (void) restoreCoreDataFromJSON:(NSURL *)url
{
    // Here I am using my completion Custom Block
    [self mySecondBlockMethod:^(BOOL finished)  {
        // myBlockMethod method just download or load the JSON file from the server to a NSString String variable and check if it is there and no error, before we Parse it into an array.
        
        
        if(finished)
        {
            NSLog(@"Success!");
            
            
            NSError* err = nil;
//            NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"StreamJSON" ofType:@"json"];
            NSString *JSONDataFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"kababishbackup.json"];
            NSArray* kababishMenuJSONFile = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:JSONDataFile]    options:kNilOptions    error:&err];
            
            
//            NSLog(@"%d", [kababishMenuJSONFile count]);

            
            __block NSString *firstFieldName = @"";
            
            __block NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
            __block int i = 0;
            
            [kababishMenuJSONFile enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([firstFieldName isEqualToString:[obj objectForKey:@"Field Name"]]  || [firstFieldName isEqualToString:@""]  )
                {
                    if ( ![firstFieldName isEqualToString:@""] )
                    {
                        [self saveToCoreData:dict];
                        dict = [NSMutableDictionary new];
                        i +=1;
                    }
                    firstFieldName = [obj objectForKey:@"Field Name"];
                    
                }
                
                NSDictionary *fieldData = [obj objectForKey:@"Field Data"];
                [dict setValue:[fieldData objectForKey:@"Field Value"] forKey:[obj objectForKey:@"Field Name"]];
                
                
            }];
            
            [self saveToCoreData:dict];
            
            
        }
        else
        {
            NSLog(@"No Success!");
        }
    }];
 
}


- (void) restoreCoreDataFromJSON3
{
    
    // THIS PROCEDURE SAVES FIELD BY FIELD  VALUE ... IT GIVES AN ERROR BECAUSE OF THE SORTING FILED SHOULD BE READY FOR fetchedResultsController
    // IN SUCH CASE THE WHOLE RECORD WITH ITS VALUES SHOULD EXISTS
    //
    // THOUGHT ITS A GOOD IDEA AND FAST CODING TO DO, BUT I AM NOT SURE EVEN IF IT IS FAST?!
    // I KEPT THE FOLLOWING PROCEDURE JUST IN CASE I NEED IT FOR SOMETHING ELSE LATER IN ANOTHER PROJECT, OR MAYBE USED FOR UPDATING THE RECORD ;).
    //
    // USE THE ABOVE METHOD, IT IS MORE ACCURATE.
    //
    
    
    // Here I am using my completion Custom Block
    [self mySecondBlockMethod:^(BOOL finished)  {
        // myBlockMethod method just download or load the JSON file from the server to a NSString String variable and check if it is there and no error, before we Parse it into an array.
        
        
        if(finished)
        {
            NSLog(@"Success!");
            
            
            NSError* err = nil;
            NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"StreamJSON" ofType:@"json"];
            NSArray* kababishMenuJSONFile = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]    options:kNilOptions    error:&err];
            
            
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            
            
            
            __block NSString *firstFieldName = @"";
            __block KababishMenuObject *kababishMenu;
            
            [kababishMenuJSONFile enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([firstFieldName isEqualToString:[obj objectForKey:@"Field Name"]]  || [firstFieldName isEqualToString:@""]  )
                {
                    kababishMenu = [NSEntityDescription    insertNewObjectForEntityForName:@"Event"    inManagedObjectContext:context];
                    firstFieldName = [obj objectForKey:@"Field Name"];
                }
                
                
                
                if ([[obj objectForKey:@"Field Name"] isEqualToString:@"timeStamp"])
                {
                    kababishMenu.timeStamp = [NSDate date];
                }
                else if ([[obj objectForKey:@"Field Name"] isEqualToString:@"menuItemPrice"])
                {
                    NSDictionary *fieldData = [obj objectForKey:@"Field Data"];
                    [kababishMenu setValue: [NSNumber numberWithDouble:  [ [fieldData objectForKey:@"Field Value"]  doubleValue]   ] forKey:[obj objectForKey:@"Field Name"] ];
                    
                }
                else if ([[obj objectForKey:@"Field Name"] isEqualToString:@"recordID"])
                {
                    NSDictionary *fieldData = [obj objectForKey:@"Field Data"];
                    [kababishMenu setValue: [NSNumber numberWithInteger:  [ [fieldData objectForKey:@"Field Value"]  integerValue]   ] forKey:[obj objectForKey:@"Field Name"] ];
                    
                }
                else
                {
                    NSDictionary *fieldData = [obj objectForKey:@"Field Data"];
                    
                    [kababishMenu setValue:[fieldData objectForKey:@"Field Value"] forKey:[obj objectForKey:@"Field Name"] ];
                    
                }
                
                
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                
                
            }];
            

            
            
        }
        else
        {
            NSLog(@"No Success!");
        }
    }];



    
    
 
 
}

- (void) saveToCoreData:(NSDictionary*)recordArray
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    KababishMenuObject *kababishMenu = [NSEntityDescription    insertNewObjectForEntityForName:@"Event"    inManagedObjectContext:context];

    NSArray * values =[recordArray allValues];
    NSArray * keys =[recordArray allKeys];

    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:0] forKey:[keys objectAtIndex:0]]   forKey: [keys objectAtIndex:0] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:1] forKey:[keys objectAtIndex:1]]   forKey: [keys objectAtIndex:1] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:2] forKey:[keys objectAtIndex:2]]   forKey: [keys objectAtIndex:2] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:3] forKey:[keys objectAtIndex:3]]   forKey: [keys objectAtIndex:3] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:4] forKey:[keys objectAtIndex:4]]   forKey: [keys objectAtIndex:4] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:5] forKey:[keys objectAtIndex:5]]   forKey: [keys objectAtIndex:5] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:6] forKey:[keys objectAtIndex:6]]   forKey: [keys objectAtIndex:6] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:7] forKey:[keys objectAtIndex:7]]   forKey: [keys objectAtIndex:7] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:8] forKey:[keys objectAtIndex:8]]   forKey: [keys objectAtIndex:8] ];
    [kababishMenu setValue: [self retrunValueType:[values objectAtIndex:9] forKey:[keys objectAtIndex:9]]   forKey: [keys objectAtIndex:9] ];

    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
  
}

- (id)retrunValueType:(NSString*)forValue forKey:(NSString*)theKey
{
    

                if ([theKey isEqualToString:@"timeStamp"])
                {
                    return ( [NSDate date] );
                }
                else if ([theKey isEqualToString:@"menuItemPrice"])
                {
                    return ([NSNumber numberWithDouble:  [ forValue  doubleValue]   ] );
                }
                else if ([theKey isEqualToString:@"recordID"])
                {
                    return ([NSNumber numberWithInteger:  [ forValue  integerValue]   ] );

                }
                else
                {
                    return (forValue);
                }
    
 
}


@end
