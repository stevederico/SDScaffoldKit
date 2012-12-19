//
//  SDScaffoldAddViewController.m
//  ParkPro
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "SDScaffoldAddViewController.h"

@interface SDScaffoldAddViewController  (){

    NSArray *attributes;
    NSMutableArray *attributeTypes;
    NSMutableArray *values;
    
    NSManagedObject *object;
    
}

@end

@implementation SDScaffoldAddViewController 
@synthesize entityName = _entityName;
@synthesize managedObjectContext = _managedObjectContext;
- (id)initWithEntityName:(NSString*)entityName context:(NSManagedObjectContext*)moc{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.allowsSelection = NO;
        self.entityName = entityName;
        self.managedObjectContext = moc;
        attributeTypes = [[NSMutableArray alloc] init];
        self.title = [NSString stringWithFormat:@"Add %@",self.entityName.capitalizedString];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        for (NSPropertyDescription *property in entityDescription) {
            NSLog(@"Property %@",[[[property valueForKey:@"attributeType"] class] description]);
            [attributeTypes addObject:[property valueForKey:@"attributeType"]];
        }
        attributes = [[entityDescription attributesByName] allKeys];
         NSLog(@"Array %@",attributes);
        values = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<attributes.count; i++) {
            [values insertObject:@"!" atIndex:0];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    return [attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    

    // Configure the cell...
    cell.indexPath = indexPath;
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{

    ELCTextFieldCell *c = (ELCTextFieldCell*)cell;
    c.rightTextField.text = @"";
    if ([[values objectAtIndex:indexPath.row] isEqualToString:@"!"]) {
        c.rightTextField.placeholder = [[attributes objectAtIndex:indexPath.row] description];
    }else{
        c.rightTextField.text = [[values objectAtIndex:indexPath.row] description];
    }
    
    static UIDatePicker *datePicker;
    datePicker =  [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  
       NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
    switch ([[[entityDescription attributesByName] valueForKey:[attributes objectAtIndex:indexPath.row]] attributeType]) {
        case 0:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;   
            break;
        case 100:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 200:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 300:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 400:
            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 500:
            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 600:
            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 700:
            c.rightTextField.keyboardType = UIKeyboardTypeDefault;
            break;
        case 800:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 900:
                //Add Date Picker
            datePicker.tag = indexPath.row;
            c.rightTextField.inputView = datePicker;

            break;
            
        default:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad; 
            break;
    } 
}

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue{

    if ([values count] > 0) {
        [values removeObjectAtIndex:inIndexPath.row];
        [values insertObject:inValue atIndex:inIndexPath.row];
    }else{
        [values insertObject:inValue atIndex:inIndexPath.row];
    
    }
    
}



#pragma mark - Table view delegate

- (void)datePickerValueChanged:(UIDatePicker*)sender{
    
    UIDatePicker *s = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:s.tag inSection:0];
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self textFieldCell:cell updateTextLabelAtIndexPath:indexPath string:s.date.description];
    
    [self.tableView reloadData];
    
}




#pragma mark - Save Core Data

-(void)saveObject{

    NSManagedObject *managedObject = [NSEntityDescription
                                    insertNewObjectForEntityForName:self.entityName
                                    inManagedObjectContext:self.managedObjectContext];
    int i = 0;
    for (NSString *attribute in attributes) {
        NSString *stringValue = [[values objectAtIndex:i] description];
        NSNumber *intValue = [NSNumber numberWithInt:[[values objectAtIndex:i] integerValue]];
        NSNumber *floatValue = [NSNumber numberWithFloat:[[values objectAtIndex:i] floatValue]];
        
        if ([stringValue isEqualToString:@"!"]) {
          i++;
        }else{

            switch ([[attributeTypes objectAtIndex:i] integerValue]) {
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
//                        [managedObject setValue:intValue forKey:attribute];
                    
                    break;
                    
                default:
                    [managedObject setValue:stringValue forKey:attribute];
                    break;
            }
            
            i++;
        }
        
        
        
    }
    
    [self.managedObjectContext save:nil];


}

@end
