//
//  MHSMasterViewController+RestoreCoreDataFromJSONFile.h
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/27/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSMasterViewController.h"

@interface UIViewController (RestoreCoreDataFromJSONFile)
- (void) restoreCoreDataFromJSON:(NSURL *)url;
@end
