//
//  MHSDetailViewController+CreateJSONNodeFromCodeDataRecord.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/25/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSDetailViewController+CreateJSONNodeFromCodeDataRecord.h"



@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return nil;
    return result;
}
@end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Show how to convert it back to JSON Format and UI readable format
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



@implementation MHSDetailViewController (CreateJSONNodeFromCodeDataRecord)


- (void) displayJSONNodeFromCoreDataObject
{

    
    self.detailDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    [self.convertJSON setTitle:@"Convert To Text" forState:UIControlStateNormal];
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [[self.detailItem valueForKey:@"menuItemNumber"] description], @"Item Number",
                          [[self.detailItem valueForKey:@"menuItemCategory"] description], @"Menu Category ",
                                 [[self.detailItem valueForKey:@"menuItemName"] description], @"Menu Item Name",
                                 [[self.detailItem valueForKey:@"menuItemDescription"] description], @"Description",
                          nil];
    
    NSData* jsonData = [info toJSON];  // I am just showing another way to do stuff, you can do it directly or in any different way.......
    //Display the data contents
    self.detailDescriptionLabel.text = [[NSString alloc] initWithData:jsonData    encoding:NSUTF8StringEncoding];
    
    
  
}


@end
