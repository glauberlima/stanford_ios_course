//
//  Photographer+Create.h
//  Photomania
//
//  Created by Glauber Lima on 07/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "Photographer+CoreDataClass.h"

@interface Photographer (Create)

+(Photographer *)photographerWithName:(NSString *)name
               inManagedObjectContext:(NSManagedObjectContext *)context;

@end
