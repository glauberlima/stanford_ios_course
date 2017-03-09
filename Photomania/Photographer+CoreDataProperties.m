//
//  Photographer+CoreDataProperties.m
//  Photomania
//
//  Created by Glauber Lima on 07/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "Photographer+CoreDataProperties.h"

@implementation Photographer (CoreDataProperties)

+ (NSFetchRequest<Photographer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photographer"];
}

@dynamic name;
@dynamic photos;

@end
