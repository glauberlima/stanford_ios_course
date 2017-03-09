//
//  AppDelegate.m
//  Photomania
//
//  Created by Glauber Lima on 03/03/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "PhotomaniaAppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "PhotomaniaAppDelegate+MOC.h"
#import "PhotoDatabaseAvailability.h"


@interface PhotomaniaAppDelegate () <NSURLSessionDownloadDelegate>

@property(copy, nonatomic) void (^flickrDownloadBackgroundURLSessionCompletionHandler)();
@property(strong, nonatomic) NSURLSession *flickrDownloadSession;
@property(strong, nonatomic) NSTimer *flickrForegroundFetchTimer;
@property(strong, nonatomic) NSManagedObjectContext *photoDatabaseContext;

#define FLICKR_FETCH @"Flickr Just Uploaded Fetch"

#define FOREGROUND_FLICKR_FETCH_INTERVAL (20*60)


@end

@implementation PhotomaniaAppDelegate

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self startFlickrFetch];
    completionHandler(UIBackgroundFetchResultNoData);

    
    
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    
    self.flickrDownloadBackgroundURLSessionCompletionHandler = completionHandler;
    
}



-(NSArray *)flickrPhotoAtURL:(NSURL *)url {
    NSData *flickrJsonData = [NSData dataWithContentsOfURL:url];
    NSDictionary *flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJsonData options:0
                                                                         error:NULL];
    
    return [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    if([downloadTask.taskDescription isEqualToString:FLICKR_FETCH]) {
        
        NSManagedObjectContext *context = self.photoDatabaseContext;
        if(context) {
            NSArray *photos = [self flickrPhotoAtURL:location];
            
            [context performBlock:^{
                [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
                [context save:NULL];
            }];
        
            
        }
        else {
            [self flickrDownloadTasksMightBeComplete];
        }
        
    }
    
    
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}


-(void)flickrDownloadTasksMightBeComplete {
    
    if(self.flickrDownloadBackgroundURLSessionCompletionHandler) {
        
        [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
            if(![downloadTasks count]) {
                void (^completionHandler)() = self.flickrDownloadBackgroundURLSessionCompletionHandler;
                self.flickrDownloadBackgroundURLSessionCompletionHandler = nil;
                if(completionHandler) {
                    completionHandler();
                }
            }
        }];
        
        
    }
    
}

-(void)setPhotoDatabaseContext:(NSManagedObjectContext *)photoDatabaseContext {
    
    _photoDatabaseContext = photoDatabaseContext;
    
    NSDictionary *userInfo = self.photoDatabaseContext ? @{ PhotoDatabaseAvailabilityContext : self.photoDatabaseContext } : nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.photoDatabaseContext = [self createMainQueueManagedObjectContext];
    [self startFlickrFetch];

    return YES;
}

- (void)startFlickrFetch {

    [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> *_Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> *_Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> *_Nonnull downloadTasks) {

        if (![downloadTasks count]) {

            NSURLSessionDownloadTask *task = [self.flickrDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = FLICKR_FETCH;
            [task resume];


        } else {
            for (NSURLSessionDownloadTask *task in downloadTasks) [task resume];
        }

    }];

}


- (NSURLSession *)flickrDownloadSession {

    if (!_flickrDownloadSession) {


        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:FLICKR_FETCH];

            urlSessionConfig.allowsCellularAccess = NO;

            _flickrDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:self delegateQueue:nil];

        });

    }

    return _flickrDownloadSession;


}


@end
