//
//  SDScaffoldAddViewController.m
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "SDScaffoldAddViewController.h"

@interface SDScaffoldAddViewController  (){

    NSArray *_attributes;
    NSMutableArray *_attributeTypes;
    NSMutableArray *_values;
    NSEntityDescription *_entityDescription;
    
}

@end

@implementation SDScaffoldAddViewController 
@synthesize entityName = _entityName;
@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithEntityName:(NSString*)entityName context:(NSManagedObjectContext*)moc{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        //Setup properties
        self.entityName = entityName;
        self.managedObjectContext = moc;
        self.title = [NSString stringWithFormat:@"Add %@",self.entityName.capitalizedString];
        
        //Initialize instance variables
        _attributeTypes = [[NSMutableArray alloc] init];
        _values = [[NSMutableArray alloc] init];
        
        //Create EntityDescription
        _entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        //Get Attributes from Entity
        _attributes = [[_entityDescription attributesByName] allKeys];
        
        //Fill Values Array with Dummy Data
        for (int i = 0; i< _attributes.count; i++) {
            [_values insertObject:@"" atIndex:0];
        }
        
        //Get Attribute Types from Entity
        for (NSPropertyDescription *property in _entityDescription) {
            [_attributeTypes addObject:[property valueForKey:@"attributeType"]];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Add Save Button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    //Disable row Selection
    self.tableView.allowsSelection = NO;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ELCTextFieldCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    //Clear TextField for a clean slate
    cell.rightTextField.text = @"";
    
    //ELCTextField's Delegate uses the indexPath Property, but it is not being set. This fixes it.
    cell.indexPath = indexPath;
    
    //Check if Values are available for given attribute if not, show attribute name in placeholder
    if ([[_values objectAtIndex:indexPath.row] isEqualToString:@""]) {
        cell.rightTextField.placeholder = [[_attributes objectAtIndex:indexPath.row] description];
    }else{
        cell.rightTextField.text = [[_values objectAtIndex:indexPath.row] description];
    }
    
    //Create Date Picker for Date AttributeType : This is still a bit buggy :/
    static UIDatePicker *datePicker;
    if (datePicker == nil) {
        datePicker =  [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
   
    //Check AttributeType for given attribute, set keyboard accordingly
    switch ([[[_entityDescription attributesByName] valueForKey:[_attributes objectAtIndex:indexPath.row]] attributeType]) {
        case 0:
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 100:
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 200:
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 300:
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 400:
            cell.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 500:
            cell.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 600:
            cell.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 700:
            cell.rightTextField.keyboardType = UIKeyboardTypeDefault;
            break;
        case 800:
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 900:
        //Add Date Picker with tag to refer to in datepicker delegate.
            datePicker.tag = indexPath.row;
            cell.rightTextField.inputView = datePicker;
            break;
        default:
            cell.rightTextField.keyboardType = UIKeyboardTypeDefault; 
            break;
    } 
}

#pragma mark - ELCTextFieldCellDelegate

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue{

    //Add current input to values array, remove old object and insert new until entry is finished.
    if ([_values count] > 0) {
        [_values removeObjectAtIndex:inIndexPath.row];
        [_values insertObject:inValue atIndex:inIndexPath.row];
    }else{
        [_values insertObject:inValue atIndex:inIndexPath.row];
    }
}


#pragma mark - UIDatePicker Delegate

- (void)datePickerValueChanged:(UIDatePicker*)sender{
    
    //Date has been picked
    UIDatePicker *s = sender;
    
    //Create indexPath using DatePicker's tag to ensure correct row
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:s.tag inSection:0];
    
    //Reference cell to be updated
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //Update cell and add date to values instance variable.
    [self textFieldCell:cell updateTextLabelAtIndexPath:indexPath string:s.date.description];
    
    //Refresh to show changes
    [self.tableView reloadData];
}


#pragma mark - Core Data

- (void)saveObject{
    //Create blank NSManagedObject with Entity Description
    NSManagedObject *managedObject = [NSEntityDescription
                                    insertNewObjectForEntityForName:self.entityName
                                    inManagedObjectContext:self.managedObjectContext];
    int i = 0;
    //Loop through each attribute and add values to blank object
    for (NSString *attribute in _attributes) {
        
        //Create String Version of Value for Attribute
        NSString *stringValue = [[_values objectAtIndex:i] description];
        
        //Create Integer Version of Value for Attribute
        NSNumber *intValue = [NSNumber numberWithInt:[[_values objectAtIndex:i] integerValue]];
        
        //Create Float Version of Value for Attribute
        NSNumber *floatValue = [NSNumber numberWithFloat:[[_values objectAtIndex:i] floatValue]];
        
        //Check if value for attribute is not blank if it is, jump to next attribute.
        if (![stringValue isEqualToString:@""]) {
            switch ([[_attributeTypes objectAtIndex:i] integerValue]) {
                case 0:
                    [managedObject setValue:intValue forKey:attribute];
                    break;
                case 100:
                     [managedObject setValue:intValue forKey:attribute];
                    break;
                case 200:
                     [managedObject setValue:intValue forKey:attribute];
                    break;
                case 300:
                     [managedObject setValue:intValue forKey:attribute];
                    break;
                case 400:
                     [managedObject setValue:floatValue forKey:attribute];
                    break;
                case 500:
                     [managedObject setValue:floatValue forKey:attribute];
                    break;
                case 600:
                    [managedObject setValue:floatValue forKey:attribute];
                    break;
                case 700:
                     [managedObject setValue:stringValue forKey:attribute];
                    break;
                case 800:
                     [managedObject setValue:intValue forKey:attribute];
                    break;
                case 900:
                        //Add Date Picker
                    break;
                default:
                    [managedObject setValue:stringValue forKey:attribute];
                    break;
            }//end of switch
        }//end if
    i++;
    }//end for loop
    
    //Save Context with new Object
    [self.managedObjectContext save:nil];

    //Pop back to Index
    [self.navigationController popViewControllerAnimated:YES];

}

@end
