//
//  ViewController.m
//  Imaginarium
//
//  Created by Glauber Lima on 17/02/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
        ivc.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"http://images.apple.com/v/iphone-5s/gallery/a/images/download/%@.jpg", segue.identifier]];
        
        NSLog(@"%@", ivc.imageURL.absoluteURL);
        
        ivc.title = segue.identifier;
        
        
    }
    
}

@end
