//
//  ViewController.m
//  Shutterbug
//
//  Created by Glauber Lima on 20/02/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIManagedDocument *doc = [[UIManagedDocument alloc] init];
    [doc openWithCompletionHandler:^(BOOL success) {
        code
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
