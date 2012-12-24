//
//  SDScaffoldShowViewController.h
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "SDTextFieldCell.h"
#import <UIKit/UIKit.h>

@interface SDScaffoldShowViewController : UITableViewController <SDTextFieldCellDelegate>
@property(nonatomic,strong) NSString *entityName;
@property(nonatomic,strong) id entity;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,assign) BOOL isDeletable;
@property(nonatomic,assign) BOOL isEditable;

- (id)initWithEntity:(id)entity context:(NSManagedObjectContext*)moc;
@end
