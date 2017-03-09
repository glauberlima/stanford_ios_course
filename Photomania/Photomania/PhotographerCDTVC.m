//
//  PhotographerCDTVC.m
//  Photomania
//
//  Created by Glauber Lima on 07/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "PhotographerCDTVC.h"
#import "Photographer+CoreDataClass.h"
#import "PhotoDatabaseAvailability.h"

@implementation PhotographerCDTVC


-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityContext];
                                                  }];
    
    
    
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    request.fetchLimit = 100;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photographer Cell"];
    
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photographer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld photo(s)", [photographer.photos count]];
    
    return cell;
    
}



@end
