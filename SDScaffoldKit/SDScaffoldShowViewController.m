//
//  SDScaffoldShowViewController.m
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "SDTextFieldCell.h"
#import "SDScaffoldShowViewController.h"

@interface SDScaffoldShowViewController (){
    
    NSArray *_attributes;
    NSMutableArray *_attributeTypes;
    NSMutableArray *_values;
    NSEntityDescription *_entityDescription;

}

@end

@implementation SDScaffoldShowViewController
@synthesize entity = _entity;
@synthesize entityName = _entityName;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize isEditable = _isEditable;
@synthesize isDeletable = _isDeletable;

- (id)initWithEntity:(id)entity context:(NSManagedObjectContext*)moc{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        //Setup Properties
        self.isDeletable = YES;
        self.isEditable = YES;
        self.entity = entity;
        self.managedObjectContext = moc;
        self.title = self.entityName;
        
        //Setup Insance Variables
        _attributeTypes = [[NSMutableArray alloc] init];
        _entityDescription = [entity entity];
        _attributes = [[_entityDescription attributesByName] allKeys];
        _values = [[NSMutableArray alloc] init];
        
        //Populate AttributeTypes Array
        for (NSPropertyDescription *property in _entityDescription) {
            [_attributeTypes addObject:[property valueForKey:@"attributeType"]];
        }
        
        //Fill Values Array with Dummy Data
        for (int i = 0; i< _attributes.count; i++) {
            [_values insertObject:@"" atIndex:0];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check if isEditable Property is Set
    if (self.isEditable == YES) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editTapped)];
        self.navigationItem.rightBarButtonItem = editButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    //Disable TableView Selection
    self.tableView.allowsSelection = NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.editing == YES) {
        
        //Setup Cell Identifer
        static NSString *textFieldID = @"CellText";
        
        //Try to Dequeue Cell if possible
        SDTextFieldCell *cell = (SDTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:textFieldID];
        
        //If no dequeued cell then create new with indentifer
        if (cell == nil) {
            cell = [[SDTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:textFieldID];
        }
        
        //Configure Edit Cell
        [self configureEditCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    }else{
        
        //Create Cell Identifier
        static NSString *CellIdentifier = @"Cell";
        
        //Try to Dequeue Cell if possible
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //If no dequeued cell then create new with indentifer
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        //Configure Cell
        cell.textLabel.text = [[_attributes objectAtIndex:indexPath.row] capitalizedString];
        cell.detailTextLabel.text = [[_entity valueForKey:[_attributes objectAtIndex:indexPath.row]] description];
       
        return cell;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //Disabled Red Sidebar Icons in Edit Mode
    return NO;
}

- (void)configureEditCell:(SDTextFieldCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
        
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    //Set Text Labels
    cell.textField.text = @"";
    cell.textLabel.text = [[_attributes objectAtIndex:indexPath.row] capitalizedString];
    
    //If there is no value for attribute then put attribute name in placeholder
    if ([[[_entity valueForKey:[_attributes objectAtIndex:indexPath.row]] description] isEqualToString:@""]) {
        cell.textField.placeholder = [[_attributes objectAtIndex:indexPath.row] description];
    } else {
        cell.textField.text = [[_entity valueForKey:[_attributes objectAtIndex:indexPath.row]] description];
    }
    
    //Create UIDatePicker first time and then reference it afterwards
//    static UIDatePicker *datePicker;
//    if (datePicker == nil) {
//        datePicker =  [[UIDatePicker alloc] init];
//        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    }
    
    switch ([[[_entityDescription attributesByName] valueForKey:[_attributes objectAtIndex:indexPath.row]] attributeType]) {
        case 0:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 100:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 200:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 300:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 400:
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 500:
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 600:
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 700:
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case 800:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 900:
//            datePicker.tag = indexPath.row;
//            cell.textField.inputView = datePicker;
            break;
        default:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
    } 
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.isDeletable == NO) {
        return nil;
    }
    
    if (self.tableView.editing == NO) {
        return nil;
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, footer.bounds.size.width - 10 - 10, 45);
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteTapped) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview: button];
    
    return footer;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 75.0;
}


#pragma mark - ELCTextField Delegate

- (void)textFieldCell:(SDTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue{

    NSString *stringValue = [inValue description];
    NSNumber *intValue = [NSNumber numberWithInt:[inValue integerValue]];
    NSNumber *floatValue = [NSNumber numberWithFloat:[inValue floatValue]];

    if (![stringValue length] == 0){

        switch ([[_attributeTypes objectAtIndex:inIndexPath.row] integerValue]) {
            case 0:
                [_entity setValue:intValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 100:
                [_entity setValue:intValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 200:
                [_entity setValue:intValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 300:
                [_entity setValue:intValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 400:
                [_entity setValue:floatValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 500:
                [_entity setValue:floatValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 600:
                [_entity setValue:floatValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 700:
                [_entity setValue:stringValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 800:
                [_entity setValue:intValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 900:
                    //Add Date Picker Support
                break;
                
            default:
                [_entity setValue:stringValue forKey:[[_attributes objectAtIndex:inIndexPath.row] description]];
                break;
        }
    }
}


#pragma mark - Core Data

-(void)saveObject{
    
    //Save Object and Context
    [self.managedObjectContext save:nil];
    
    //Turn off Edit mode and Reload Table
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(editTapped)];
    [self.tableView reloadData];
    
}

- (void)deleteTapped{
    //Delete Object and Save Context
    [self.managedObjectContext deleteObject:_entity];
    [self.managedObjectContext save:nil];
    
    //Pop Navigation Controller
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)editTapped{
    // If Editing mode is off then turn it on
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Save"];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        [self.navigationItem.rightBarButtonItem setAction:@selector(saveObject)];
    }
    
    [self.tableView reloadData];
    
}

@end
