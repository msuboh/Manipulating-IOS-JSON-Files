//
//  KababishMenuObject.h
//  AdvanceCSVImportExport
//
//  Created by Maher Suboh on 5/20/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KababishMenuObject : NSObject

@property (nonatomic, retain) NSDate *timeStamp;
//@property (nonatomic, retain) NSNumber *menuItemNumber;
@property (nonatomic, retain) NSString *menuItemNumber;
@property (nonatomic, retain) NSString *menuItemCategory;
@property (nonatomic, retain) NSString *menuItemCategoryOrderIncludes;
@property (nonatomic, retain) NSString *menuItemName;
@property (nonatomic, retain) NSString *menuItemBriefDescription;
@property (nonatomic, retain) NSString *menuItemDescription;
@property (nonatomic, retain) NSString *menuItemSideOrder;
@property (nonatomic, retain) NSString *menuItemPrice;
@property (nonatomic, retain) NSNumber *recordID;


//  menuItemBriefDescription
//  menuItemCategory
//  menuItemCategoryOrderIncludes
//  menuItemDescription
//  menuItemName
//  menuItemNumber
//  menuItemPrice
//  menuItemSideOrder
//  timeStamp

@end
