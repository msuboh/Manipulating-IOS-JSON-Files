//
//  MHSDetailViewController+ImportRemoteJSONFileAndDisplayDetail.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/25/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSDetailViewController+ImportRemoteJSONFileAndDisplayDetail.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This Category Will read the whole JSON File from the Server (The JSON file is in a different format, just only for demenstation)
// Reads the JSON file and put it in NSDictionary (Not like the local on in  NSArray, again to show different ways)
// Search the JSON NSDictionary for the selected record from the Master view.
// Display a detailed Record data in UI readable format
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



@implementation MHSDetailViewController (ImportRemoteJSONFileAndDisplayDetail)



- (void) displayDetailRowFromRemoteJSON
{
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        //2. this KababishMenu4.json is included with the project, puit it in your server direcotory
        NSData* remoteData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"http://192.168.1.100/Kababish/KababishMenu4.json"]
                            ];
        //3
        NSDictionary* json = nil;
        if (remoteData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:remoteData
                    options:kNilOptions
                    error:nil];
        }
        
        //4
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            //5
            // [self updateUIWithDictionary:json withRecordID:[[self.detailItem valueForKey:@"recordID"] integerValue ]];
            [self updateUIWithDictionary2:json];
        });
        
    });
    

}



-(void)updateUIWithDictionary2:(NSDictionary*)json
{
    
    //I like to do this way, thought it might take time for long/big JSON Data file.
    
    @try {
        
        //        NSArray *jsonArray = [NSArray arrayWithObject:json];
        
        NSInteger recordID = 0;
        //        NSLog(@"[json count] = %d", [json[@"items"] count]);
        
        for (int i=0; i < [json[@"items"] count]; i++)
        {
            //            NSLog(@"Keys are %@", json[@"items"][i][@"No"]);
            if( [json[@"items"][i][@"No"] isEqual:[[self.detailItem valueForKey:@"menuItemNumber"] description]])
            {
                //Do your stuff  here
                recordID = i;
                break;
            }
        }
        
        //        BOOL found = NO;
        //        for (NSDictionary *dict in jsonArray) {
        //            NSLog(@"%@",[dict objectForKey:@"No"]);
        //            found = [[dict objectForKey:@"No"] isEqualToString:  [[self.detailItem valueForKey:@"menuItemNumber"] description]   ];
        //            if (found) break;
        //        }
        //
        //        if (!found) {
        //            NSLog(@"found such a key, e.g. %@",[[self.detailItem valueForKey:@"menuItemNumber"] description]);
        //        }
        
        self.detailDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self.convertJSON setTitle:@"Convert To JSON" forState:UIControlStateNormal];

        
        self.detailDescriptionLabel.text = [NSString stringWithFormat:
                                            @"Resturant Name: %@\n\n%@\n\nMenu Category: %@\nMenu Item: %@\n\n--- Item Description ---\n%@\n\nItem Price: %@\n\n\nImage Name: %@",
                                            json[@"paging"][0][@"header"],
                                            json[@"items"][recordID][@"No"],
                                            json[@"items"][recordID][@"MenuCategory"],
                                            json[@"items"][recordID][@"MenuItem"],
                                            json[@"items"][recordID][@"ItemDescription"],
                                            json[@"items"][recordID][@"ItemPrice"],
                                            json[@"items"][recordID][@"image"][@"image_name"],
                                            nil];
        
        
    }
    
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Could not parse the JSON feed."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil] show];
        NSLog(@"Exception: %@", exception);
    }
}



-(void)updateUIWithDictionary:(NSDictionary*)json withRecordID:(NSInteger)recordID
{
    //This way is fast and good, but you have to add one field to your data and make sure that the record ID and match with the record location in the JSON Array?!
    // OR you output is not consistant .....
    
    @try {
        
        //               NSLog(@"json file%@",json);
        //
        //        NSArray *json = [NSArray arrayWithObject:json1];
        //
        //        NSString *text = [NSString stringWithFormat:
        //                          @" %@ from %@ needs %@ %@\nYou can help by contributing as little as 25$!",
        //                          [json valueForKey:@"No"]    ,
        //                          [[json objectAtIndex:0] valueForKey:@"MenuCategory"]    ,
        //                          [[json objectAtIndex:0] valueForKey:@"ItemPrice"]    ,
        //                          [[json objectAtIndex:0] valueForKey:@"ItemDescription"]    ,
        //
        //                          nil];
        
        self.detailDescriptionLabel.text = [NSString stringWithFormat:
                                            @"Resturant Name: %@\n\nMenu Category: %@\nMenu Item: %@\n\n--- Item Description ---\n%@\n\nItem Price: %@\n\n\nImage Name: %@",
                                            json[@"paging"][0][@"header"],
                                            json[@"items"][recordID][@"MenuCategory"],
                                            json[@"items"][recordID][@"MenuItem"],
                                            json[@"items"][recordID][@"ItemDescription"],
                                            json[@"items"][recordID][@"ItemPrice"],
                                            json[@"items"][recordID][@"image"][@"image_name"],
                                            nil];
        

    }
    
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Could not parse the JSON feed."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil] show];
        NSLog(@"Exception: %@", exception);
    }
}


@end
