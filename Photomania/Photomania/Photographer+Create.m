//
//  Photographer+Create.m
//  Photomania
//
//  Created by Glauber Lima on 07/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)

+(Photographer *)photographerWithName:(NSString *)name
               inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Photographer *photographer = nil;
    
    if([name length]) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if(![matches count] ) {
            
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
            photographer.name = name;
        }
        else {
            photographer = [matches lastObject];
        }
        
    }
    
    return photographer;
    
}

@end
