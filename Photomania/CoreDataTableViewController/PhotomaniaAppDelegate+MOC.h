//
//  PhotomaniaAppDelegate+MOC.h
//  Photomania
//
//  Created by Glauber Lima on 08/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "PhotomaniaAppDelegate.h"

@interface PhotomaniaAppDelegate (MOC)

-(void)saveContext:(NSManagedObjectContext *)managedObjectContext;
-(NSManagedObjectContext *)createMainQueueManagedObjectContext;

@end
