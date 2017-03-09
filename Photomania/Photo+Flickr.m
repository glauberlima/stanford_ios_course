//
//  Photo+Flickr.m
//  Photomania
//
//  Created by Glauber Lima on 06/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "FlickrFetcher.h"
#import "Photo+CoreDataClass.h"
#import "Photographer+Create.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context {

    Photo *photo = nil;

    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if([matches count] ) {
        photo = [matches firstObject];
    }
    else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        
        photo.unique = unique;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher  URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        
        photo.whoTook = [Photographer photographerWithName:photographerName
                                    inManagedObjectContext:context];
    }


    return photo;


}

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos intoManagedObjectContext:(NSManagedObjectContext *)context {
    
    for(NSDictionary *photo in photos) {
        [self photoWithFlickrInfo:photo inManagedObjectContext:context];
    }

}


@end
