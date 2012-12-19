//
//  SDScaffoldShowViewController.m
//  ParkPro
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "ELCTextFieldCell.h"
#import "SDScaffoldShowViewController.h"

@interface SDScaffoldShowViewController (){
    
    NSArray *attributes;
    NSMutableArray *attributeTypes;
    NSMutableArray *values;
}

@end

@implementation SDScaffoldShowViewController
@synthesize entity;
@synthesize managedObjectContext = _managedObjectContext;
- (id)initWithEntity:(id)e context:(NSManagedObjectContext*)moc{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.allowsSelection = NO;
        self.entity = e;
        self.managedObjectContext = moc;
        attributeTypes = [[NSMutableArray alloc] init];

        
        self.title = [NSString stringWithFormat:@"%@",[[self.entity class] description]];
        NSEntityDescription *entityDescription = [e entity];
        
  
        for (NSPropertyDescription *property in entityDescription) {
            NSLog(@"Property %@",[[[property valueForKey:@"attributeType"] class] description]);
            [attributeTypes addObject:[property valueForKey:@"attributeType"]];
        }
        
        attributes = [[entityDescription attributesByName] allKeys];
        NSLog(@"Array %@",attributes);
        values = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<attributes.count; i++) {
            [values insertObject:@"" atIndex:0];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        //Add Edit Button Here
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editTapped)];
    self.navigationItem.rightBarButtonItem = editButton;

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
    if (self.tableView.editing == YES) {
        static NSString *textFieldID = @"CellText";
        ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:textFieldID];
        if (cell == nil) {
            cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:textFieldID];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.textLabel.text = [[attributes objectAtIndex:indexPath.row] capitalizedString];
        
        cell.rightTextField.placeholder = [[entity valueForKey:[attributes objectAtIndex:indexPath.row]] description];
        
        return cell;
        
    }else{
    
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [[attributes objectAtIndex:indexPath.row] capitalizedString];
        
        cell.detailTextLabel.text = [[entity valueForKey:[attributes objectAtIndex:indexPath.row]] description];
        
        return cell;
    }
        // Configure the cell...
    return nil;
}

- (void)configureEditCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
//    ELCTextFieldCell *c = (ELCTextFieldCell*)cell;
//    c.rightTextField.text = @"";
//    if ([[values objectAtIndex:indexPath.row] isEqualToString:@""]) {
//        c.rightTextField.placeholder = [[attributes objectAtIndex:indexPath.row] description];
//    }else{
//        c.rightTextField.text = [[values objectAtIndex:indexPath.row] description];
//    }
//    
//    static UIDatePicker *datePicker;
//    datePicker =  [[UIDatePicker alloc] init];
//    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
//    
//    switch ([[[entityDescription attributesByName] valueForKey:[attributes objectAtIndex:indexPath.row]] attributeType]) {
//        case 0:
//            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
//            break;
//        case 100:
//            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
//            break;
//        case 200:
//            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
//            break;
//        case 300:
//            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
//            break;
//        case 400:
//            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
//            break;
//        case 500:
//            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
//            break;
//        case 600:
//            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
//            break;
//        case 700:
//            c.rightTextField.keyboardType = UIKeyboardTypeDefault;
//            break;
//        case 800:
//            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
//            break;
//        case 900:
//                //Add Date Picker
//            datePicker.tag = indexPath.row;
//            c.rightTextField.inputView = datePicker;
//            
//            break;
//            
//        default:
//            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
//            break;
//    }
  
    
}


 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
 return NO;
}




- (void)editTapped{
    
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Save"];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        [self.navigationItem.rightBarButtonItem setAction:@selector(saveObject)];
    }
    
    [self.tableView reloadData];

}


#pragma mark - Save Core Data

-(void)saveObject{
    
//    NSManagedObject *managedObject = entity;
//    int i = 0;
//    for (NSString *attribute in attributes) {
//        NSString *stringValue = [[entity valueForKey:[attributes objectAtIndex:i]] description];;
//        NSNumber *intValue = [NSNumber numberWithInt:[[entity valueForKey:[attributes objectAtIndex:i]] integerValue]];
//        NSNumber *floatValue = [NSNumber numberWithFloat:[[entity valueForKey:[attributes objectAtIndex:i]] floatValue]];
//        
//        if ([stringValue length] == 0) {
//            i++;
//        }else{
//            
//            switch ([[attributeTypes objectAtIndex:i] integerValue]) {
//                case 0:
//                    [managedObject setValue:intValue forKey:attribute];
//                    break;
//                case 100:
//                    [managedObject setValue:intValue forKey:attribute];
//                    break;
//                case 200:
//                    [managedObject setValue:intValue forKey:attribute];
//                    break;
//                case 300:
//                    [managedObject setValue:intValue forKey:attribute];
//                    break;
//                case 400:
//                    [managedObject setValue:floatValue forKey:attribute];
//                    break;
//                case 500:
//                    [managedObject setValue:floatValue forKey:attribute];
//                    break;
//                case 600:
//                    [managedObject setValue:floatValue forKey:attribute];
//                    break;
//                case 700:
//                    [managedObject setValue:stringValue forKey:attribute];
//                    break;
//                case 800:
//                    [managedObject setValue:intValue forKey:attribute];
//                    break;
//                case 900:
//                        //Add Date Picker
//                        //                        [managedObject setValue:intValue forKey:attribute];
//                    
//                    break;
//                    
//                default:
//                    [managedObject setValue:stringValue forKey:attribute];
//                    break;
//            }
//            
//            i++;
//        }
//        
//        
//        
//    }
    
    [self.managedObjectContext save:nil];
    
    

        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        [self.navigationItem.rightBarButtonItem setAction:@selector(editTapped)];
    [self.tableView reloadData];
    
}

#pragma mark - ELCTextField Delegate

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue{

        //Convert inValue to correct Type
 
    NSLog(@"IndexPath %d", inIndexPath.row);
        //Update object
    [entity setValue:inValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];

    
    

}


@end
