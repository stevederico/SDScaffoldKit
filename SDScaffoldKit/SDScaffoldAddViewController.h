//
//  SDScaffoldAddViewController.h
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "SDPlaceholderCell.h"
#import <UIKit/UIKit.h>

@interface SDScaffoldAddViewController : UITableViewController <SDTextFieldCellDelegate>
@property(nonatomic,strong) NSString *entityName;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

- (id)initWithEntityName:(NSString*)entityName context:(NSManagedObjectContext*)moc;
- (void)textFieldCell:(SDTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue;
@end
