//
//  MHSMasterViewController+BackupCoreDataToJSONFile.m
//  ImportingJSONFile
//
//  Created by Maher Suboh on 5/27/14.
//  Copyright (c) 2014 Maher Suboh. All rights reserved.
//

#import "MHSMasterViewController+BackupCoreDataToJSONFile.h"

@implementation MHSMasterViewController (BackupCoreDataToJSONFile)


- (void) backupCoreDataToJSON
{
    [self clearTmpDirectory];
    
    NSError* error;
    
    NSMutableArray *jsonEntityArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *jsonEntity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:jsonEntity];
    
    for (NSManagedObject *selectedObjects in [context executeFetchRequest:fetchRequest error:&error])
    {
        
        
        
        for (NSPropertyDescription *property in jsonEntity)
        {
            if (property.userInfo[@"ReadableFieldName"] != NULL )
            {
                NSDictionary *attributes = [jsonEntity attributesByName];
                NSAttributeDescription *fieldAttribute = [attributes objectForKey:property.name];
                
                NSString *fieldValue = @"";
                
                if ([fieldAttribute attributeType] == NSDateAttributeType)
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/dd/yyyy"];
                    NSString *dateString = [dateFormat stringFromDate:[selectedObjects valueForKey:property.name]];
                    
                    fieldValue = dateString;
                }
                else
                {

                    if ([property.name isEqualToString:@"menuItemName"])
                         fieldValue =  [NSString stringWithFormat:@"*%@", [[selectedObjects valueForKey:property.name] description] ];
                    else
                         fieldValue =  [[selectedObjects valueForKey:property.name] description];
                }
                
                
                
                NSDictionary *jsonDirtionaryValue = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     fieldValue, @"Field Value",
                                                     property.userInfo[@"ReadableFieldName"], @"Field Title",
                                                     nil];
                
                NSDictionary *jsonDirtionaryNode = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    property.name, @"Field Name" ,
                                                    jsonDirtionaryValue, @"Field Data" ,
                                                    nil];
                
                [jsonEntityArray addObject:jsonDirtionaryNode];
                
                
            }
            
        }
        
        
        
        
    }
    
    
    BOOL isIt_validJSONFormat = [NSJSONSerialization isValidJSONObject:jsonEntityArray];
    if (isIt_validJSONFormat)
    {
        NSLog(@"Valid JSON");
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonEntityArray  options:NSJSONWritingPrettyPrinted error:&error];
        
        
        
        // 1. One way to save JSON Data Array:
        NSString *JSONDataFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"kababishbackup.json"];
        [jsonData writeToFile:JSONDataFile atomically:YES];
        
        //2. Another way to save JSON Data Array
        NSString *streamJSONFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"StreamJSON.json"];
        NSOutputStream *os = [[NSOutputStream alloc] initToFileAtPath:streamJSONFile append:NO];
        [os open];
        [NSJSONSerialization writeJSONObject:jsonEntityArray toStream:os options:NSJSONWritingPrettyPrinted error:nil];
        [os close];
        


        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Confirmation!"
                                                        message:@"\nYour File has been Backed up Successfully!\n\nDo you want to Email your Backup JSON File, for later Restore."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
        [alert show];

        
        

        
        // If you want to read the Streamed JSON Data File back in...
        NSInputStream *is = [[NSInputStream alloc] initWithFileAtPath:streamJSONFile];
        [is open];
        NSDictionary *readDict = [NSJSONSerialization JSONObjectWithStream:is options:0 error:nil];
        [is close];
        NSLog(@"Input: %@", readDict);
        
    }
    else
    {       [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Sorry; Not a Valid JSON format.\nNo file is Saved."
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles: nil] show];
        
        NSLog(@"Invalid JSON");
    }
    
    
}

- (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    { NSLog(@"user pressed Cancel"); }
    else
    { NSLog(@"user pressed OK"); [self emailJSONFile];}
}

- (void)emailJSONFile
{
    
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	
    
    if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Failure"
                                                            message:@"Your device is not setup to send Email!\nPlease Activiate Email Through Settings."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
		}
	}
	else
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Failure"
                                                        message:@"Your device is not setup to send Email!\nPlease Activiate Email Through Settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
	}
    
    
    
}


// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
    
    
    // Attach The CSV File to the email
    NSString *tempFileName = @"kababishbackup.json";
	NSString *tempFile = [NSTemporaryDirectory() stringByAppendingPathComponent:tempFileName];
    
    //    NSFileManager  *manager = [NSFileManager defaultManager];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:tempFile];
    if (!fileExists)
    {
        [[[UIAlertView alloc] initWithTitle:@"Action Status" message:@"You are trying to email an Empty JSON File!\nLoading/Importing and Creating Local JSON File to Email." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
        NSLog(@"Does not Exists");
    }
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Email Data JSON File for Backup"];
    
    NSString *locationEmailAddress1 =  @"xyz@hotmail.com";
    NSString *locationEmailAddress2 =  @"xyz@yahoo.com";
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:locationEmailAddress1];
    NSArray *ccRecipients = [NSArray arrayWithObjects:locationEmailAddress2,  nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    
    
    
    [picker addAttachmentData:[NSData dataWithContentsOfFile:tempFile]
                     mimeType:@"text/json"
                     fileName:@"kababishbackup.json"];
    
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"Emailing Your Data in JSON Format for Backup and Recovery reseaons.\nWe appreciate your opinion and/or any suggestions. We are looking forward to serving you."];
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	NSString *emailMessage = @"Email Result: ";
    switch (result)
	{
		case MFMailComposeResultCancelled:
			emailMessage = [emailMessage stringByAppendingString: @"canceled"];
			break;
		case MFMailComposeResultSaved:
			emailMessage = [emailMessage stringByAppendingString: @"saved"];
			break;
		case MFMailComposeResultSent:
			emailMessage = [emailMessage stringByAppendingString: @"sent"];
			break;
		case MFMailComposeResultFailed:
			emailMessage = [emailMessage stringByAppendingString: @"failed"];
			break;
		default:
			emailMessage =[emailMessage stringByAppendingString: @"not sent"];
			break;
	}
    NSLog(@"%@",emailMessage);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
