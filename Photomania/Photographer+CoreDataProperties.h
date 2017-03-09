//
//  Photographer+CoreDataProperties.h
//  Photomania
//
//  Created by Glauber Lima on 07/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "Photographer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photographer (CoreDataProperties)

+ (NSFetchRequest<Photographer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Photo *> *photos;

@end

@interface Photographer (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet<Photo *> *)values;
- (void)removePhotos:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
