//
//  Photo+CoreDataProperties.h
//  Photomania
//
//  Created by Glauber Lima on 07/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSString *subtitle;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *unique;
@property (nullable, nonatomic, retain) Photographer *whoTook;

@end

NS_ASSUME_NONNULL_END
