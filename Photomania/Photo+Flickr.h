//
//  Photo+Flickr.h
//  Photomania
//
//  Created by Glauber Lima on 06/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "Photo+CoreDataClass.h"

@interface Photo (Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
       inManagedObjectContext:(NSManagedObjectContext *)context;

+(void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr dictionary
        intoManagedObjectContext:(NSManagedObjectContext *)context;


@end
