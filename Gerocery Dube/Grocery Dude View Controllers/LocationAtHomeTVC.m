//
//  LocationAtHomeTVC.m
//  购物车
//
//  Created by lanmao on 16/1/7.
//  Copyright © 2016年 小霸道. All rights reserved.
//

#import "LocationAtHomeTVC.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "LocationAtHomeVC.h"
#import "LocationAtHome.h"

@interface LocationAtHomeTVC ()

@end

@implementation LocationAtHomeTVC
#pragma mark -- VIEW
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTLOG;
    static NSString *indentifierCellID = @"LocationAtHome Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCellID forIndexPath:indexPath];
    
    LocationAtHome *locationAtHome = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = locationAtHome.storeIn;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTLOG;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        LocationAtHome *locationAtHome = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:locationAtHome];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}
#pragma mark -- DATA
-(void)configureFetch
{
    DTLOG;
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication]delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"storeIn" ascending:YES], nil];
    
    [request setFetchBatchSize:50];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
}
#pragma mark -- INTERACTION
-(IBAction)done:(id)sender
{
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    LocationAtHomeVC *locationAtHomeVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Add Object Segue"]) {
        
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication]delegate] cdh];
        LocationAtHome *newlocationAtHome = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:cdh.context];
        NSError *error = nil;
        if (![cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:newlocationAtHome] error:&error]) {
        }
        locationAtHomeVC.selectedObjectID = newlocationAtHome.objectID;
    }else if ([segue.identifier isEqualToString:@"Edit Object Segue"])
    {
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        locationAtHomeVC.selectedObjectID = [[self.frc objectAtIndexPath:indexpath] objectID];
    }else
    {}
}
@end
